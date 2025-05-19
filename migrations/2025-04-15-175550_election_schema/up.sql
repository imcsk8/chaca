-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.1.3
-- PostgreSQL version: 16.0
-- Project Site: pgmodeler.io
-- Model Author: ---

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
    cargo TEXT NOT NULL,
    male_name TEXT NOT NULL,
    female_name TEXT NOT NULL,
    long_name TEXT NOT NULL
);
-- ddl-end --
COMMENT ON TABLE cat_Positions IS E'Catálogo de posiciones judiciales';
-- ddl-end --
-- Set owner if needed ALTER TABLE public."cat_Positions" OWNER TO postgres;
-- ddl-end --

CREATE INDEX IF NOT EXISTS idx_cargo ON cat_Positions
USING btree
(
    cargo
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
ENUM ('ND', 'HOMBRE','MUJER');
-- ddl-end --
-- Set owner if needed ALTER TYPE public.sexo OWNER TO postgres;
-- ddl-end --

-- object: public.ambito_eleccion | type: TYPE --
DROP TYPE IF EXISTS ambito_eleccion CASCADE;
CREATE TYPE ambito_eleccion AS
ENUM ('ND', 'DISTRITO JUDICIAL','ESTATAL','FEDERAL');
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

-- object: public."Candidate" | type: TABLE --
-- DROP TABLE IF EXISTS public."Candidate" CASCADE;

CREATE TABLE IF NOT EXISTS Candidate (
    -- NO CSV
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    external_uuid uuid, -- IEE
    external_id INT,    -- INE
    state INT NOT NULL REFERENCES cat_State(id_inegi),

    -- CSV: TIPO DE CANDIDATURA
    -- JSON: cargo
    position INT NOT NULL REFERENCES cat_Positions(id),

    -- CSV: DISTRITO
    -- JSON: distrito
    district int REFERENCES cat_District(id),

    -- JSON: idCircuito
    circuit int;

    -- CSV: VÍA DE POSTULACIÓN
    -- JSON: actorPolitico
    poder uuid NOT NULL REFERENCES cat_Poder(uuid),

    -- CSV: N/A
    -- JSON: propietario
    fullname text NOT NULL,

    -- CSV: MATERIA
    -- JSON: materia
    matter uuid REFERENCES cat_Matter(uuid),

    -- CSV: NÚMERO ÚNICO DE CANDIDATURA EN BOLETA
    -- JSON: numeroUnicoBoleta 
    num_boleta int not null,

    -- CSV: SEXO
    -- JSON:
    sex sexo NOT NULL DEFAULT 'ND',

    -- CSV: N/A
    -- JSON: datosGenerales.edad
    age INT NOT NULL,

    -- CSV: N/A
    -- JSON: datosGenerales.paginaWeb
    website text,

    -- CSV: TELÉFONO PÚBLICO DE CONTACTO
    -- JSON: mediosDeContacto.telefono
    telephone VARCHAR(20),

    -- CSV: CORREO ELECTRÓNICO PÚBLICO
    -- JSON: mediosDeContacto.correo
    email VARCHAR(50),

    -- CSV: N/A
    -- JSON: imageUrl
    image_url text,

    -- CSV: N/A
    -- JSON: curriculumUrl
    curriculum_url text,

    -- CSV: N/A
    -- JSON: videoUrl
    video_url text,

    -- CSV: N/A
    -- JSON: candidatoUrl
    candidato_url text,

    -- CSV: ÁMBITO DE ELECCIÓN
    -- JSON: N/A
    ambito ambito_eleccion NOT NULL DEFAULT 'ND',

    -- CSV: NOMBRE (S)
    firstname text,

    -- CSV: PRIMER APELLIDO
    paterno text,

    -- CSV: SEGUNDO APELLIDO
    materno text,

    raw_data jsonb
);
-- ddl-end --
-- Set owner if needed ALTER TABLE public."Candidate" OWNER TO postgres;
-- ddl-end --


-- object: idx_candidate_fullname | type: INDEX --
-- DROP INDEX IF EXISTS public.idx_candidate_fullname CASCADE;
CREATE INDEX IF NOT EXISTS idx_candidate_fullname ON Candidate
USING btree
(
    fullname
);
-- ddl-end --


-- object: idx_candidate_name | type: INDEX --
-- DROP INDEX IF EXISTS public.idx_candidate_name CASCADE;
CREATE INDEX IF NOT EXISTS idx_candidate_name ON Candidate
USING btree
(
    firstname
);
-- ddl-end --

-- object: idx_candidate_pat | type: INDEX --
-- DROP INDEX IF EXISTS public.idx_candidate_pat CASCADE;
CREATE INDEX IF NOT EXISTS idx_candidate_pat ON Candidate
USING btree
(
    paterno
);
-- ddl-end --

-- object: idx_candidate_mat | type: INDEX --
-- DROP INDEX IF EXISTS public.idx_candidate_mat CASCADE;
CREATE INDEX IF NOT EXISTS idx_candidate_mat ON Candidate
USING btree
(
    materno
);
-- ddl-end --


CREATE INDEX IF NOT EXISTS idx_candidate_state ON Candidate
USING btree
(
    state
);

CREATE INDEX IF NOT EXISTS idx_candidate_position ON Candidate
USING btree
(
    position
);

CREATE INDEX IF NOT EXISTS idx_candidate_circuit ON Candidate
USING btree
(
    circuit
);


-- CSV: REDES SOCIALES DE CONTACTO PÚBLICOS
-- JSON: mediosDeContacto.redesSociales
CREATE TABLE IF NOT EXISTS candidate_social_media (
    id SERIAL PRIMARY KEY,
    candidate_id UUID REFERENCES candidate(id) ON DELETE CASCADE,
    url TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_candidate_social_media_candidate_id ON 
    candidate_social_media(candidate_id);

-- CSV: OCUPACIÓN
-- CSV: GRADO MÁXIMO DE ESTUDIOS
-- CSV: HISTORIA JURÍDICA PROFESIONAL Y LABORAL
-- CSV: TRAYECTORIA ACÁDEMICA
-- CSV: MOTIVACIÓN PARA OCUPAR UN CARGO PÚBLICO
-- CSV: VISIÓN ACERCA DE LA FUNCIÓN JURISDICCIONAL E IMPARTICIÓN DE JUSTICIA
-- CSV: PROPUESTA DE MEJORA A LA FUNCIÓN JURISDICCIONAL  
-- JSON: extras
CREATE TABLE IF NOT EXISTS candidate_extras (
    id SERIAL PRIMARY KEY,
    candidate_id UUID REFERENCES candidate(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    answer TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_candidate_extras_candidate_id ON
    candidate_extras(candidate_id);

COMMIT;
