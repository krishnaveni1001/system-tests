#!/bin/ash
echo "Loading /docker-entrypoint-initdb.d/tmp/3000.sql"
psql -d local < /docker-entrypoint-initdb.d/tmp/3000.sql
