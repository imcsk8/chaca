extern crate rocket;
use rocket::fs::FileServer;
use rocket::response::Debug;
use rocket::{launch, routes};
use rocket::get;
use rocket_dyn_templates::Template;
//https://rocket.rs/guide/v0.5/requests/

type Result<T, E = Debug<diesel::result::Error>> = std::result::Result<T, E>;

pub mod auth;
pub mod claims;
pub mod db;
pub mod models;
pub mod schema;
pub mod applicants;

pub static STATIC_FILES_DIR: &str = "www/static";

#[launch]
fn rocket() -> _ {
    rocket::build()
		.mount("/", routes![auth::login])
        .mount(
            "/applicants",
            routes![applicants::add, applicants::delete, applicants::get_json,
                applicants::get_html, applicants::list],
        )
        .mount("/public", FileServer::from(STATIC_FILES_DIR))
        .attach(Template::fairing())
        .attach(db::ChacaDB::fairing())

}
