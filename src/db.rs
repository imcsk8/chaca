use rocket_sync_db_pools::database;
use rocket_sync_db_pools::diesel;

#[database("postgres")]
pub struct ChacaDB(diesel::PgConnection);
