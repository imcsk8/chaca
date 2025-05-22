#!/bin/bash

jq -f convert.jq juecesDistrito.json | jq '.idCandidato' | sort > jueces_converted.json
jq '.candidatos[]| .idCandidato' juecesDistrito.json | sort > jueces_no_converted.json
diff jueces_no_converted.json jueces_converted.json  | head

