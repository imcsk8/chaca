#!/bin/bash

FILES=(juecesDistrito.json 
       magistraturaSalasRegionales.json
       magistraturaSalaSuperior.json
       magistraturaTribunalDJ.json
       magistraturaTribunales.json
       ministrosSupremaCorte.json)


if [[ ! -d processed ]]; then
    mkdir processed
fi

echo "Cleaning previous run"
rm processed/*

for json_file in ${FILES[@]}; do
    echo "Procesing: $json_file"
    jq -c -f convert.jq $json_file > processed/processed_${json_file}.tmp
    jq -c -f ../sanitize.jq processed/processed_${json_file}.tmp > processed/processed_${json_file}
done
