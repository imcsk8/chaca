extern crate rocket;
use rocket::fs::FileServer;
use rocket::response::Debug;
use rocket::{launch, routes};
use rocket::get;
use rocket_dyn_templates::Template;
//https://rocket.rs/guide/v0.5/requests/

type Result<T, E = Debug<diesel::result::Error>> = std::result::Result<T, E>;

pub mod candidates;
pub mod auth;
pub mod db;
pub mod claims;
pub mod models;
pub mod schema;
pub mod types;

pub static STATIC_FILES_DIR: &str = "www/static";

#[launch]
fn rocket() -> _ {
    rocket::build()
		.mount("/", routes![auth::login])
        .mount(
            "/candidates",
            routes![candidates::add, candidates::delete, candidates::get_json,
                candidates::get_html, candidates::list_all, candidates::list_by_state],
        )
        .mount("/public", FileServer::from(STATIC_FILES_DIR))
        .attach(Template::fairing())
        .attach(db::ChacaDB::fairing())

}
