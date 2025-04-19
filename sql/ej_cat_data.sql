BEGIN;
\copy cat_Matter (name) FROM '../csv/materias.csv' DELIMITER ':' CSV;
COMMIT;

BEGIN;
\copy cat_State (id_inegi, name) FROM '../csv/catalogo_entidades.csv' DELIMITER ':' CSV;
COMMIT;

BEGIN;
\copy cat_District (id, id_inegi, name) FROM '../csv/distritos.csv' DELIMITER ':' CSV;
COMMIT;

BEGIN;
\copy cat_Positions (id, cargo, male_name, female_name, long_name) FROM '../csv/posiciones.csv' DELIMITER ':' CSV;
COMMIT;

BEGIN;
\copy cat_Poder (short_name, name) FROM '../csv/poderes.csv' DELIMITER ':' CSV;
COMMIT;


