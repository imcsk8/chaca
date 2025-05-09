use crate::claims::Claims;
use crate::comment_guard::*;
use crate::db::*;
use crate::models::Comment;
use crate::schema::comments::dsl::*;
use crate::types::{Positions, Reaction, ResourceType, Result};
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
use rocket::catch;
use diesel::sql_types::{BigInt, Uuid as SqlUuid};
use diesel::QueryableByName;


/*******************************************************************************
*                                                                              *
*                                                                              *
*                        C O M M E N T  E N D P O I N T S                      *
*                                                                              *
*                                                                              *
********************************************************************************/

// TODO: fix comment_guard module
/// Adds a candidate comment
//#[put("/<candidate_id_req>/comment", format = "json", data = "<candidate_comment>")]
#[put("/<candidate_id_req>/comment", format = "json")]
pub async fn add_comment(
    candidate_id_req: Uuid,
    user: Claims,
    cdb: ChacaDB,
    comment_guard: CommentGuard
    //candidate_comment: Json<CandidateCommentPayload>,
) -> Result<Custom<String>> {
    let input_comment = comment_guard.0; // Validated payload
    let resource_type_val = ResourceType::from(input_comment.resource_type);
    cdb.run(move |conn| {
        use crate::schema::comments::dsl::*;
        match diesel::insert_into(comments)
            .values((
                candidate_id.eq(candidate_id_req),
                user_id.eq(input_comment.user_id),
                user_name.eq(user.name),
                resource_type.eq(resource_type_val),
                content.eq(input_comment.comment_text)
            ))
            .execute(conn)
            {
            //TODO: check this option Ok(_) => Ok(Custom(Status::Created, format!("Comment Added"))),
            Ok(_) => Ok(Custom(Status::Created, format!("Comment Added"))),
            Err(e) => {
                // If the user already reacted remove any comment and
                use log::info;
                info!("Error this should not happen {}", e);
                Ok(Custom(Status::Accepted, format!("Error inserting comment...")))
            },
        }
    })
    .await
}


/// gets a candidate comments
#[get("/<candidate_id_req>/comments", format = "json", rank=1)]
pub async fn get_comments(
    candidate_id_req: Uuid,
    cdb: ChacaDB,
) -> Result<Json<Vec<Comment>>, NotFound<String>> {

    let results = cdb
        .run(move |connection| {
            crate::schema::comments::dsl::comments
                .filter(candidate_id.eq(candidate_id_req))
                .load::<Comment>(connection)
            .expect("Error loading comments")
        })
        .await;

    if results.len() > 0 {
        Ok(Json(results))
    } else {
        Err(NotFound(format!("Could not find comments for user: {}", candidate_id_req)))
    }
}


/// Removes a candidate comment
#[delete("/<candidate_id_req>/comment/<comment_id_req>", format = "json", data = "<candidate_comment>")]
pub async fn delete_comment(
    candidate_id_req: Uuid,
    comment_id_req: i32,
    user: Claims,
    cdb: ChacaDB,
    candidate_comment: Json<CandidateCommentPayload>
) -> Result<Json<String>, NotFound<String>> {
    let input_comment = candidate_comment.into_inner();
    let results = cdb.run(move |conn| {
        use crate::schema::comments::dsl::*;
        diesel::delete(comments)
            .filter(candidate_id.eq(&candidate_id_req))
            .filter(comment_id.eq(&comment_id_req))
            .filter(user_id.eq(&input_comment.user_id))
            /*.filter(user_id.eq(&user.uuid)) TODO: set the uuid on the request guard to prevent user injection from frontend User::load_by_oaeth*/
            .execute(conn)
    })
    .await;

    if results.unwrap() == 1 {
        Ok(Json("Comment removed".to_string()))
    } else {
        Err(NotFound("Could not find the comment".to_string()))
    }
}


