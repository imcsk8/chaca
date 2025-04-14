#!/bin/bash

if [[ ! -v DSN ]]; then
    echo "Please set the DSN variable"
    exit 1
fi

psql $DSN -c 'DROP DATABASE poder_judicial'
