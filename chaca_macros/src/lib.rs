/// Structure for candidate lists
#[macro_export]
macro_rules! candidate_details {
    () => {
            use diesel::sql_types::*;
            use serde::{Serialize, Deserialize};
            use diesel::serialize::ToSql;
            use crate::types::{Sexo, AmbitoEleccion, SexoType, AmbitoEleccionType};
            use diesel::sql_types::Integer;

            // Define a structure to hold the joined result
            #[derive(Debug, QueryableByName, Serialize)]
            struct CandidateWithDetails {
                #[diesel(sql_type = Uuid)]
                id: uuid::Uuid,
                #[diesel(sql_type = Nullable<Uuid>)]
                external_uuid: Option<uuid::Uuid>,
                #[diesel(sql_type = Nullable<Integer>)]
                external_id: Option<i32>,
                #[diesel(sql_type = Integer)]
                state: i32,
                #[diesel(sql_type = Integer)]
                position: i32,
                #[diesel(sql_type = Nullable<Integer>)]
                district: Option<i32>,
                #[diesel(sql_type = Uuid)]
                poder: uuid::Uuid,
                #[diesel(sql_type = Text)]
                fullname: String,
                #[diesel(sql_type = Nullable<Uuid>)]
                matter: Option<uuid::Uuid>,
                #[diesel(sql_type = Integer)]
                num_boleta: i32,
                #[diesel(sql_type = SexoType)]
                sex: Sexo,
                #[diesel(sql_type = Integer)]
                age: i32,
                #[diesel(sql_type = Nullable<Text>)]
                website: Option<String>,
                #[diesel(sql_type = Nullable<Text>)]
                telephone: Option<String>,
                #[diesel(sql_type = Nullable<Text>)]
                email: Option<String>,
                #[diesel(sql_type = Nullable<Text>)]
                image_url: Option<String>,
                #[diesel(sql_type = Nullable<Text>)]
                curriculum_url: Option<String>,
                #[diesel(sql_type = Nullable<Text>)]
                video_url: Option<String>,
                #[diesel(sql_type = Nullable<Text>)]
                candidato_url: Option<String>,
                #[diesel(sql_type = AmbitoEleccionType)]
                ambito: AmbitoEleccion,
                #[diesel(sql_type = Nullable<Text>)]
                firstname: Option<String>,
                #[diesel(sql_type = Nullable<Text>)]
                paterno: Option<String>,
                #[diesel(sql_type = Nullable<Text>)]
                materno: Option<String>,
                #[diesel(sql_type = Nullable<Jsonb>)]
                raw_data: Option<serde_json::Value>,

                // Additional joined fields
                #[diesel(sql_type = Text)]
                state_name: String,
                #[diesel(sql_type = Text)]
                position_name: String,
                #[diesel(sql_type = Nullable<Text>)]
                district_name: Option<String>,
                #[diesel(sql_type = Text)]
                poder_name: String,
                #[diesel(sql_type = Nullable<Text>)]
                matter_name: Option<String>,
            }
    };
}

