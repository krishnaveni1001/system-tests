#!/bin/ash
echo "Loading /docker-entrypoint-initdb.d/tmp/1004.sql"
psql -d local < /docker-entrypoint-initdb.d/tmp/1004.sql
