extern crate rocket;
use rocket::fs::FileServer;
use rocket::response::Debug;
use rocket::{catch, catchers, launch, routes, uri, Request};
use rocket::response::Redirect;
use rocket_dyn_templates::Template;
use rocket::http::Cookie;
use rocket_oauth2::OAuth2;
use crate::auth::rocket_uri_macro_facebook_login;
use crate::claims::{AppState, Facebook, JwtConfig};
use reqwest::Client;
use serde::{Deserialize, Serialize};

type Result<T, E = Debug<diesel::result::Error>> = std::result::Result<T, E>;

pub mod candidates;
pub mod auth;
pub mod db;
pub mod claims;
pub mod models;
pub mod schema;
pub mod types;
pub mod users;

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
    .mount("/", routes![auth::login, auth::facebook_login,
                            auth::facebook_callback])
        .mount(
            "/candidates",
            routes![candidates::add, candidates::delete, candidates::get_json,
                candidates::get_html, candidates::list_all, candidates::list_by_state,
                candidates::get_current_user],
        )
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
    // Try to get the cached redirect
    //req.local_cache(|| Redirect::to(uri!(facebook_login)))
    // TODO: check the use of cache
    let uri = req.uri().to_string();
    let cookies = req.cookies();
    cookies.add(Cookie::new("login_uri", uri.clone()));
    println!("REQUEST: \n{:#?}\n", req);
    Redirect::to(uri!(facebook_login))
}
