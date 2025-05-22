#!/bin/bash

jq -f convert.jq magistraturaTribunales.json | jq '.idCandidato' | sort > magistratura_converted.json
jq '.candidatos[]| .idCandidato' magistraturaTribunales.json | sort > magistratura_no_converted.json
diff magistratura_no_converted.json magistratura_converted.json  | head

