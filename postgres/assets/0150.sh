#!/bin/ash
FILE_NAME=locations-$(date +%Y%m%d-%H%M%S)
echo "Connecting to $REMOTE_DB_HOST to do location dump"
ssh -i /keys/id_rsa $REMOTE_SSH_USER@$REMOTE_DB_HOST << EOF
  time \
    pg_dump \
      --username=$REMOTE_DB_USER \
      -d $REMOTE_DB_DB \
      --table=cs_location \
      -n public \
      --data-only > /tmp/$FILE_NAME.sql
  tar -cvzf /tmp/$FILE_NAME.tar.gz -C /tmp $FILE_NAME.sql
EOF

echo "Copying the data from $REMOTE_DB_HOST"
scp -i /keys/id_rsa $REMOTE_SSH_USER@$REMOTE_DB_HOST:/tmp/$FILE_NAME.tar.gz /tmp

ssh -i /keys/id_rsa $REMOTE_SSH_USER@$REMOTE_DB_HOST << EOF
  rm /tmp/$FILE_NAME.sql /tmp/$FILE_NAME.tar.gz
EOF

echo "Unapcking the data"
tar -xvf \
  /tmp/$FILE_NAME.tar.gz \
  --directory /tmp

  echo "Loading /tmp/$FILE_NAME.sql"
  psql -d local < /tmp/$FILE_NAME.sql
