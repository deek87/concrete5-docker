#!/bin/bash
set -e

if ! [[ -d ./data/logs/web ]]; then
    mkdir -p ./data/logs/web
fi

if ! [[ -d ./data/config/ ]]; then
    mkdir -p ./data/config
fi

if ! [[ -d ./data/logs/database ]]; then
    mkdir -p ./data/logs/database
fi

if ! [[ -d ./data/logs/php ]]; then
    mkdir -p ./data/logs/php
fi

if ! [[ -d ./data/database ]]; then
    mkdir ./data/database
fi

if ! [[ -d ./data/vhosts ]]; then
    mkdir ./data/vhosts
fi

docker-compose up -d --build