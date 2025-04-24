use crate::claims::Claims;
use chaca_macros::candidate_details;
use crate::db::*;
use crate::models::Candidate;
//use crate::schema::candidate::dsl::*;
use crate::schema::candidate;
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
/*
#[get("/")]
pub async fn list(cdb: ChacaDB) -> Template {
    let results = cdb
        .run(move |connection| {
            crate::schema::candidate::dsl::candidate
                .load::<Candidate>(connection)
                .expect("Error loading candidate")
        })
        .await;
    println!("RESULT? {:?}", results);
    Template::render("candidates", context! {candidates: &results, count: results.len()})
}
*/

/// Show all candidates
#[get("/")]
pub async fn list_all(cdb: ChacaDB) -> Template {
    let results = cdb
        .run(move |connection| {

            // Shows the CandidateWithDetails structure and needed modules
            candidate_details!();

            // Build the query with JOINs for all foreign keys
            diesel::sql_query(
                "SELECT c.*,
                    s.name as state_name,
                    p.cargo as position_name,
                    d.name as district_name,
                    po.name as poder_name,
                    m.name as matter_name
                FROM candidate c
                JOIN cat_state s ON c.state = s.id_inegi
                JOIN cat_positions p ON c.position = p.id
                LEFT JOIN cat_district d ON c.district = d.id
                JOIN cat_poder po ON c.poder = po.uuid
                LEFT JOIN cat_matter m ON c.matter = m.uuid
                ORDER BY c.fullname"
            )
            .load::<CandidateWithDetails>(connection)
            .expect("Error loading candidates with details")
        })
        .await;

    Template::render("candidates", context! {
        candidates: &results,
        count: results.len()
    })
}

/// Show candidates given in `<state_id>`
#[get("/<state_id>")]
pub async fn list_by_state(state_id: i32, cdb: ChacaDB) -> Template {
    let results = cdb
        .run(move |connection| {
            // Shows the CandidateWithDetails structure and needed modules
            candidate_details!();
            // Build the query with JOINs for all foreign keys
            diesel::sql_query(
                "SELECT c.*,
                    s.name as state_name,
                    p.cargo as position_name,
                    d.name as district_name,
                    po.name as poder_name,
                    m.name as matter_name
                FROM candidate c
                JOIN cat_state s ON c.state = s.id_inegi
                JOIN cat_positions p ON c.position = p.id
                LEFT JOIN cat_district d ON c.district = d.id
                JOIN cat_poder po ON c.poder = po.uuid
                LEFT JOIN cat_matter m ON c.matter = m.uuid
                WHERE c.state = 8
                ORDER BY c.fullname")
            .bind::<Integer, _>(state_id)
            .load::<CandidateWithDetails>(connection)
            .expect("Error loading candidates with details")
        })
        .await;

    Template::render("candidates_by_state", context! {
        candidates: &results,
        count: results.len()
    })
}



/// Get a candidate and returns it as a JSON object
#[get("/<candidateid>", format="json", rank = 1)]
pub async fn get_json(candidateid: Uuid, cdb: ChacaDB) -> Result<Json<Vec<Candidate>>, NotFound<String>> {
    let results = cdb
        .run(move |connection| {
            crate::schema::candidate::dsl::candidate
                .filter(crate::schema::candidate::id.eq(candidateid))
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
pub async fn get_html(candidateid: Uuid, cdb: ChacaDB) -> Result<Template, NotFound<String>> {
    let results = cdb
        .run(move |connection| {
            crate::schema::candidate::dsl::candidate
                .filter(crate::schema::candidate::id.eq(candidateid))
                .load::<Candidate>(connection)
                .expect("Error loading candidate")
        })
        .await;
    if results.len() > 0 {
        Ok(

    Template::render("candidate_profile", context! {
        candidates: &results,
        count: results.len()
    })
        )
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
            diesel::delete(crate::schema::candidate::dsl::candidate.filter(crate::schema::candidate::id.eq(candidateid)))
                .execute(connection)
        })
        .await;
    if results.unwrap() == 1 {
        Ok(Json(format!("{} deleted", candidateid)))
    } else {
        Err(NotFound(format!("Could not find candidate: {}", candidateid)))
    }
}
