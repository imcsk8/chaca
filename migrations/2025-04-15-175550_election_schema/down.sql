-- This file should undo anything in `up.sql`
DROP TABLE IF EXISTS Candidate CASCADE;
DROP TABLE IF EXISTS cat_District;
DROP TABLE IF EXISTS cat_State;
DROP TABLE IF EXISTS cat_Matter;
DROP TABLE IF EXISTS cat_Positions;
DROP TABLE IF EXISTS cat_Poder;
DROP TYPE IF EXISTS sexo CASCADE;
DROP TYPE IF EXISTS ambito_eleccion CASCADE;

