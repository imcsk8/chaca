-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.1.3
-- PostgreSQL version: 16.0
-- Project Site: pgmodeler.io
-- Model Author: ---


-- Database creation must be performed outside a multi lined SQL file. 
-- These commands were put in this file only as a convenience.
-- 
-- object: new_database | type: DATABASE --
-- DROP DATABASE IF EXISTS new_database;
CREATE DATABASE poder_judicial;
-- ddl-end --

\c poder_judicial

BEGIN;

-- object: public."cat_State" | type: TABLE --
-- DROP TABLE IF EXISTS public."cat_State" CASCADE;
CREATE TABLE IF NOT EXISTS cat_State (
    id_inegi INT UNIQUE NOT NULL PRIMARY KEY,
    name text
);
-- ddl-end --
COMMENT ON COLUMN cat_State.name IS E'nombre del estado';
-- ddl-end --
-- Set owner if needed ALTER TABLE public."cat_State" OWNER TO postgres;
-- ddl-end --

-- object: idx_name | type: INDEX --
-- DROP INDEX IF EXISTS public.idx_name CASCADE;
CREATE INDEX IF NOT EXISTS idx_name ON cat_State
USING btree
(
    name
);

-- ddl-end --


-- object: public."cat_Matter" | type: TABLE --
-- DROP TABLE IF EXISTS public."cat_Matter" CASCADE;
CREATE TABLE IF NOT EXISTS cat_Matter (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);
-- ddl-end --
COMMENT ON TABLE cat_Matter IS E'Catálogo de materias judiciales';
-- ddl-end --
-- Set owner if needed ALTER TABLE public."cat_Matter" OWNER TO postgres;
-- ddl-end --

-- object: public."cat_Positions" | type: TABLE --
-- DROP TABLE IF EXISTS public."cat_Positions" CASCADE;
CREATE TABLE IF NOT EXISTS cat_Positions (
    id INT NOT NULL PRIMARY KEY,
    male_name TEXT UNIQUE NOT NULL,
    female_name TEXT UNIQUE NOT NULL
);
-- ddl-end --
COMMENT ON TABLE cat_Positions IS E'Catálogo de posiciones judiciales';
-- ddl-end --
-- Set owner if needed ALTER TABLE public."cat_Positions" OWNER TO postgres;
-- ddl-end --

CREATE INDEX IF NOT EXISTS idx_male_name ON cat_Positions
USING btree
(
    male_name
);

CREATE INDEX IF NOT EXISTS idx_female_name ON cat_Positions
USING btree
(
    female_name
);


-- object: public."cat_Poder" | type: TABLE --
CREATE TABLE IF NOT EXISTS cat_Poder (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
	short_name text,
    name text,
    UNIQUE(short_name, name)
);
-- ddl-end --

COMMENT ON TABLE cat_Poder IS E'Poderes que maneja el INE';
-- ddl-end --
-- Set owner if needed ALTER TABLE public."cat_Poder" OWNER TO postgres;
-- ddl-end --

CREATE INDEX IF NOT EXISTS idx_shortname ON cat_Poder
USING btree
(
    short_name
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_name ON cat_Poder
USING btree
(
    name
);

-- ddl-end --

-- object: public.sexo | type: TYPE --
DROP TYPE IF EXISTS sexo CASCADE;
CREATE TYPE sexo AS
ENUM ('HOMBRE','MUJER');
-- ddl-end --
-- Set owner if needed ALTER TYPE public.sexo OWNER TO postgres;
-- ddl-end --

-- object: public."cat_District" | type: TABLE --
-- DROP TABLE IF EXISTS public."cat_District" CASCADE;
CREATE TABLE IF NOT EXISTS cat_District (
    id INT PRIMARY KEY,
    name text,
    id_inegi INT NOT NULL REFERENCES cat_State(id_inegi),
    UNIQUE(name, id_inegi)
);
-- ddl-end --

COMMENT ON TABLE cat_District IS E'Distritos judiciales';
-- ddl-end --
-- Set owner if needed ALTER TABLE public."cat_District" OWNER TO postgres;
-- ddl-end --

-- object: idx_nombre | type: INDEX --
-- DROP INDEX IF EXISTS public.idx_nombre CASCADE;
CREATE INDEX IF NOT EXISTS idx_nombre ON cat_District
USING btree
(
    name
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_nombre_id_inegi ON cat_District
USING btree
(
    name,
    id_inegi
);

-- ddl-end --

-- object: public."Applicant" | type: TABLE --
-- DROP TABLE IF EXISTS public."Applicant" CASCADE;
CREATE TABLE IF NOT EXISTS Applicant (
    id SERIAL PRIMARY KEY,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    fullname text NOT NULL,
    firstname text,
    middlename text,
    pat_surname text,
    mat_surname text,
    poder uuid NOT NULL REFERENCES cat_Poder(uuid),
    district int REFERENCES cat_District(id),
    state INT NOT NULL REFERENCES cat_State(id_inegi),
    matter uuid NOT NULL REFERENCES cat_Matter(uuid),
    sex sexo,
    position INT NOT NULL REFERENCES cat_Positions(id)
);
-- ddl-end --
-- Set owner if needed ALTER TABLE public."Applicant" OWNER TO postgres;
-- ddl-end --


-- object: idx_applicant_fullname | type: INDEX --
-- DROP INDEX IF EXISTS public.idx_applicant_fullname CASCADE;
CREATE INDEX IF NOT EXISTS idx_applicant_fullname ON Applicant
USING btree
(
    fullname
);
-- ddl-end --


-- object: idx_applicant_name | type: INDEX --
-- DROP INDEX IF EXISTS public.idx_applicant_name CASCADE;
CREATE INDEX IF NOT EXISTS idx_applicant_name ON Applicant
USING btree
(
    firstname
);
-- ddl-end --

-- object: idx_applicant_middle | type: INDEX --
-- DROP INDEX IF EXISTS public.idx_applicant_middle CASCADE;
CREATE INDEX IF NOT EXISTS idx_applicant_middle ON Applicant
USING btree
(
    middlename
);
-- ddl-end --

-- object: idx_applicant_pat | type: INDEX --
-- DROP INDEX IF EXISTS public.idx_applicant_pat CASCADE;
CREATE INDEX IF NOT EXISTS idx_applicant_pat ON Applicant
USING btree
(
    pat_surname
);
-- ddl-end --

-- object: idx_applicant_mat | type: INDEX --
-- DROP INDEX IF EXISTS public.idx_applicant_mat CASCADE;
CREATE INDEX IF NOT EXISTS idx_applicant_mat ON Applicant
USING btree
(
    mat_surname
);
-- ddl-end --

-- object: idx_applicant_fullname | type: INDEX --
-- DROP INDEX IF EXISTS public.idx_applicant_fullname CASCADE;
CREATE INDEX IF NOT EXISTS idx_applicant_fullname ON Applicant
USING btree
(
    firstname,
    middlename,
    pat_surname,
    mat_surname
);
-- ddl-end --

COMMIT;
