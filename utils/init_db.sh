#!/bin/bash

if [[ ! -v DSN ]]; then
    echo "Please set the DSN variable"
    exit 1
fi

MYDSN=${DSN/9432\/postgres/9432\/poder_judicial}

echo "Creating databse schema"
psql $DSN -c '\ir ../sql/ej_schema.sql'

echo "Loading database catalogs"
psql $MYDSN -c '\ir ../sql/ej_cat_data.sql'

echo "Loading Applicants"

echo "Jueces"
psql $MYDSN -c '\ir ../sql/jueces_data.sql'

echo "Magistrados"
psql $MYDSN -c '\ir ../sql/magistrados_data.sql'

echo "DISCIPLINA"
psql $MYDSN -c '\ir ../sql/tdj_data.sql'

