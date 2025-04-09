use diesel::prelude::*;
use diesel::sql_query;
use diesel::sql_types::Text;
use rocket::response::{status::Created, Debug};
use rocket::serde::json::Json;
use rocket::serde::uuid::Uuid;
use rocket::{get, post, delete};
use rocket_dyn_templates::{context, Template};
use rocket_sync_db_pools::diesel;
use rocket::response::status::{BadRequest, NotFound};
use crate::db::*;
use crate::claims::Claims;
use crate::models::User;
use crate::schema::users::dsl::*;

type Result<T, E = Debug<diesel::result::Error>> = std::result::Result<T, E>;

/// Creates a venue
#[post("/add", format = "json", data = "<arg_user>")]
pub async fn add(arg_user: Json<User>, _user: Claims, tdb: ChacaDB) ->
Result<Created<Json<User>>, BadRequest<String>> {
    let user: User = arg_user.into_inner();
	let result: User = match tdb 
		.run(move |conn| { 
			sql_query("INSERT INTO users VALUES(gen_random_uuid(), $1, $2,
				get_pw_hash($3), $4, $5,
				$6, $7, now(), now()) RETURNING *;")
				.bind::<Text, _>(user.name.expect("Error deserializing user name")) // TODO: send error if None
				.bind::<Text, _>(user.email)
				.bind::<Text, _>(user.password.expect("Error deserializing password"))
				.bind::<Text, _>(user.oauth_provider)
				.bind::<Text, _>(user.oauth_user_id)
				.bind::<Text, _>(user.access_token)
				.bind::<Text, _>(user.refresh_token.expect("Error deserializing refresh_token")) // TODO: send error if None
				.get_result(conn)
			}).await {

        //Ok(r) => r,
        Ok(r) => r,
        Err(e) => return Err(BadRequest(format!("Error creating user: {}", e).to_string())),
    };

    Ok(Created::new("/").body(Json(result)))
}

//https://api.rocket.rs/v0.5/rocket_sync_db_pools/

/// Show the list of venues in HTML
#[get("/")]
pub async fn list(tdb: ChacaDB) -> Template {
    let results =
    tdb.run(move |connection| 
        crate::schema::users::dsl::users
            .load::<User>(connection)
            .expect("Error loading user")
    ).await;
    Template::render("users", context! {users: &results, count: results.len()})
}

/// Get a venue and returns it as a JSON object
#[get("/<userid>")]
pub async fn get(userid: Uuid, tdb: ChacaDB) ->
Result<Json<Vec<User>>, NotFound<String>> {
    let results = tdb.run(move |connection|
        crate::schema::users::dsl::users
            .filter(id.eq(userid))
            .load::<User>(connection)
        .expect("Error loading users")
    ).await;
    if results.len() > 0 {
        Ok(Json(results))
    } else {
        Err(NotFound(format!("Could not find user: {}", userid)))
    }
}

/// Remove a venue
#[delete("/<userid>")]
pub async fn delete(userid: Uuid, _user: Claims, tdb: ChacaDB) ->
Result<Json<String>, NotFound<String>> {
    let results = tdb.run(move |connection|
        diesel::delete(
            crate::schema::users::dsl::users
                .filter(id.eq(userid)))
            .execute(connection)
    ).await;
    if results.unwrap() == 1 {
        Ok(Json(format!("{} deleted", userid)))
    } else {
        Err(NotFound(format!("Could not find user: {}", userid)))
    }
}

