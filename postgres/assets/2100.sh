#!/bin/ash
# This function copies data from cs_carrier_commodity_master and inserts
# it into the local database connected to the right client_view_id
function copyData {
  TABLE=$1
  SCAC=$2
  FILE_NAME=$TABLE-$(date +%Y%m%d-%H%M%S)
  echo "Connecting to $REMOTE_DB_HOST to do data dump"
  ssh -i /keys/id_rsa $REMOTE_SSH_USER@$REMOTE_DB_HOST << EOF
    time \
      psql \
        --username=${REMOTE_DB_USER} \
        -d ${REMOTE_DB_DB} \
        -c "COPY (SELECT * FROM $TABLE WHERE scac_id='$SCAC') TO STDOUT" > /tmp/$FILE_NAME.tsv
    tar -cvzf /tmp/$FILE_NAME.tar.gz -C /tmp $FILE_NAME.tsv
EOF

  echo "Copying the data from $REMOTE_DB_HOST"
  scp -i /keys/id_rsa $REMOTE_SSH_USER@$REMOTE_DB_HOST:/tmp/$FILE_NAME.tar.gz /tmp

  ssh -i /keys/id_rsa $REMOTE_SSH_USER@$REMOTE_DB_HOST << EOF
    rm /tmp/$FILE_NAME.tsv /tmp/$FILE_NAME.tar.gz
EOF

  echo "Unapcking the data"
  tar -xvf \
    /tmp/$FILE_NAME.tar.gz \
    --directory /tmp

  echo "Creating trigger which will set the environment id on insert"
  psql \
    -d local \
    -c "create function my_temp_insert_trigger_function() returns trigger as 'BEGIN new.scac_id = ''$SCAC''; return new; END' language 'plpgsql'"
  psql \
    -d local \
    -c "create trigger my_temp_insert_trigger before insert on $TABLE for each row execute procedure my_temp_insert_trigger_function()"

  echo "Loading /tmp/$FILE_NAME.sql"
  psql -d local -c "COPY $TABLE FROM '/tmp/$FILE_NAME.tsv' DELIMITER E'\t'"

  echo "Current size of $TABLE"
  psql -d local -c "SELECT count(*) FROM $TABLE"

  echo "Dropping trigger my_temp_insert_trigger"
  psql \
    -d local \
    -c "drop trigger my_temp_insert_trigger on $TABLE"

  echo "Dropping trigger my_temp_insert_trigger_function"
  psql \
    -d local \
    -c "drop function my_temp_insert_trigger_function()"
}

# Copy data from $TABLE for E-ONEY
copyData cs_container_vendor_mapping ONEY
copyData cs_container_vendor_mapping MAEU
copyData cs_container_vendor_mapping CMDU
copyData cs_container_vendor_mapping ANLC