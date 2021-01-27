-- Create DACHSER environment
INSERT INTO cs_environment (
  environment_type,
  client_name,
  client_short_name,
  address1,
  address2,
  contact_number,
  client_view_id,
  deployment_type,
  association_belong_ids,
  suds_enabled,
  gdpr_accepted
) VALUES (
  'DACHSER',
  ' DACHSER',
  ' DACHSER',
  ' ',
  ' ',
  ' ',
  NEXTVAL('cs_environment_client_view_id_seq'),
  'S',
  NULL,
  TRUE,
  TRUE
);
