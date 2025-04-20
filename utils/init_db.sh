#!/bin/bash

if [[ ! -v DSN ]]; then
    echo "Please set the DSN variable"
    exit 1
fi

MYDSN=${DSN/9432\/postgres/9432\/poder_judicial}

source data.shlib

echo "Creating databse schema"
psql $DSN -c '\ir ../sql/ej_schema.sql'

echo "Adding data"
load_catalogs

echo "Adding Candidates"
load_candidates
