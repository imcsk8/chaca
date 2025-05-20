use crate::claims::Claims;
use chaca_macros::{
    candidate_details,
    federal_candidate_details,
    position_query,
    all_candidates,
    list_by_state_query,
    list_all_federal_query,
    candidate_profile_query,
    candidate_reactions_query,
};
use crate::db::*;
use crate::types::{Positions, Reaction, Result};
use crate::models::{Candidate, CandidateReaction};
//use crate::schema::candidate::dsl::*;
use crate::schema::candidate;
use crate::schema::candidate_reactions;
use diesel::prelude::*;
use rocket::response::{Debug, Redirect};
use rocket::response::status::{Created, Custom, NotFound};
use rocket::serde::json::Json;
use rocket::serde::uuid::Uuid;
use rocket::{delete, get, post, put};
use rocket_dyn_templates::{context, Template};
use rocket_sync_db_pools::diesel;
use rocket::http::Status;
use serde_json::json;
use rocket::serde::{Deserialize, Serialize};
use diesel::sql_types::{BigInt, Uuid as SqlUuid};
use diesel::QueryableByName;


#[derive(Queryable, QueryableByName, Serialize, Deserialize, Debug)]
pub struct CandidateReactions {
    #[diesel(sql_type = SqlUuid)]
    pub candidate_id: uuid::Uuid,
    #[diesel(sql_type = BigInt)]
    pub like_count: i64,
    #[diesel(sql_type = BigInt)]
    pub dislike_count: i64,
    #[diesel(sql_type = BigInt)]
    pub danger_count: i64,
}

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


/*******************************************************************************
*                                                                              *
*                                                                              *
*                           L I S T   F U N C T I O N S                        *
*                                                                              *
*                                                                              *
********************************************************************************/

/// Show all candidates
#[get("/")]
pub async fn list_all(cdb: ChacaDB) -> Template {
    let results = cdb
        .run(move |connection| {

            // Shows the CandidateWithDetails structure and needed modules
            candidate_details!();

            // Build the query with JOINs for all foreign keys
            diesel::sql_query(
                all_candidates!()
            )
            .load::<CandidateWithDetails>(connection)
            .expect("Error loading candidates with details")
        })
        .await;

    Template::render("full_list", context! {
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
                list_by_state_query!()
            )
            .bind::<Integer, _>(state_id)
            .load::<CandidateWithDetails>(connection)
            .expect("Error loading candidates with details")
        })
        .await;

    Template::render("candidates_by_state", context! {
        candidates: &results,
        main: "true",
        count: results.len(),
        all: "true",
    })
}

