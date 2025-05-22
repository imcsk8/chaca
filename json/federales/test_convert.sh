#!/bin/bash

FILES=(juecesDistrito.json 
       magistraturaSalasRegionales.json
       magistraturaSalaSuperior.json
       magistraturaTribunalDJ.json
       magistraturaTribunales.json
       ministrosSupremaCorte.json)


for json_file in ${FILES[@]}; do
    echo "Procesing: $json_file"
    echo -n "Normal: "
    jq '.candidatos[] | .idCandidato' $json_file | wc -l
    echo -n "Converted: "
    jq -f convert.jq $json_file  | jq '. | .idCandidato' | wc -l
done
