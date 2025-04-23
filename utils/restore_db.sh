#!/bin/bash

PG_HOST="127.0.0.1"
PG_DATABASE="poder_judicial"
PG_USER="pj"
PORT="9432"

dropdb -U postgres -h $PG_HOST -p $PORT $PG_DATABASE
createdb -U postgres -h $PG_HOST -p $PORT -O $PG_USER $PG_DATABASE
