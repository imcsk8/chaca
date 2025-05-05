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
                #[diesel(sql_type = BigInt)]
                like_count: i64,
                #[diesel(sql_type = BigInt)]
                dislike_count: i64,
                #[diesel(sql_type = BigInt)]
                danger_count: i64,
            }
    };
}


/// Macro que genera el query para distintas posiciones
/// Argumentos:
/// position: posición a buscar, esta posición está en cat_positions
#[macro_export]
macro_rules! position_query {
    ($position:expr) => {
        format!("SELECT c.*,
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

        WHERE c.state = $1 AND c.position={}
        ORDER BY c.fullname", $position)
    };
}

/// Macro que genera el query para mostrar todos los candidatos
#[macro_export]
macro_rules! all_candidates {
    () => {
        format!("SELECT c.*,
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
        ORDER BY c.fullname")
    };
}

