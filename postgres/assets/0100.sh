#!/bin/ash
FILE_NAME=schema-$(date +%Y%m%d-%H%M%S)
echo "Connecting to $REMOTE_DB_HOST to do schema dump"
ssh -i /keys/id_rsa $REMOTE_SSH_USER@$REMOTE_DB_HOST << EOF
  time \
    pg_dump \
      --username=$REMOTE_DB_USER \
      -d $REMOTE_DB_DB \
      --schema-only \
      -T special_commodity_count_sojan \
      -n public > /tmp/$FILE_NAME.sql
  tar -cvzf /tmp/$FILE_NAME.tar.gz -C /tmp $FILE_NAME.sql
EOF

echo "Copying the schema from $REMOTE_DB_HOST"
scp -i /keys/id_rsa $REMOTE_SSH_USER@$REMOTE_DB_HOST:/tmp/$FILE_NAME.tar.gz /tmp

ssh -i /keys/id_rsa $REMOTE_SSH_USER@$REMOTE_DB_HOST << EOF
  rm /tmp/$FILE_NAME.sql /tmp/$FILE_NAME.tar.gz
EOF

echo "Unapcking the data"
tar -xvf \
  /tmp/$FILE_NAME.tar.gz \
  --directory /tmp

echo "Commenting out schema creation statement"
sed -i -e 's/^CREATE SCHEMA public;$/-- CREATE SCHEMA public;/g' /tmp/$FILE_NAME.tar.gz
echo "Commenting out alter privleges statements"
sed -i -e 's/^ALTER DEFAULT PRIVILEGES FOR ROLE/-- ALTER DEFAULT PRIVILEGES FOR ROLE/g' /tmp/$FILE_NAME.tar.gz

echo "Waiting…"
sleep 1
echo "Waiting…"
sleep 1
echo 'Go!'

echo "Loading /tmp/$FILE_NAME.sql"
psql -d local < /tmp/$FILE_NAME.sql
