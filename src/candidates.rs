use crate::claims::Claims;
use crate::db::*;
use crate::models::Candidate;
use crate::schema::candidate::dsl::*;
use diesel::prelude::*;
use rocket::response::status::NotFound;
use rocket::response::{status::Created, Debug};
use rocket::serde::json::Json;
use rocket::serde::uuid::Uuid;
use rocket::{delete, get, post};
use rocket_dyn_templates::{context, Template};
use rocket_sync_db_pools::diesel;
use serde_json::json;

type Result<T, E = Debug<diesel::result::Error>> = std::result::Result<T, E>;

/// Creates an candidate
#[post("/add", format = "json", data = "<arg_candidate>")]
pub async fn add(arg_candidate: Json<Candidate>, user: Claims, cdb: ChacaDB) -> Result<Created<Json<Uuid>>> {
    let mut new_candidate: Candidate = arg_candidate.into_inner();
    new_candidate.id = Uuid::new_v4();
    new_candidate.raw_data = Some(json!(new_candidate.raw_data));
    let ret_id = new_candidate.id.clone();
    let candidate_id = cdb
        .run(move |conn| {
            diesel::insert_into(crate::schema::candidate::dsl::candidate)
                .values(new_candidate)
                .execute(conn)
                .expect("Error saving new candidate");
        })
        .await;

    Ok(Created::new("/").body(Json(ret_id)))
}

//https://api.rocket.rs/v0.5/rocket_sync_db_pools/

/// Show the list of candidate in HTML
#[get("/")]
pub async fn list(cdb: ChacaDB) -> Template {
    let results = cdb
        .run(move |connection| {
            crate::schema::candidate::dsl::candidate
                .select(Candidate::as_select())
                .load::<Candidate>(connection)
                .expect("Error loading candidate")
        })
        .await;
    Template::render("candidate", context! {candidate: &results, count: results.len()})
}

/// Get a candidate and returns it as a JSON object
#[get("/<candidateid>", format="json", rank = 1)]
pub async fn get_json(candidateid: Uuid, cdb: ChacaDB) -> Result<Json<Vec<Candidate>>, NotFound<String>> {
    let results = cdb
        .run(move |connection| {
            crate::schema::candidate::dsl::candidate
                .filter(id.eq(candidateid))
                .load::<Candidate>(connection)
                .expect("Error loading candidate")
        })
        .await;
    if results.len() > 0 {
        Ok(Json(results))
    } else {
        Err(NotFound(format!("Could not find candidate: {}", candidateid)))
    }
}

/// Get a candidate and returns it as a JSON object
#[get("/<candidateid>", format="text/html", rank=2)]
pub async fn get_html(candidateid: Uuid, cdb: ChacaDB) -> Result<Json<Vec<Candidate>>, NotFound<String>> {
    let results = cdb
        .run(move |connection| {
            crate::schema::candidate::dsl::candidate
                .filter(id.eq(candidateid))
                .load::<Candidate>(connection)
                .expect("Error loading candidate")
        })
        .await;
    if results.len() > 0 {
        Ok(Json(results))
    } else {
        Err(NotFound(format!("Could not find candidate: {}", candidateid)))
    }
}

/// Remove a candidate
#[delete("/<candidateid>")]
pub async fn delete(
    candidateid: Uuid,
    user: Claims,
    cdb: ChacaDB,
) -> Result<Json<String>, NotFound<String>> {
    let results = cdb
        .run(move |connection| {
            diesel::delete(crate::schema::candidate::dsl::candidate.filter(id.eq(candidateid)))
                .execute(connection)
        })
        .await;
    if results.unwrap() == 1 {
        Ok(Json(format!("{} deleted", candidateid)))
    } else {
        Err(NotFound(format!("Could not find candidate: {}", candidateid)))
    }
}
