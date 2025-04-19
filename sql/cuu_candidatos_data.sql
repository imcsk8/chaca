BEGIN;

-- Step 1: Create a temporary staging table for the JSON import
DROP TABLE IF EXISTS staging_candidates;
CREATE TEMP TABLE staging_candidates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
	data jsonb
);

-- Step 2: Import CSV file into the staging table
-- Replace with your actual path
\copy staging_candidates (data) FROM '../json/cuu_candidates_clean.jsonl' WITH (FORMAT TEXT);

-- Step 3: Insert into the Applicant table with resolved UUIDs
explain analyze
INSERT INTO Candidate (
	-- NO CSV
    id,
    external_uuid, -- IEE
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

	-- Raw data from the institute
	raw_data
)

-- Use this variable when loading state candidates
--WITH myconstants(ENV_STATE) as ( VALUES(8) )
SELECT
	sc.id,
    (sc.data->>'candidatoID')::UUID,
	--mc.ENV_STATE,
	8,
	pos.id,
    d.id,
    p.uuid,
	data->>'propietario',
    m.uuid,
    (sc.data->>'numeroUnicoBoleta')::INT,
    (sc.data->>'sexo')::sexo,
	(data->'datosGenerales'->>'edad')::INT,
	data->'datosGenerales'->>'paginaWeb',
	data->'mediosDeContacto'->>'telefono',
	data->'mediosDeContacto'->>'correo',
    sc.data->>'imageUrl',
    sc.data->>'curriculumUrl',
    sc.data->>'videoUrl',
    sc.data->>'candidatoUrl',
	sc.data
-- FROM myconstants mc
-- JOIN staging_candidates sc ON true
FROM staging_candidates sc
JOIN cat_Positions pos ON REPLACE(sc.data->>'cargo','JUEZA O JUEZ','JUEZ PRIMERA') = pos.cargo -- Cambiar esto para jueces de distrito
JOIN cat_Poder p ON REPLACE(p.name, ' ', '') = REPLACE(sc.data->>'actorPolitico', ' ', '') -- Santización porque la DB viene puerca
JOIN cat_District d ON d.id = split_part(sc.data->>'distrito', '-', 1)::INT
-- TODO: Fix this for the AND d.id_inegi = 8
JOIN cat_Matter m ON m.name = sc.data->>'materia';


COMMIT;
