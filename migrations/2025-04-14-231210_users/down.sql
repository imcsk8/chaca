-- This file should undo anything in `up.sql`

DROP TABLE Users;
DROP FUNCTION IF EXISTS get_pw_hash;
DROP FUNCTION IF EXISTS check_pw_hash;
DROP FUNCTION IF EXISTS check_pw;
