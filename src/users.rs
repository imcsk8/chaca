use diesel::prelude::*;
use diesel::sql_query;
use diesel::sql_types::Text;
use rocket::response::{status::Created, Debug};
use rocket::serde::json::Json;
use rocket::serde::uuid::Uuid;
use rocket::serde::{Deserialize, Serialize};
use rocket::{get, post, delete};
use rocket_dyn_templates::{context, Template};
use rocket_sync_db_pools::diesel;
use rocket::response::status::{BadRequest, NotFound};
use crate::db::*;
use crate::claims::Claims;
use crate::models::User;
use crate::schema::users::dsl::*;
use diesel::result::Error;
//use std::error::Error;

type Result<T, E = Debug<diesel::result::Error>> = std::result::Result<T, E>;

/// Authenticated user for the frontend
#[derive(Debug, Serialize, Deserialize)]
struct AppUser {
    id: String,
    name: String,
    email: Option<String>,
}

/// Creates a user
#[post("/add", format = "json", data = "<arg_user>")]
pub async fn add(arg_user: Json<User>, _user: Claims, tdb: ChacaDB) ->
Result<Created<Json<User>>, BadRequest<String>> {
    let user: User = arg_user.into_inner();
	let result: User = match tdb 
		.run(move |conn| { 
			sql_query("INSERT INTO users VALUES(gen_random_uuid(), $1, $2,
				get_pw_hash($3), $4, $5,
				$6, $7, now(), now(), now()) RETURNING *;")
				.bind::<Text, _>(user.name.expect("Error deserializing user name")) // TODO: send error if None
				.bind::<Text, _>(user.email)
				.bind::<Text, _>(user.password.expect("Error deserializing password"))
				.bind::<Text, _>(user.oauth_provider)
				.bind::<Text, _>(user.oauth_user_id)
				.bind::<Text, _>(user.access_token)
				.bind::<Text, _>(user.refresh_token.expect("Error deserializing refresh_token")) // TODO: send error if None
				.get_result(conn)
			}).await {

        //Ok(r) => r,
        Ok(r) => r,
        Err(e) => return Err(BadRequest(format!("Error creating user: {}", e).to_string())),
    };

    Ok(Created::new("/").body(Json(result)))
}

//https://api.rocket.rs/v0.5/rocket_sync_db_pools/

/// Show the list of users in HTML
#[get("/")]
pub async fn list(tdb: ChacaDB) -> Template {
    let results =
    tdb.run(move |connection| 
        crate::schema::users::dsl::users
            .load::<User>(connection)
            .expect("Error loading user")
    ).await;
    Template::render("users", context! {users: &results, count: results.len()})
}

/// Get a user and returns it as a JSON object
#[get("/<userid>")]
pub async fn get(userid: Uuid, tdb: ChacaDB) ->
Result<Json<Vec<User>>, NotFound<String>> {
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
}

/// Get a user and returns it as a JSON object
#[get("/oauth2/<oauth_id>")]
pub async fn get_by_oauth(oauth_id: String, tdb: ChacaDB) ->
Result<Json<Vec<User>>, NotFound<String>> {
    //TODO: check borrows
    let my_id = oauth_id.clone();
    let results = tdb.run(move |connection|
        crate::schema::users::dsl::users
            .filter(oauth_user_id.eq(oauth_id.clone()))
            .load::<User>(connection)
        .expect("Error loading user")
    ).await;
    if results.len() > 0 {
        Ok(Json(results))
    } else {
        Err(NotFound(format!("Could not find user: {}", my_id)))
    }
}

/// Remove a user
#[delete("/<userid>")]
pub async fn delete(userid: Uuid, _user: Claims, tdb: ChacaDB) ->
Result<Json<String>, NotFound<String>> {
    let results = tdb.run(move |connection|
        diesel::delete(
            crate::schema::users::dsl::users
            .filter(id.eq(userid)))
            .execute(connection)
    ).await;
    if results.unwrap() == 1 {
        Ok(Json(format!("{} deleted", userid)))
    } else {
        Err(NotFound(format!("Could not find user: {}", userid)))
    }
}

#[get("/me")]
pub async fn me(claim: Claims) -> Json<AppUser> {
    Json(AppUser {
        id: claim.id,
        name: claim.name,
        email: claim.email,
    })
}


/*******************************************************************************
*                                                                              *
*                                                                              *
*                      G E N E R A L  F U N C T I O N S                        *
*                                                                              *
*                                                                              *
********************************************************************************/

impl User {
    /// Creates a user
    pub async fn insert(
        self,
        cdb: ChacaDB
    ) -> Result<usize, Error> {
        cdb.run(move |conn| {
                diesel::insert_into(users).values(&self).execute(conn)
        }).await
    }

    /// Updates a user
    pub async fn update(
        self,
        cdb: &ChacaDB
    ) -> Result<usize, Error> {
        cdb.run(move |conn| {
            diesel::update(users)
            .set(self)
            .execute(conn)
        }).await
    }

    pub async fn load_by_oauth(
        oauth_id: String,
        cdb: &ChacaDB
    ) -> Result<Self, NotFound<String>> {
        //TODO: check borrows
        let my_id = oauth_id.clone();
        let results = cdb.run(move |connection|
            crate::schema::users::dsl::users
                .filter(oauth_user_id.eq(oauth_id.clone()))
                .load::<User>(connection)
            .expect("Error loading user")
        ).await;
        if results.len() > 0 {
            Ok(results[0].clone())
        } else {
            Err(NotFound(format!("Could not find user: {}", my_id)))
        }
    }

}
