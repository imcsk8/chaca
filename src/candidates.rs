use crate::claims::Claims;
use chaca_macros::{candidate_details, position_query};
use crate::db::*;
use crate::types::{Positions, Reaction};
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
// TODO: check diesel version use diesel::dsl::DuplicatedKeys;
//use uuid::{parse_str};

type Result<T, E = Debug<diesel::result::Error>> = std::result::Result<T, E>;

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
                "SELECT c.*,
                    s.name as state_name,
                    p.cargo as position_name,
                    d.name as district_name,
                    po.name as poder_name,
                    m.name as matter_name,
                    reactions.like_count as like_count,
                    reactions.dislike_count as dislike_count,
                    reactions.danger_count as danger_count
                FROM candidate c
                JOIN cat_state s ON c.state = s.id_inegi
                JOIN cat_positions p ON c.position = p.id
                LEFT JOIN cat_district d ON c.district = d.id
                JOIN cat_poder po ON c.poder = po.uuid
                LEFT JOIN cat_matter m ON c.matter = m.uuid
                LEFT JOIN LATERAL (
                    SELECT
                        COUNT(CASE WHEN reaction_type = 'LIKE' THEN 1 ELSE NULL END) AS like_count,
                        COUNT(CASE WHEN reaction_type = 'DISLIKE' THEN 1 ELSE NULL END) AS dislike_count,
                        COUNT(CASE WHEN reaction_type = 'DANGER' THEN 1 ELSE NULL END) AS danger_count
                    FROM
                        candidate_reactions
                    WHERE
                        candidate_id = c.id
                ) AS reactions ON true
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
                    CASE
                        WHEN c.sex = 'HOMBRE' THEN concat_ws(' ', p.male_name, p.long_name)
                        WHEN c.sex = 'MUJER' THEN concat_ws(' ', p.female_name, p.long_name)
                        ELSE concat_ws(' ', p.male_name, p.long_name) -- Default fallback
                    END AS position_name,
                    s.name as state_name,
                    d.name as district_name,
                    po.name as poder_name,
                    m.name as matter_name,
                    reactions.like_count as like_count,
                    reactions.dislike_count as dislike_count,
                    reactions.danger_count as danger_count
                FROM candidate c
                JOIN cat_state s ON c.state = s.id_inegi
                JOIN cat_positions p ON c.position = p.id
                LEFT JOIN cat_district d ON c.district = d.id
                JOIN cat_poder po ON c.poder = po.uuid
                LEFT JOIN cat_matter m ON c.matter = m.uuid
                LEFT JOIN LATERAL (
                    SELECT
                        COUNT(CASE WHEN reaction_type = 'LIKE' THEN 1 ELSE NULL END) AS like_count,
                        COUNT(CASE WHEN reaction_type = 'DISLIKE' THEN 1 ELSE NULL END) AS dislike_count,
                        COUNT(CASE WHEN reaction_type = 'DANGER' THEN 1 ELSE NULL END) AS danger_count
                    FROM
                        candidate_reactions
                    WHERE
                        candidate_id = c.id
                ) AS reactions ON true
                WHERE c.state = $1
                ORDER BY c.fullname")
            .bind::<Integer, _>(state_id)
            .load::<CandidateWithDetails>(connection)
            .expect("Error loading candidates with details")
        })
        .await;

    Template::render("candidates_by_state", context! {
        candidates: &results,
        main: "true",
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
                "SELECT c.*,
                    CASE
                        WHEN c.sex = 'HOMBRE' THEN concat_ws(' ', p.male_name, p.long_name)
                        WHEN c.sex = 'MUJER' THEN concat_ws(' ', p.female_name, p.long_name)
                        ELSE concat_ws(' ', p.male_name, p.long_name) -- Default fallback
                    END AS position_name,
                    s.name as state_name,
                    d.name as district_name,
                    po.name as poder_name,
                    m.name as matter_name,
                    reactions.like_count as like_count,
                    reactions.dislike_count as dislike_count,
                    reactions.danger_count as danger_count
                FROM candidate c
                JOIN cat_state s ON c.state = s.id_inegi
                JOIN cat_positions p ON c.position = p.id
                LEFT JOIN cat_district d ON c.district = d.id
                JOIN cat_poder po ON c.poder = po.uuid
                LEFT JOIN cat_matter m ON c.matter = m.uuid
                LEFT JOIN LATERAL (
                    SELECT
                        COUNT(CASE WHEN reaction_type = 'LIKE' THEN 1 ELSE NULL END) AS like_count,
                        COUNT(CASE WHEN reaction_type = 'DISLIKE' THEN 1 ELSE NULL END) AS dislike_count,
                        COUNT(CASE WHEN reaction_type = 'DANGER' THEN 1 ELSE NULL END) AS danger_count
                    FROM
                        candidate_reactions
                    WHERE
                        candidate_id = c.id
                ) AS reactions ON true
                WHERE c.id = $1
                ORDER BY c.fullname")
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
        count: results.len()
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
        count: results.len()
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
        count: results.len()
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
                "SELECT
                    $1 AS candidate_id,
                    COUNT(CASE WHEN reaction_type = 'LIKE' THEN 1 ELSE NULL END) AS like_count,
                    COUNT(CASE WHEN reaction_type = 'DISLIKE' THEN 1 ELSE NULL END) AS dislike_count,
                    COUNT(CASE WHEN reaction_type = 'DANGER' THEN 1 ELSE NULL END) AS danger_count
                FROM
                    candidate_reactions
                WHERE
                    candidate_id = $1"
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