/// Show federal candidates
//#[get("/<state_id>")]
#[get("/federal")]
pub async fn list_all_federal(cdb: ChacaDB) -> Template {
    let results = cdb
        .run(move |connection| {
            // Shows the FederalCandidateWithDetails structure and needed modules
            federal_candidate_details!();
            // Build the query with JOINs for all foreign keys
            diesel::sql_query(
                list_all_federal_query!()
            )
            .load::<FederalCandidateWithDetails>(connection)
            .expect("Error loading candidates with details")
        })
        .await;

    Template::render("candidates_federal", context! {
        candidates: &results,
        main: "true",
        count: results.len(),
        all: "true",
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
#[get("/<candidate_id>", format="text/html", rank=2)]
pub async fn get_html(candidate_id: Uuid, cdb: ChacaDB) -> Result<Template, NotFound<String>> {
    // Shows the CandidateWithDetails structure and needed modules
    candidate_details!();
    let results = cdb
        .run(move |connection| {
            // Shows the CandidateWithDetails structure and needed modules
            candidate_details!();
            // Build the query with JOINs for all foreign keys
            diesel::sql_query(
                candidate_profile_query!()
            )
            .bind::<Uuid, _>(candidate_id)
            .load::<CandidateWithDetails>(connection)
            .expect("Error loading candidates with details")
        })
        .await;

    if results.len() > 0 {
        Ok(
            Template::render("candidate_profile", context! {
                candidate: &results[0],
                count: results.len()
            })
        )
    } else {
        Err(NotFound(format!("Could not find candidate: {}", candidate_id)))
    }
}

/// Remove a candidate
/*#[delete("/<candidateid>")]
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
*/


/*******************************************************************************
*                                                                              *
*                                                                              *
*                      P O S I T I O N  E N D P O I N T S                      *
*                                                                              *
*                                                                              *
********************************************************************************/



/// Show candidates for judge given in `<state_id>`
#[get("/judges/<state_id>")]
pub async fn judges_by_state(state_id: i32, cdb: ChacaDB) -> Template {
    let results = cdb
        .run(move |connection| {
            // Shows the CandidateWithDetails structure and needed modules
            candidate_details!();
            // Build the query with JOINs for all foreign keys
            diesel::sql_query(
                position_query!(Positions::JuezPrimera)
            )
            .bind::<Integer, _>(state_id)
            .load::<CandidateWithDetails>(connection)
            .expect("Error loading candidates with details")
        })
        .await;

    Template::render("candidates_by_state", context! {
        candidates: &results,
        count: results.len(),
        judges: "true",
    })
}

/// Show candidates for mtsj given in `<state_id>`
#[get("/mtsj/<state_id>")]
pub async fn mtsj_by_state(state_id: i32, cdb: ChacaDB) -> Template {
    let results = cdb
        .run(move |connection| {
            // Shows the CandidateWithDetails structure and needed modules
            candidate_details!();
            diesel::sql_query(
                position_query!(Positions::Mtsj)
            )
            .bind::<Integer, _>(state_id)
            .load::<CandidateWithDetails>(connection)
            .expect("Error loading candidates with details")
        })
        .await;

    Template::render("candidates_by_state", context! {
        candidates: &results,
        count: results.len(),
        mtsj: "true",
    })
}

/// Show candidates for mtdj given in `<state_id>`
#[get("/mtdj/<state_id>")]
pub async fn mtdj_by_state(state_id: i32, cdb: ChacaDB) -> Template {
    let results = cdb
        .run(move |connection| {
            // Shows the CandidateWithDetails structure and needed modules
            candidate_details!();
            diesel::sql_query(
                position_query!(Positions::Mtdj)
            )
            .bind::<Integer, _>(state_id)
            .load::<CandidateWithDetails>(connection)
            .expect("Error loading candidates with details")
        })
        .await;

    Template::render("candidates_by_state", context! {
        candidates: &results,
        count: results.len(),
        mtdj: "true",
    })
}


/*******************************************************************************
*                                                                              *
*                                                                              *
*                      R E A C T I O N  E N D P O I N T S                      *
*                                                                              *
*                                                                              *
********************************************************************************/


#[derive(Debug, Serialize, Deserialize)]
pub struct CandidateReactionPayload {
    pub user_id: Uuid,
    pub candidate_id: Uuid,
    pub oauth_user_id: String,
    pub reaction_type: Reaction,
}

/// Adds a candidate reaction
#[put("/<candidate_id_req>/reaction", format = "json", data = "<candidate_reaction>")]
pub async fn add_reaction(
    candidate_id_req: Uuid,
    user: Claims,
    cdb: ChacaDB,
    candidate_reaction: Json<CandidateReactionPayload>
) -> Result<Custom<String>> {

    let input_reaction = candidate_reaction.into_inner();
    let reaction_type_val = Reaction::from(input_reaction.reaction_type);
    // For upsert
    let ID_CONSTRAINT: &str = "candidate_reactions_candidate_id_user_id_reaction_type_key";

    cdb.run(move |conn| {
        use crate::schema::candidate_reactions::dsl::*;
        match diesel::insert_into(candidate_reactions)
            .values((
                candidate_id.eq(&candidate_id_req),
                user_id.eq(input_reaction.user_id),
                reaction_type.eq(reaction_type_val)
            ))
            //.on_conflict(diesel::upsert::on_constraint(ID_CONSTRAINT))
            .on_conflict((user_id, candidate_id))
            .do_update()
            .set(reaction_type.eq(reaction_type_val))
            .execute(conn) {
            Ok(_) => Ok(Custom(Status::Created, format!("Reaction Added"))),
            Err(e) => {
                // If the user already reacted remove any reaction and
                use log::info;
                info!("Error this should not happen {}", e);
                Ok(Custom(Status::Accepted, format!("Error upserting...")))
            },
        }
    })
    .await
}


/// gets a candidate reactions
#[get("/<candidate_id>/reactions", format = "json", rank=1)]
pub async fn get_reactions(
    candidate_id: Uuid,
    cdb: ChacaDB,
) -> Result<Json<CandidateReactions>> {

    let results = cdb
        .run(move |connection| {
            // Shows the CandidateReactions structure and needed modules
            //TODO: mover los elementos de candidatereactions a esta macro: candidate_reactions!();
            // Build the query with JOINs for all foreign keys
            diesel::sql_query(
                candidate_reactions_query!()
            )
            .bind::<SqlUuid, _>(candidate_id)
            .get_result::<CandidateReactions>(connection)
            .expect("Error loading candidate reactions")
        })
        .await;
    Ok(Json(results))
}


/// Removes a candidate reaction
#[delete("/<candidate_id>/reaction", format = "json", data = "<candidate_reaction>")]
pub async fn delete_reaction(
    candidate_id: Uuid,
    user: Claims,
    cdb: ChacaDB,
    candidate_reaction: Json<CandidateReactionPayload>
) -> Result<Json<String>, NotFound<String>> {
    let input_reaction = candidate_reaction.into_inner();
    let reaction_type_val = Reaction::from(input_reaction.reaction_type);
    let results = cdb.run(move |conn| {
        use crate::schema::candidate_reactions::dsl::*;
        diesel::delete(candidate_reactions)
            .filter(user_id.eq(&user_id))
            .filter(candidate_id.eq(&candidate_id))
            .filter(reaction_type.eq(&reaction_type_val))
            .execute(conn)
    })
    .await;

    if results.unwrap() == 1 {
        Ok(Json("Reaction removed".to_string()))
    } else {
        Err(NotFound("Could not find the reaction".to_string()))
    }
}
