#!/bin/ash
echo "Loading /docker-entrypoint-initdb.d/tmp/300.sql"
psql -d local < /docker-entrypoint-initdb.d/tmp/300.sql
