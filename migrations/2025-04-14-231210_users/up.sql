-- Your SQL goes here

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Users
CREATE TABLE IF NOT EXISTS Users (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    name TEXT,
    profile_picture_url VARCHAR(500),
    email TEXT NOT NULL,
    password TEXT,
    oauth_provider TEXT NOT NULL,
    oauth_user_id TEXT NOT NULL,
    access_token TEXT NOT NULL,
    refresh_token TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    last_login TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (oauth_provider, id)
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_oauth_user_id on users(oauth_user_id);


-- *****************************************************************************
--
--                              F U N C T I O N S
--
-- *****************************************************************************


-- Function for generating password hashes
CREATE OR REPLACE FUNCTION get_pw_hash(password TEXT)
RETURNS TEXT LANGUAGE plpgsql AS $$
DECLARE
    encrypted_pw TEXT;
BEGIN
    SELECT INTO encrypted_pw crypt(password, gen_salt('md5'));
    RETURN encrypted_pw;
END; 
$$;

-- Function for checking password hashes
CREATE OR REPLACE FUNCTION check_pw_hash(password TEXT, hash TEXT)
RETURNS TEXT LANGUAGE plpgsql AS $$
DECLARE
    generated_hash TEXT;
BEGIN
    SELECT INTO generated_hash crypt(password, hash);
    IF generated_hash = hash THEN
        return true;
    END IF;
    RETURN false;
END; 
$$;

-- Function for checking user passwords
CREATE OR REPLACE FUNCTION check_pw(user_email TEXT, user_password TEXT)
RETURNS TEXT LANGUAGE plpgsql AS $$
DECLARE
    pw_hash TEXT;
BEGIN
    SELECT password INTO pw_hash from Users where email = user_email;
    IF check_pw_hash(user_password, pw_hash) THEN
        return true;
    END IF;
    RETURN false;
END; 
$$;

