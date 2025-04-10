use crate::claims::Claims;
use crate::db::*;
use crate::models::Applicant;
use crate::schema::applicants::dsl::*;
use diesel::prelude::*;
use rocket::response::status::NotFound;
use rocket::response::{status::Created, Debug};
use rocket::serde::json::Json;
use rocket::serde::uuid::Uuid;
use rocket::{delete, get, post};
use rocket_dyn_templates::{context, Template};
use rocket_sync_db_pools::diesel;

type Result<T, E = Debug<diesel::result::Error>> = std::result::Result<T, E>;

/// Creates an applicant
#[post("/add", format = "json", data = "<arg_applicant>")]
pub async fn add(arg_applicant: Json<Applicant>, user: Claims, tdb: ApplicantDB) -> Result<Created<Json<Uuid>>> {
    let mut new_applicant: Applicant = arg_applicant.into_inner();
    new_applicant.id = Uuid::new_v4();
    let ret_id = new_applicant.id.clone();
    let applicant_id = tdb
        .run(move |conn| {
            diesel::insert_into(crate::schema::applicants::dsl::applicants)
                .values(&new_applicant)
                .execute(conn)
                .expect("Error saving new applicant");
        })
        .await;

    Ok(Created::new("/").body(Json(ret_id)))
}

//https://api.rocket.rs/v0.5/rocket_sync_db_pools/

/// Show the list of applicants in HTML
#[get("/")]
pub async fn list(tdb: ApplicantDB) -> Template {
    let results = tdb
        .run(move |connection| {
            crate::schema::applicants::dsl::applicants
                .load::<Applicant>(connection)
                .expect("Error loading applicants")
        })
        .await;
    Template::render("applicants", context! {applicants: &results, count: results.len()})
}

/// Get a applicant and returns it as a JSON object
#[get("/<applicantid>", format="json", rank = 1)]
pub async fn get_json(applicantid: Uuid, tdb: ApplicantDB) -> Result<Json<Vec<Applicant>>, NotFound<String>> {
    let results = tdb
        .run(move |connection| {
            crate::schema::applicants::dsl::applicants
                .filter(id.eq(applicantid))
                .load::<Applicant>(connection)
                .expect("Error loading applicants")
        })
        .await;
    if results.len() > 0 {
        Ok(Json(results))
    } else {
        Err(NotFound(format!("Could not find applicant: {}", applicantid)))
    }
}

/// Get a applicant and returns it as a JSON object
#[get("/<applicantid>", format="text/html", rank=2)]
pub async fn get_html(applicantid: Uuid, tdb: ApplicantDB) -> Result<Json<Vec<Applicant>>, NotFound<String>> {
    let results = tdb
        .run(move |connection| {
            crate::schema::applicants::dsl::applicants
                .filter(id.eq(applicantid))
                .load::<Applicant>(connection)
                .expect("Error loading applicants")
        })
        .await;
    if results.len() > 0 {
        Ok(Json(results))
    } else {
        Err(NotFound(format!("Could not find applicant: {}", applicantid)))
    }
}

/// Remove a applicant
#[delete("/<applicantid>")]
pub async fn delete(
    applicantid: Uuid,
    user: Claims,
    tdb: ApplicantDB,
) -> Result<Json<String>, NotFound<String>> {
    let results = tdb
        .run(move |connection| {
            diesel::delete(crate::schema::applicants::dsl::applicants.filter(id.eq(applicantid)))
                .execute(connection)
        })
        .await;
    if results.unwrap() == 1 {
        Ok(Json(format!("{} deleted", applicantid)))
    } else {
        Err(NotFound(format!("Could not find applicant: {}", applicantid)))
    }
}
