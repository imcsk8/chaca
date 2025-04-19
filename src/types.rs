// In your schema.rs or a dedicated types.rs file
use diesel::prelude::*;
use diesel::pg::PgConnection;
use diesel::serialize::{self, IsNull, Output, ToSql};
use diesel::deserialize::{self, FromSql};
use diesel::sql_types::*;
use diesel::pg::Pg;
use std::io::Write;

// Step 1: Define the SQL type
#[derive(SqlType, Debug)]
#[diesel(postgres_type(name = "reaction"))]
pub struct Reaction;

// Step 2: Create the Rust enum
#[derive(Debug, Clone, Copy, PartialEq, Eq, AsExpression, FromSqlRow)]
#[diesel(sql_type = Reaction)]
pub enum ReactionEnum {
    Like,
    Love,
    Laugh,
    Dislike,
    Bad,
    Danger,
}

// Step 3: Implementation for serialization (Rust -> DB)
impl ToSql<Reaction, Pg> for ReactionEnum {
    fn to_sql<'b>(&'b self, out: &mut Output<'b, '_, Pg>) -> serialize::Result {
        match *self {
            ReactionEnum::Like => out.write_all(b"LIKE")?,
            ReactionEnum::Love => out.write_all(b"LOVE")?,
            ReactionEnum::Laugh => out.write_all(b"LAUGH")?,
            ReactionEnum::Dislike => out.write_all(b"DISLIKE")?,
            ReactionEnum::Bad => out.write_all(b"BAD")?,
            ReactionEnum::Danger => out.write_all(b"DANGER")?,
        }
        Ok(IsNull::No)
    }
}

// Step 4: Implementation for deserialization (DB -> Rust)
impl FromSql<Reaction, Pg> for ReactionEnum {
    fn from_sql(bytes: Option<&[u8]>) -> deserialize::Result<Self> {
        match not_none!(bytes) {
            b"LIKE" => Ok(ReactionEnum::Like),
            b"LOVE" => Ok(ReactionEnum::Love),
            b"LAUGH" => Ok(ReactionEnum::Laugh),
            b"DISLIKE" => Ok(ReactionEnum::Dislike),
            b"BAD" => Ok(ReactionEnum::Bad),
            b"DANGER" => Ok(ReactionEnum::Danger),
            _ => Err("Unrecognized enum variant".into()),
        }
    }
}


// Step 1: Define the SQL type
#[derive(SqlType, Debug)]
#[diesel(postgres_type(name = "sexo"))]
pub struct Sexo;

// Step 2: Create the Rust enum
#[derive(Debug, Clone, Copy, PartialEq, Eq, AsExpression, FromSqlRow)]
#[diesel(sql_type = Sexo)]
pub enum SexoEnum {
    Hombre,
    Mujer,
}

// Step 3: Implementation for serialization (Rust -> DB)
impl ToSql<Sexo, Pg> for SexoEnum {
    fn to_sql<'b>(&'b self, out: &mut Output<'b, '_, Pg>) -> serialize::Result {
        match *self {
            SexoEnum::Like => out.write_all(b"HOMBRE")?,
            Sexo::Love => out.write_all(b"MUJER")?,
        }
        Ok(IsNull::No)
    }
}

// Step 4: Implementation for deserialization (DB -> Rust)
impl FromSql<Sexo, Pg> for SexoEnum {
    fn from_sql(bytes: Option<&[u8]>) -> deserialize::Result<Self> {
        match not_none!(bytes) {
            b"HOMBRE" => Ok(SexoEnum::Hombre),
            b"MUJER" => Ok(SexoEnum::Mujer),
            _ => Err("Unrecognized enum variant".into()),
        }
    }
}
