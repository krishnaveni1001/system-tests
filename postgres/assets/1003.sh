#!/bin/ash
echo "Loading /docker-entrypoint-initdb.d/tmp/1003.sql"
psql -d local < /docker-entrypoint-initdb.d/tmp/1003.sql
