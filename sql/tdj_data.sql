BEGIN;

-- Step 1: Create a temporary staging table for the CSV import
DROP TABLE IF EXISTS staging_applicants;
CREATE TEMP TABLE staging_applicants (
    poder TEXT,
    matter_name TEXT,
    fullname TEXT,
    sex TEXT,
    state INT,
    position INT NOT NULL
);

-- Step 2: Import CSV file into the staging table
-- Replace with your actual path
\copy staging_applicants FROM '../csv/cuu_tdj.csv' DELIMITER ':' CSV;

-- Step 3: Insert into the Applicant table with resolved UUIDs
INSERT INTO Applicant (
	fullname,
    state,
    poder,
    matter,
    sex,
    position
)
SELECT
	fullname,
	sa.state,
    p.uuid,
    m.uuid,
    sa.sex::sexo,
    sa.position
FROM staging_applicants sa
JOIN cat_Poder p ON p.short_name = sa.poder
JOIN cat_Matter m ON m.name = sa.matter_name;

COMMIT;
