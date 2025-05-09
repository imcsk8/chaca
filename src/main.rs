extern crate rocket;
use rocket::fs::FileServer;
use rocket::response::Debug;
use rocket::{catch, catchers, launch, routes, uri, Request};
use rocket::response::Redirect;
use rocket_dyn_templates::Template;
use rocket::http::{Cookie, SameSite};
use rocket_oauth2::OAuth2;
use crate::auth::rocket_uri_macro_facebook_login;
use crate::claims::{AppState, Facebook, JwtConfig};
use reqwest::Client;

pub mod candidates;
pub mod auth;
pub mod db;
pub mod claims;
pub mod models;
pub mod schema;
pub mod types;
pub mod users;
//pub mod comments;
//pub mod comment_guard;

pub static STATIC_FILES_DIR: &str = "www/static";

#[launch]
fn rocket() -> _ {
   // Load Rocket's configuration (this will look for Rocket.toml)
    let figment = rocket::Config::figment();

    // Extract JWT configuration from the "jwt" table in Rocket.toml
    let jwt_config: JwtConfig = figment
        .extract_inner("jwt")
        .expect("JWT configuration missing in Rocket.toml");

    let app_state = AppState {
        http_client: Client::new(),
        jwt_secret: jwt_config.secret,
    };

    rocket::build()
        .mount(
            "/",
            routes![
                auth::logout,
                auth::facebook_login,
                auth::facebook_callback,
                auth::logged,
        ])
        .mount(
            "/candidates",
            routes![
                candidates::add,
                candidates::get_json,
                candidates::get_html,
                candidates::list_all,
                candidates::list_by_state,
                candidates::judges_by_state,
                candidates::mtsj_by_state,
                candidates::mtdj_by_state,
                candidates::add_reaction,
                candidates::get_reactions,
                candidates::delete_reaction,
                /* TODO: comments branch comments::add_comment,
                comments::delete_comment,
                comments::get_comments,*/
            ]
        )
        /*.mount(
            "/users",
            routes![users::me,
        ])*/
        .mount("/public", FileServer::from(STATIC_FILES_DIR))
        .manage(app_state)
        .register("/", catchers![unauthorized_catcher])
        .attach(Template::fairing())
        .attach(db::ChacaDB::fairing())
        .attach(OAuth2::<Facebook>::fairing("facebook"))

}

// Catcher that handles auth failures and redirects
#[catch(403)]
fn unauthorized_catcher(req: &Request) -> Redirect {
    //TODO: Try to get the cached redirect
    //req.local_cache(|| Redirect::to(uri!(facebook_login)))
    // TODO: check the use of cache
    let uri = req.uri().to_string();
    let cookies = req.cookies();
    let cookie = Cookie::build(("login_uri", uri.clone()))
        .path("/")
        .secure(false)
        .same_site(SameSite::Lax)
        .http_only(false);
    cookies.add(cookie);
    Redirect::to(uri!(facebook_login))
}
