use crate::claims::*;
use crate::users::get;
use crate::db::ChacaDB;
use crate::models::User;
use diesel::sql_query;
use diesel::sql_types::Text;

/// Authentication functionalities
use rocket::{get, post, routes, uri, Request, response::Redirect, State, http::Status};
use rocket::response::status::Custom;
use rocket::response::status;
use rocket::serde::json::Json;
use rocket::http::{Header, Cookie, CookieJar};
use serde::{Deserialize, Serialize};
use rocket_oauth2::{OAuth2, TokenResponse};
use std::sync::Arc;
use reqwest::{Client, Response};
use uuid::Uuid;
use chrono::{DateTime, Local, NaiveDateTime, Utc};

// For Facebook authentication
pub static FACEBOOK_URL: &str = "https://graph.facebook.com/v22.0/me?fields=";

/// Login request object
#[derive(Deserialize)]
pub struct LoginRequest {
    user: String,
    password: String,
}

/// Successful response
#[derive(Serialize)]
pub struct LoginResponse {
    token: String,
}

/*******************************************************************************
*                                                                              *
*                                                                              *
*                   N O R M A L  A U T H E N T I C A T I O N                   *
*                                                                              *
*                                                                              *
********************************************************************************/

/// User authentication, Successful authentication returns a JWT
#[post("/login", data = "<req>")]
pub fn login(req: Json<LoginRequest>, state: &State<AppState>) -> Result<Json<LoginResponse>, Custom<String>> {
    //TODO: use the database
    if req.user != "test" || req.password != "prueba123" {
        return Err(Custom(Status::Unauthorized, "Missing account".to_string()));
    }

    let claim = Claims::from_name(&req.user);
    let response = LoginResponse {
        token: claim.into_token(&state.jwt_secret)?,
    };

    Ok(Json(response))
}

/*******************************************************************************
*                                                                              *
*                                                                              *
*                 F A C E B O O K  A U T H E N T I C A T I O N                 *
*                                                                              *
*                                                                              *
********************************************************************************/


#[get("/login/facebook")]
pub fn facebook_login(oauth2: OAuth2<Facebook>, cookies: &CookieJar<'_>) -> Redirect {
    // Redirect to Facebook for authentication
    println!("COOKIES: {:#?}\n", cookies);
    oauth2.get_redirect(cookies, &["public_profile", "email"]).unwrap()
}

#[get("/auth/facebook")]
pub async fn facebook_callback(
    token: TokenResponse<Facebook>,
    cookies: &CookieJar<'_>,
    state: &State<AppState>,
    cdb: ChacaDB,
) -> Result<Redirect, status::Custom<String>> {
    // Exchange OAuth token for user data
    let user_data = match get_facebook_user_data(&token.access_token(), &state.http_client).await {
        Ok(data) => data,
        Err(e) => return Err(status::Custom(Status::InternalServerError, format!("Failed to get user data: {}", e))),
    };

    let claim = Claims::from_name(&user_data.id);
    println!("USER DATA: \n{:#?}\n", &user_data);
    let jwt_token = claim.into_facebook_token(&user_data, &state.jwt_secret)?;
    // Set the token in a cookie for future checks
    cookies.add(Cookie::new("auth_token", jwt_token.clone()));


    let now: NaiveDateTime = Local::now().naive_local();
    // Check if the user exists in the database
    match User::load_by_oauth(user_data.id.clone(), &cdb).await {
        // Update if exists
        Ok(mut u)  => {
            u.access_token = jwt_token;
            u.updated_at = now;
            u.last_login = Some(Utc::now());
            u.update(&cdb);
        },
        // Insert if it does not exist
        Err(_) => {
            let u = User {
                id: Uuid::new_v4(),
                name: Some(user_data.name),
                profile_picture_url: Some(user_data.picture),
                email: user_data.email.unwrap_or_default(),
                password: None,
                oauth_provider: "facebook".to_string(),
                oauth_user_id: user_data.id.clone(),
                access_token: jwt_token,
                refresh_token: None,
                created_at: now,
                updated_at: now,
                last_login: Some(Utc::now()),
            };
            u.insert(cdb);
        },

    }


    match cookies.get("login_uri") {
        Some(uri_cookie) => {
            let cookie_name = String::from(uri_cookie.name());
            let redirect_uri = String::from(uri_cookie.value());
            cookies.remove(Cookie::named(cookie_name));
            Ok(Redirect::to(redirect_uri))
        },
        None =>  Ok(Redirect::to("/")),
    }
}


/// Get user info from Facebook
async fn get_facebook_user_data(access_token: &str, client: &Client) -> Result<FacebookUserInfo, reqwest::Error> {
    let url = format!("{}{}", FACEBOOK_URL, FACEBOOK_FIELDS);

    // Send access token in the Authorization header instead
    client.get(url)
        .bearer_auth(access_token)  // This adds "Authorization: Bearer {token}" header
        .send()
        .await?
        .json::<FacebookUserInfo>()
        .await
}



/*
    let results = tdb.run(move |connection|
        crate::schema::users::dsl::users
            .filter(id.eq(userid))
            .load::<User>(connection)
        .expect("Error loading users")
    ).await;
    if results.len() > 0 {
        Ok(Json(results))
    } else {
        Err(NotFound(format!("Could not find user: {}", userid)))
    }
*/
