BEGIN;

-- Step 1: Create a temporary staging table for the JSON import
DROP TABLE IF EXISTS staging_candidates;
CREATE TEMP TABLE staging_candidates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    data jsonb
);

-- Step 2: Import CSV file into the staging table
-- Replace with your actual path
\copy staging_candidates (data) FROM '../../json/federales/processed/processed_juecesDistrito.json' WITH (FORMAT TEXT);
\copy staging_candidates (data) FROM '../../json/federales/processed/processed_magistraturaSalasRegionales.json' WITH (FORMAT TEXT);
\copy staging_candidates (data) FROM '../../json/federales/processed/processed_magistraturaSalaSuperior.json' WITH (FORMAT TEXT);
\copy staging_candidates (data) FROM '../../json/federales/processed/processed_magistraturaTribunales.json' WITH (FORMAT TEXT);
\copy staging_candidates (data) FROM '../../json/federales/processed/processed_magistraturaTribunalDJ.json' WITH (FORMAT TEXT);
\copy staging_candidates (data) FROM '../../json/federales/processed/processed_ministrosSupremaCorte.json' WITH (FORMAT TEXT);

-- Step 3: Insert into the Applicant table with resolved UUIDs
-- REAL TABLE INSERT INTO Candidate (
INSERT INTO Candidate (
    -- NO CSV
    id,
    external_id, -- INE
    state,

    -- CSV: TIPO DE CANDIDATURA
    -- JSON: cargo
    position,

    -- CSV: DISTRITO
    -- JSON: distrito
    district,

    -- CSV: VÍA DE POSTULACIÓN
    -- JSON: actorPolitico
    poder,

    -- CSV: N/A
    -- JSON: propietario
    fullname,

    -- CSV: MATERIA
    -- JSON: materia
    matter,

    -- CSV: NÚMERO ÚNICO DE CANDIDATURA EN BOLETA
    -- JSON: numeroUnicoBoleta 
    num_boleta,

    -- CSV: SEXO
    -- JSON:
    sex,

    -- CSV: N/A
    -- JSON: datosGenerales.edad
    age,

    -- CSV: N/A
    -- JSON: datosGenerales.paginaWeb
    website,

    -- CSV: TELÉFONO PÚBLICO DE CONTACTO
    -- JSON: mediosDeContacto.telefono
    telephone,

    -- CSV: CORREO ELECTRÓNICO PÚBLICO
    -- JSON: mediosDeContacto.correo
    email,

    -- CSV: N/A
    -- JSON: imageUrl
    image_url,

    -- CSV: N/A
    -- JSON: curriculumUrl
    curriculum_url,

    -- CSV: N/A
    -- JSON: videoUrl
    video_url,

    -- CSV: N/A
    -- JSON: candidatoUrl
    candidato_url,

    is_federal,

    -- Raw data from the institute
    raw_data
)

-- Use this variable when loading state candidates
--WITH myconstants(ENV_STATE) as ( VALUES(8) )
SELECT
    sc.id,                                  -- id
    (sc.data->>'idCandidato')::INT,         -- external_id
    (data->>'state')::INT,                  -- state
    (data->>'cargo')::INT,                  -- position
    (data->>'distrito')::INT,               -- district
    (data->>'actorPolitico')::UUID,         -- poder
    data->>'propietario',                   -- fullname
    (data->>'materia')::UUID,               -- matter
    (sc.data->>'numeroUnicoBoleta')::INT,   -- num_boleta
    (sc.data->>'sexo')::sexo,               -- sex
    (data->'datosGenerales'->>'edad')::INT, -- age
    data->'datosGenerales'->>'paginaWeb',   -- website
    data->'mediosDeContacto'->>'telefono',  -- telephone
    data->'mediosDeContacto'->>'correo',    -- email
    sc.data->>'imageUrl',                   -- image_url
    sc.data->>'curriculumUrl',              -- curriculum_url
    sc.data->>'videoUrl',                   -- video_url
    sc.data->>'candidatoUrl',               -- candidato_url
    TRUE,
    sc.data                                 -- raw_data
FROM staging_candidates sc;

COMMIT;
