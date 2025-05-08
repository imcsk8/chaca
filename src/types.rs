// In your schema.rs or a dedicated types.rs file
use diesel::prelude::*;
use diesel::{AsExpression,SqlType,deserialize,serialize,FromSqlRow};
use diesel::deserialize::FromSql;
use diesel::pg::{Pg,PgValue};
use diesel::serialize::{IsNull,Output,ToSql};
use std::io::Write;
use serde::{Serialize, Deserialize};
use std::fmt::{Display, Formatter, Result as FmtResult};
use diesel::QueryId;
use rocket::response::Debug;

pub type Result<T, E = Debug<diesel::result::Error>> = std::result::Result<T, E>;

// Enum for types of reactions
#[derive(Debug, Clone, Copy, SqlType, QueryId)]
#[diesel(postgres_type(name = "reaction", schema = "public"))]
#[diesel(sql_type = Reaction)]
pub struct ReactionType;

// Step 2: Create the Rust enum
//#[derive(Clone, Debug, AsExpression, Serialize, Deserialize)]
#[derive(Debug, Clone, Copy, PartialEq, Eq, AsExpression, FromSqlRow, Serialize, Deserialize)]
#[diesel(sql_type = ReactionType)]
pub enum Reaction {
    NA,
    Like,
    Love,
    Laugh,
    Dislike,
    Bad,
    Danger,
}

// Step 3: Implementation for serialization (Rust -> DB)
impl ToSql<ReactionType, Pg> for Reaction {
    fn to_sql<'b>(&'b self, out: &mut Output<'b, '_, Pg>) -> serialize::Result {
        match *self {
            Reaction::NA => out.write_all(b"NA")?,
            Reaction::Like => out.write_all(b"LIKE")?,
            Reaction::Love => out.write_all(b"LOVE")?,
            Reaction::Laugh => out.write_all(b"LAUGH")?,
            Reaction::Dislike => out.write_all(b"DISLIKE")?,
            Reaction::Bad => out.write_all(b"BAD")?,
            Reaction::Danger => out.write_all(b"DANGER")?,
        }
        Ok(IsNull::No)
    }
}

// Step 4: Implementation for deserialization (DB -> Rust)
impl FromSql<ReactionType, Pg> for Reaction {
    fn from_sql(value: PgValue<'_>) -> deserialize::Result<Self> {
        match value.as_bytes() {
            b"NA" => Ok(Reaction::NA),
            b"LIKE" => Ok(Reaction::Like),
            b"LOVE" => Ok(Reaction::Love),
            b"LAUGH" => Ok(Reaction::Laugh),
            b"DISLIKE" => Ok(Reaction::Dislike),
            b"BAD" => Ok(Reaction::Bad),
            b"DANGER" => Ok(Reaction::Danger),
            _ => Err("Unrecognized enum variant".into()),
        }
    }
}

 /// For converting from String
impl From<String> for Reaction {
    fn from(item: String) -> Self {
        Self::from(item.as_str())
    }
}

/// Convert from &str
impl From<&str> for Reaction {
    fn from(item: &str) -> Self {
        match item {
            "NA" => Reaction::NA,
            "LIKE" => Reaction::Like,
            "LOVE" => Reaction::Love,
            "LAUGH" => Reaction::Laugh,
            "DISLIKE" => Reaction::Dislike,
            "BAD" => Reaction::Bad,
            "DANGER" => Reaction::Danger,
            &_ => panic!("Reaction solo puede ser: NA, LIKE, LOVE, LAUGH, DISLIKE, BAD, DANGER"),
        }
    }
}

/// Convert to String
impl ToString for Reaction {
    fn to_string(&self) -> String {
        match *self {
            Reaction::NA => String::from("NA"),
            Reaction::Like => String::from("LIKE"),
            Reaction::Love => String::from("LOVE"),
            Reaction::Laugh => String::from("LAUGH"),
            Reaction::Dislike => String::from("DISLIKE"),
            Reaction::Bad => String::from("BAD"),
            Reaction::Danger => String::from("DANGER"),
        }
    }
}


#[derive(Debug, Clone, Copy, SqlType)]
#[diesel(check_for_backend(Pg))]
#[diesel(postgres_type(name = "sexo"))]
#[diesel(sql_type = Sexo)]
pub struct SexoType;

impl Expression for SexoType {
    type SqlType = SexoType;
}

//#[derive(Clone, Debug, AsExpression )]
#[derive(Debug, Clone, Copy, PartialEq, Eq, AsExpression, FromSqlRow, Serialize, Deserialize)]
#[diesel(sql_type = SexoType)]
pub enum Sexo {
    ND,
    Hombre,
    Mujer,
}

// Step 3: Implementation for serialization (Rust -> DB)
impl ToSql<SexoType, Pg> for Sexo {
    fn to_sql<'b>(&'b self, out: &mut Output<'b, '_, Pg>) -> serialize::Result {
        match *self {
            Sexo::ND => out.write_all(b"ND")?,
            Sexo::Hombre => out.write_all(b"HOMBRE")?,
            Sexo::Mujer => out.write_all(b"MUJER")?,
        }
        Ok(IsNull::No)
    }
}

