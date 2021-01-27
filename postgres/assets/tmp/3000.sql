INSERT INTO cs_environment_ims_web_service_auth (
  environment_id,
  public_key,
  private_key,
  user_name,
  password,
  created_date
) VALUES (
  (SELECT client_view_id FROM cs_environment WHERE environment_type = 'QAAUTO'),
  'clientkey',
  'privatekey',
  'cargosphere',
  encrypt('password'::bytea,'ims_ws_pswd'::bytea,'aes'::text),
  now()
);
