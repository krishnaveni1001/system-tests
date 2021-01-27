# postgres

# Build the database image
This is only needed if the image does not already exist. Most likely, it already does
```
cd postgres
docker build . -t cs-postgres-with-openssl:11.4
```

# Interesting commands
```sql
psql \
    -U user_name \
    -h production_server \
    -d database_name \
    -c "\\copy users to stdout" | \
psql -U user_name \
    -h staging_server \
    -d database_name \
    -c "\\copy users from stdin"
```
