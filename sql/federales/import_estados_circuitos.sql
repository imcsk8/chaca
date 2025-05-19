BEGIN;

-- Step 1: Create a temporary staging table for the JSON import
DROP TABLE IF EXISTS staging_estado_circuito;
CREATE TEMP TABLE staging_estado_circuito (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
	data jsonb
);

--    {
--      "idEstado": 32,
--      "nombreEstado": "ZACATECAS",
--      "idCircunscripcion": 2,
--      "idCorte": 15
--    }


\copy staging_estado_circuito (data) FROM '../../json/federales/SECCIONES_catalogoEstadosSecciones.json' WITH (FORMAT TEXT);

-- Step 3: Insert into the Applicant table with resolved UUIDs
-- REAL TABLE INSERT INTO Candidatae (
INSERT INTO cat_Estado_Circuito (
    uuid,
    seccion,
    idDistritoFederal,
    idDistritoJudicial,
    idEstado,
    idCorte,
    idCircuito
)

-- Use this variable when loading state candidates
--WITH myconstants(ENV_STATE) as ( VALUES(8) )
SELECT
	sec.id,
    (sec.data->>'seccion')::INT,
    (sec.data->>'idDistritoFederal')::INT,
    (sec.data->>'idDistritoJudicial')::INT,
    (sec.data->>'idEstado')::INT,
    (sec.data->>'idCorte')::INT,
    (sec.data->>'idCircuito')::INT
FROM staging_estado_circuito sec;

COMMIT;
