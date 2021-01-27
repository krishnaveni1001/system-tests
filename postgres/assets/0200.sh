#!/bin/ash
FILE_NAME=data-$(date +%Y%m%d-%H%M%S)
echo "Connecting to $REMOTE_DB_HOST to do data dump"
ssh -i /keys/id_rsa $REMOTE_SSH_USER@$REMOTE_DB_HOST << EOF
  time \
    pg_dump \
      --username=${REMOTE_DB_USER} \
      -d ${REMOTE_DB_DB} \
      --table=cs_container_size \
      --table=cs_container_size_type \
      --table=cs_container_type \
      --table=cs_container_mode_load \
      --table=cs_country_admin1_region \
      --table=cs_currency \
      --table=cs_commodity \
      --table=cs_esuds_carrier_surcharge \
      --table=cs_esuds_error_codes \
      --table=cs_esuds_file_status_master \
      --table=cs_esuds_oney_commodity_master \
      --table=cs_esuds_processing_errors \
      --table=cs_ext_location_master \
      --table=cs_ext_tl_surcharge_location_master \
      --table=cs_fees \
      --table=cs_location_exceptions \
      --table=cs_mode \
      --table=cs_port \
      --table=cs_quote_fee_type \
      --table=cs_scac \
      --table=cs_service_type \
      --table=cs_surcharge \
      --table=cs_tariff_amend_type \
      --table=cs_usa_coast_type \
      --table=cs_user_landing_page \
      --table=cs_user_type \
      --table=cs_reports \
      --table=cs_available_domain_types \
      --table=cs_entity_type \
      --table=cs_user_nav_permission_master \
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