impl FromSql<SexoType, Pg> for Sexo {
    fn from_sql(value: PgValue<'_>) -> deserialize::Result<Self> {
        match value.as_bytes() {
            b"ND" => Ok(Sexo::ND),
            b"HOMBRE" => Ok(Sexo::Hombre),
            b"MUJER" => Ok(Sexo::Mujer),
            _ => Err("Unrecognized enum variant".into()),
        }
    }
}


 /// For converting from String
impl From<String> for Sexo {
    fn from(item: String) -> Self {
        Self::from(item.as_str())
    }
}

/// Convert from &str
impl From<&str> for Sexo {
    fn from(item: &str) -> Self {
        match item {
            "ND" => Sexo::ND,
            "HOMBRE" => Sexo::Hombre,
            "MUJER" => Sexo::Mujer,
            &_ => panic!("Sexo solo puede ser Hombre o Mujer"),
        }
    }
}

/// Convert to String
impl ToString for Sexo {
    fn to_string(&self) -> String {
        match *self {
            Sexo::ND => String::from("ND"),
            Sexo::Hombre => String::from("HOMBRE"),
            Sexo::Mujer => String::from("MUJER"),
        }
    }
}

// Enum for Ámbito Elección
#[derive(Debug, Clone, Copy, SqlType)]
#[diesel(postgres_type(name = "ambito_eleccion", schema = "public"))]
#[diesel(sql_type = AmbitoEleccion)]
pub struct AmbitoEleccionType;

//#[derive(Clone, Debug, AsExpression, Serialize, Deserialize)]
#[derive(Debug, Clone, Copy, PartialEq, Eq, AsExpression, FromSqlRow, Serialize, Deserialize)]
#[diesel(sql_type = AmbitoEleccionType)]
pub enum AmbitoEleccion {
    ND,
    DistritoJudicial,
    Estatal,
    Federal,
}

// Step 3: Implementation for serialization (Rust -> DB)
impl ToSql<AmbitoEleccionType, Pg> for AmbitoEleccion {
    fn to_sql<'b>(&'b self, out: &mut Output<'b, '_, Pg>) -> serialize::Result {
        match *self {
            AmbitoEleccion::ND => out.write_all(b"ND")?,
            AmbitoEleccion::DistritoJudicial => out.write_all(b"DISTRITO JUDICIAL")?,
            AmbitoEleccion::Estatal => out.write_all(b"ESTATAL")?,
            AmbitoEleccion::Federal => out.write_all(b"FEDERAL")?,
        }
        Ok(IsNull::No)
    }
}

// Step 4: Implementation for deserialization (DB -> Rust)
impl FromSql<AmbitoEleccionType, Pg> for AmbitoEleccion {
    fn from_sql(value: PgValue<'_>) -> deserialize::Result<Self> {
        match value.as_bytes() {
            b"ND" => Ok(AmbitoEleccion::ND),
            b"DISTRITO JUDICIAL" => Ok(AmbitoEleccion::DistritoJudicial),
            b"ESTATAL" => Ok(AmbitoEleccion::Estatal),
            b"FEDERAL" => Ok(AmbitoEleccion::Federal),
            _ => Err("Unrecognized enum variant".into()),
        }
    }
}

 /// For converting from String
impl From<String> for AmbitoEleccion {
    fn from(item: String) -> Self {
        Self::from(item.as_str())
    }
}

/// Convert from &str
impl From<&str> for AmbitoEleccion {
    fn from(item: &str) -> Self {
        match item {
            "ND" => AmbitoEleccion::ND,
            "DISTRITO JUDICIAL" => AmbitoEleccion::DistritoJudicial,
            "ESTATAL" => AmbitoEleccion::Estatal,
            "FEDERAL" => AmbitoEleccion::Federal,

            &_ => panic!("AmbitoEleccion solo puede ser: ND, DISTRITO JUDICIAL, ESTATAL, FEDERAL"),
        }
    }
}

/// Convert to String
impl ToString for AmbitoEleccion {
    fn to_string(&self) -> String {
        match *self {
            AmbitoEleccion::ND => String::from("ND"),
            AmbitoEleccion::DistritoJudicial => String::from("DISTRITO JUDICIAL"),
            AmbitoEleccion::Estatal => String::from("ESTATAL"),
            AmbitoEleccion::Federal => String::from("FEDERAL"),
        }
    }
}


/// Representation of the cat_positions catalog contents
#[repr(i32)]
#[derive(Debug, Clone)]
pub enum Positions {
    JuezPrimera  = 1,
    JuezDistrito = 2,
    Mtsj         = 3,
    Mtdj         = 4,
    Mscjn        = 5,
}

/// Display for Positions enum
impl Display for Positions {
    fn fmt(&self, f: &mut Formatter<'_>) -> FmtResult {
        let value = self.clone() as i32;
        write!(f, "{}", value)
    }
}
