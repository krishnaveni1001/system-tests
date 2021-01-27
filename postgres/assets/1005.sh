#!/bin/ash
echo "Loading /docker-entrypoint-initdb.d/tmp/1005.sql"
psql -d local < /docker-entrypoint-initdb.d/tmp/1005.sql
