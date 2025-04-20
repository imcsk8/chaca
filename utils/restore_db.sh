#!/bin/bash

PG_HOST="localhost"
PG_DATABASE="poder_judicial"
PG_USER="pj"

dropdb -U postgres -h $PG_HOST $PG_DATABASE
createdb -U postgres -h $PG_HOST -O $PG_USER $PG_DATABASE
