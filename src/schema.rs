// @generated automatically by Diesel CLI.

pub mod sql_types {
    #[derive(diesel::query_builder::QueryId, Clone, diesel::sql_types::SqlType)]
    #[diesel(postgres_type(name = "ambito_eleccion"))]
    pub struct AmbitoEleccion;

    #[derive(diesel::query_builder::QueryId, Clone, diesel::sql_types::SqlType)]
    #[diesel(postgres_type(name = "reaction"))]
    pub struct Reaction;

    #[derive(diesel::query_builder::QueryId, Clone, diesel::sql_types::SqlType)]
    #[diesel(postgres_type(name = "sexo"))]
    pub struct Sexo;
}

diesel::table! {
    use diesel::sql_types::*;
    use super::sql_types::Sexo;
    use crate::types::SexoType;
    use super::sql_types::AmbitoEleccion;
    use crate::types::AmbitoEleccionType;

    candidate (id) {
        id -> Uuid,
        external_uuid -> Nullable<Uuid>,
        external_id -> Nullable<Int4>,
        state -> Int4,
        position -> Int4,
        district -> Nullable<Int4>,
        poder -> Uuid,
        fullname -> Text,
        matter -> Nullable<Uuid>,
        num_boleta -> Int4,
        sex -> SexoType,
        age -> Int4,
        website -> Nullable<Text>,
        #[max_length = 20]
        telephone -> Nullable<Varchar>,
        #[max_length = 50]
        email -> Nullable<Varchar>,
        image_url -> Nullable<Text>,
        curriculum_url -> Nullable<Text>,
        video_url -> Nullable<Text>,
        candidato_url -> Nullable<Text>,
        ambito -> AmbitoEleccionType,
        firstname -> Nullable<Text>,
        paterno -> Nullable<Text>,
        materno -> Nullable<Text>,
        raw_data -> Nullable<Jsonb>,
    }
}

diesel::table! {
    candidate_extras (id) {
        id -> Int4,
        candidate_id -> Nullable<Uuid>,
        question -> Text,
        answer -> Text,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use super::sql_types::Reaction;
    use crate::types::ReactionType;

    candidate_reactions (reaction_id) {
        reaction_id -> Int4,
        candidate_id -> Uuid,
        user_id -> Uuid,
        reaction_type -> ReactionType,
        created_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    candidate_social_media (id) {
        id -> Int4,
        candidate_id -> Nullable<Uuid>,
        url -> Text,
    }
}

diesel::table! {
    cat_district (id) {
        id -> Int4,
        name -> Nullable<Text>,
        id_inegi -> Int4,
    }
}

diesel::table! {
    cat_matter (uuid) {
        uuid -> Uuid,
        name -> Text,
    }
}

diesel::table! {
    cat_poder (uuid) {
        uuid -> Uuid,
        short_name -> Nullable<Text>,
        name -> Nullable<Text>,
    }
}

diesel::table! {
    cat_positions (id) {
        id -> Int4,
        cargo -> Text,
        male_name -> Text,
        female_name -> Text,
        long_name -> Text,
    }
}

diesel::table! {
    cat_state (id_inegi) {
        id_inegi -> Int4,
        name -> Nullable<Text>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use super::sql_types::Reaction;
    use crate::types::ReactionType;

    comment_reactions (reaction_id) {
        reaction_id -> Int4,
        comment_id -> Int4,
        user_id -> Uuid,
        reaction_type -> ReactionType,
        created_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    comments (comment_id) {
        comment_id -> Int4,
        user_id -> Uuid,
        content -> Text,
        parent_comment_id -> Nullable<Int4>,
        #[max_length = 100]
        resource_id -> Varchar,
        #[max_length = 50]
        resource_type -> Varchar,
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
        is_edited -> Nullable<Bool>,
        is_hidden -> Nullable<Bool>,
        likes_count -> Nullable<Int4>,
    }
}

diesel::table! {
    users (id) {
        id -> Uuid,
        name -> Nullable<Text>,
        #[max_length = 500]
        profile_picture_url -> Nullable<Varchar>,
        email -> Text,
        password -> Nullable<Text>,
        oauth_provider -> Text,
        oauth_user_id -> Text,
        access_token -> Text,
        refresh_token -> Nullable<Text>,
        created_at -> Timestamp,
        updated_at -> Timestamp,
        last_login -> Nullable<Timestamptz>,
    }
}

diesel::joinable!(candidate -> cat_district (district));
diesel::joinable!(candidate -> cat_matter (matter));
diesel::joinable!(candidate -> cat_poder (poder));
diesel::joinable!(candidate -> cat_positions (position));
diesel::joinable!(candidate -> cat_state (state));
diesel::joinable!(candidate_extras -> candidate (candidate_id));
diesel::joinable!(candidate_reactions -> candidate (candidate_id));
diesel::joinable!(candidate_reactions -> users (user_id));
diesel::joinable!(candidate_social_media -> candidate (candidate_id));
diesel::joinable!(cat_district -> cat_state (id_inegi));
diesel::joinable!(comment_reactions -> comments (comment_id));
diesel::joinable!(comment_reactions -> users (user_id));
diesel::joinable!(comments -> users (user_id));

diesel::allow_tables_to_appear_in_same_query!(
    candidate,
    candidate_extras,
    candidate_reactions,
    candidate_social_media,
    cat_district,
    cat_matter,
    cat_poder,
    cat_positions,
    cat_state,
    comment_reactions,
    comments,
    users,
);
