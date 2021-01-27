-- Create E-ONEY Environment
INSERT INTO cs_environment (
  environment_type,
  client_name,
  client_short_name,
  client_view_id,
  deployment_type,
  suds_enabled,
  gdpr_accepted
) VALUES (
  'E-ONEY',
  'E-ONEY',
  'E-ONEY',
  NEXTVAL('cs_environment_client_view_id_seq'),
  'S',
  TRUE,
  TRUE
);

INSERT INTO cs_environment_domain VALUES ('E-ONEY', 'dev', 'localhost', 'e-oney@cargosphere.biz', 'f', 't');

INSERT INTO cs_default VALUES ('E-ONEY', 300, 'test-payflow.verisign.com', 443, 30, 10, 0, 0, 0, FALSE, TRUE, FALSE, TRUE, FALSE, 'M', 'S', TRUE, 'B', 'B', 'B');

INSERT INTO cs_environment_url_auth_users VALUES('E-ONEY', 'e-oney', (SELECT md5('e-oney:CargoSphere:e-oney123')),'csuser');

INSERT INTO cs_environment_url_auth_users VALUES('E-ONEY', 'ade-oney', (SELECT md5('ade-oney:CargoSphere:admin')),'csadmin');

INSERT INTO cs_environment_disclaimer (client_view_id, disclaimer_title, disclaimer) SELECT client_view_id, 'Standard Disclaimer', quote_disclaimer FROM cs_environment WHERE environment_type = 'E-ONEY';

-- Create the level 9 company for the master user
INSERT INTO cs_company (
  name,
  entity_type_id,
  hear_entity,
  level_ind,
  client_view_id,
  co_active
) VALUES (
  'E-ONEY',
  12,
  'Business',
  '9',
  (SELECT client_view_id FROM cs_environment WHERE environment_type = 'E-ONEY'),
  TRUE
 );

-- Create the super user
INSERT INTO cs_user (
  user_type,                active,                       view_seller_offers,           post_buyer_offers,    private_permission,
  company_id,               login_id,                     contact,                      email_addr,           password,
  add_users,                default_trader_parms,         default_mode_type_id,         view_buyer_offers_l2, post_seller_offers_l2,
  public_permission_l2,     sea_enabled,                  view_quotes,                  create_quotes,        view_tariffs,
  create_tariffs,           email_quotes,                 receive_requests_for_portal,  review_tariffs,       view_entire_tariffs,
  allow_rate_share_req_upd, can_view_rates_shared_in_crn, landing_page_id
) VALUES (
  'S', TRUE, TRUE, TRUE, TRUE,
  (SELECT company_id FROM cs_company WHERE level_ind ='9' AND hear_entity='Business' AND client_view_id = (SELECT client_view_id FROM cs_environment WHERE environment_type = 'E-ONEY') LIMIT 1), 'e-oney_super', 'Super User', 'dontuse@cargosphere.com', 'pass',
  TRUE, '9F', 3, TRUE, TRUE,
  TRUE, TRUE, TRUE, TRUE, TRUE,
  TRUE, TRUE, TRUE, TRUE, TRUE,
  TRUE, TRUE, 2
);

-- Create the level 2 carrier company
INSERT INTO cs_company (
  name,
  entity_type_id,
  hear_entity,
  level_ind,
  client_view_id,
  co_active,
  mode_id,
  scac_id,
  esuds_notify_email
)
VALUES (
  'ONEY eSUDS',
  5,
  '2',
  '1',
  (SELECT client_view_id FROM cs_environment WHERE environment_type = 'E-ONEY'),
  TRUE,
  3,
  'ONEY',
  '{carrier-engagement@cargosphere.com}'
);

-- Create the carrier user
INSERT INTO cs_user (
  user_type,  active,   view_buyer_offers,  post_seller_offers, public_permission,
  company_id,
  login_id, contact, email_addr, password, add_users, default_trader_parms,sea_enabled
) VALUES (
  'S', TRUE, TRUE, TRUE, TRUE,
  (SELECT company_id FROM cs_company WHERE level_ind ='1' AND client_view_id = (SELECT client_view_id FROM cs_environment WHERE environment_type = 'E-ONEY') LIMIT 1),
  'tempuser',
  'eSUDS CARRIER',
  'carrier_engagement@cargosphere.com',
  'pass',
  TRUE,
  '0F',
  TRUE
);

-- Create the API company
INSERT INTO cs_company (
  name,
  level_ind,
  client_view_id,
  scac_id
) VALUES (
  'ESUDS API',
  '3',
  (SELECT client_view_id FROM cs_environment WHERE environment_type = 'E-ONEY'),
  'ONEY'
);

-- Create the API user
INSERT INTO cs_user (
  user_type,
  company_id,
  login_id,
  contact,
  password,
  active
) VALUES (
  'N',
  (SELECT company_id FROM cs_company WHERE level_ind ='3' AND client_view_id = (SELECT client_view_id FROM cs_environment WHERE environment_type = 'E-ONEY') LIMIT 1),
  'e-oney_api',
  'eSUDS API User',
  'pass',
  TRUE
);

-- Link to QAAUTO
INSERT INTO cs_carrier_customer_mapping
VALUES (
  (SELECT client_view_id FROM cs_environment WHERE environment_type='E-ONEY'),
  'QA001',
  'QA001',
  (SELECT client_view_id FROM cs_environment WHERE environment_type = 'QAAUTO'),
  (SELECT company_id FROM cs_company WHERE level_ind ='9' AND hear_entity='Business' AND client_view_id = (SELECT client_view_id FROM cs_environment WHERE environment_type = 'QAAUTO'))
);

-- Enable Rate Share
UPDATE cs_environment
SET
  env_share_ids = ('{' || (SELECT client_view_id FROM cs_environment WHERE environment_type = 'QAAUTO')::text || '}')::int[],
  connected_environment_ids = ('{' || (SELECT client_view_id FROM cs_environment WHERE environment_type = 'QAAUTO')::text || '}')::int[],
  is_global_deployment = TRUE,
  allow_1to1rate_share = TRUE
WHERE
  environment_type = 'E-ONEY';
