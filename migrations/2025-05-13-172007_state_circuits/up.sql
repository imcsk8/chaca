-- Your SQL goes here

-- object: public."cat_Estado_Circuito" | type: TABLE --
--- This ones are in spanish to be in sync with the INE catalogs
-- eg
-- {
--   "seccion": 815,
--   "idDistritoFederal": 8,
--   "idDistritoJudicial": 2,
--   "idEstado": 8,
--   "idCorte": 15,
--   "idCircuito": 17
-- }

CREATE TABLE IF NOT EXISTS cat_Estado_Circuito (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    seccion INT NOT NULL,
    idDistritoFederal INT NOT NULL,
    idDistritoJudicial INT NOT NULL,
    idEstado INT REFERENCES cat_State(id_inegi),
    idCorte INT NOT NULL,
    idCircuito INT NOT NULL
);
-- ddl-end --

COMMENT ON TABLE cat_Estado_Circuito IS E'Catálogo de estados, secciones electorales y circuitos judiciales del INE';

CREATE INDEX IF NOT EXISTS idx_circuito ON cat_Estado_Circuito
USING btree
(
    idCircuito
);

CREATE INDEX IF NOT EXISTS idx_estado ON cat_Estado_Circuito
USING btree
(
    idEstado
);

CREATE INDEX IF NOT EXISTS idx_distritio_judicial ON cat_Estado_Circuito
USING btree
(
    idDistritoJudicial
);

CREATE INDEX IF NOT EXISTS idx_circuito_distritio_judicial ON cat_Estado_Circuito
USING btree
(
    idCircuito,
    idDistritoJudicial
);

CREATE INDEX IF NOT EXISTS idx_seccion ON cat_Estado_Circuito
USING btree
(
    seccion
);

