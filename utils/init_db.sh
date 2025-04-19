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

echo "Loading Candidates"

# Prepare data:

cd ../json
jq -c '.[]'  cuu_candidates.json > cuu_candidates_raw.json
cat << 'EOF' > sanitize.jq
def sanitize:
  walk(
    if type == "string"
    then
      gsub("\\\\"; "\\\\\\\\") |         # Escape backslashes
      gsub("\r"; "\\\\r")     |          # Escape carriage return
      gsub("\n"; "\\\\n")     |          # Escape newline
      gsub("\t"; "\\\\t")                 # Escape tab
    else .
    end
  );
sanitize
EOF

jq -c -f sanitize.jq cuu_candidates_raw.json | sed 's/\\"//g' > cuu_candidates_clean.jsonl 

echo "Candidatos"
psql $MYDSN -c '\ir ../sql/candidatos_data.sql'

