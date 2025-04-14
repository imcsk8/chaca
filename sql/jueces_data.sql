BEGIN;

-- Step 1: Create a temporary staging table for the CSV import
DROP TABLE IF EXISTS staging_applicants;
CREATE TEMP TABLE staging_applicants (
    poder TEXT,
    district_name TEXT,
    matter_name TEXT,
    fullname TEXT,
    sex TEXT,
    id_inegi INT,
    position INT NOT NULL
);

-- Step 2: Import CSV file into the staging table
-- Replace with your actual path
\copy staging_applicants FROM '../csv/cuu_jueces.csv' DELIMITER ':' CSV;

-- Step 3: Insert into the Applicant table with resolved UUIDs
INSERT INTO Applicant (
	fullname,
    poder,
    district,
    matter,
    sex,
    state,
    position
)
SELECT
	fullname,
    p.uuid,
    d.id,
    m.uuid,
    sa.sex::sexo,
    sa.id_inegi,
    sa.position
FROM staging_applicants sa
JOIN cat_Poder p ON p.short_name = sa.poder
JOIN cat_District d ON d.name = sa.district_name AND d.id_inegi = sa.id_inegi
JOIN cat_Matter m ON m.name = sa.matter_name;

COMMIT;
