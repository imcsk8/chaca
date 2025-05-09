#!/bin/bash

DERIVE_FLAGS="Clone, Debug, Identifiable, Queryable, QueryableByName, Selectable, Insertable, Serialize, Deserialize, AsChangeset"

echo "Running diesel migrations"
diesel migration run

echo "Gettting schema from database"
diesel print-schema                                   \
        | sed -f generate_models/update_datatypes.sed \
        > src/schema.rs

echo "Generating models"
diesel_ext -t -s src/schema.rs -m             \
  -I "crate::schema::*"                       \
  -I "crate::types::*"                        \
  -I "rocket::serde::json::serde_json"        \
  -I "diesel::serialize::ToSql"               \
  -I "diesel::deserialize::FromSql"           \
  -I "diesel::sql_types::Jsonb"               \
  -I "diesel::AsExpression"                   \
  -I "serde_json::Value as JsonValue"         \
  -M "ReactionType Reaction"                  \
  -M "SexoType Sexo"                          \
  -M "AmbitoEleccionType AmbitoEleccion"      \
  -M "ResourceTypeType ResourceType"          \
  -I "rocket::serde::{ Deserialize, Serialize }"       \
  -d "${DERIVE_FLAGS}" | sed -f generate_models/update_model_fields.sed \
  > src/models.rs
