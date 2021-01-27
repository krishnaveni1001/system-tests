-- Create QAAUTO environment
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
  gdpr_accepted,
  allow_contract_export,
  currency_adj_factor,
  is_global_deployment,
  tariff_publish_ind,
  nra_enabled,
  has_grace_period,
  allow_contract_global_management,
  can_view_ocean_schedules,
  allow_price_optimization_package,
  allow_quote_share,
  in_rate_share_network,
  allow_mra_discount,
  generate_baf_report,
  generate_contract_report,
	generate_contract_approval_report,
	generate_future_rate_report,
	generate_gri_report,
	generate_quote_volume_report,
	generate_rate_expiration_report,
	generate_user_login_report,
	generate_contract_detail_report
) VALUES
('QAAUTO',' QAAUTO',' QAAUTO',' ',' ',' ',NEXTVAL('cs_environment_client_view_id_seq'),'S',NULL, TRUE, TRUE,TRUE,1,TRUE,'t',TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,true,TRUE);

INSERT INTO cs_environment_domain VALUES ('QAAUTO','dev','localhost','qaauto@cargosphere.biz','f','t');

INSERT INTO cs_default VALUES ('QAAUTO',300,'test-payflow.verisign.com',443,30,10,0,0,0,FALSE,TRUE,FALSE,TRUE,FALSE,'M','S',TRUE,'B','B','B');

INSERT INTO cs_environment_url_auth_users VALUES
  ('QAAUTO','qaauto',(SELECT md5('qaauto:CargoSphere:qaauto123')),'csuser'),
  ('QAAUTO','adqaauto',(SELECT md5('adqaauto:CargoSphere:admin')),'csadmin');

INSERT INTO cs_environment_disclaimer (client_view_id, disclaimer_title, disclaimer)

SELECT client_view_id, 'Standard Disclaimer', quote_disclaimer FROM cs_environment WHERE environment_type = 'QAAUTO';

-- Create QAAUTO super company
INSERT INTO cs_company (
  name,
  entity_type_id,
  hear_entity,
  level_ind,
  client_view_id,
  co_active,
  fmc_number
) VALUES (
  'QAAUTO',
  12,
  'Business',
  '9',
  (SELECT client_view_id FROM cs_environment WHERE environment_type  = 'QAAUTO'),
  true,'000'
);

-- Create QAAUTO super user old Rate search permissions
insert into cs_user (user_type, active, view_seller_offers, post_buyer_offers, private_permission, company_id, login_id, contact, email_addr, password, add_users, default_trader_parms, default_mode_type_id, view_buyer_offers_l2,
post_seller_offers_l2,public_permission_l2, sea_enabled,view_quotes,create_quotes, view_tariffs, create_tariffs,email_quotes, receive_requests_for_portal,review_tariffs,view_entire_tariffs, allow_rate_share_req_upd,
can_view_rates_shared_in_crn, landing_page_id,user_type_id)
values ('S',true, true, true, true, (select company_id from cs_company where level_ind ='9' and hear_entity='Business' and client_view_id = (select client_view_id from cs_environment where environment_type = 'QAAUTO') limit 1),
'qaauto_super', 'Super User', 'dontuse@cargosphere.com', 'pass', true, '9F',3,true,true,true,true,true,true,true,true,true,true,true,true,true, true,2,4);


INSERT INTO cs_contract_scope
( environment_id, contract_scope)
VALUES
((SELECT client_view_id FROM cs_environment WHERE environment_type  = 'QAAUTO'), 'Buy'),
((SELECT client_view_id FROM cs_environment WHERE environment_type  = 'QAAUTO'), 'Sell');

INSERT INTO cs_company_business_unit
( business_unit_id,company_id, business_unit_name, address1, address2, city, state_province, postal_code, country, managedby_user1, managedby_user2, managedby_user3, managedby_user4, managedby_user5)
VALUES
(1,(select company_id from cs_company where level_ind ='9' and hear_entity='Business' and client_view_id = (select client_view_id from cs_environment where environment_type = 'QAAUTO') limit 1), 'Chicago', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2,(select company_id from cs_company where level_ind ='9' and hear_entity='Business' and client_view_id = (select client_view_id from cs_environment where environment_type = 'QAAUTO') limit 1), 'Atlanta', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3,(select company_id from cs_company where level_ind ='9' and hear_entity='Business' and client_view_id = (select client_view_id from cs_environment where environment_type = 'QAAUTO') limit 1), 'Seattle', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


INSERT INTO cs_rate_permissions
  (user_id, permission_type, allow, created_by, created_date)
VALUES
  ((select user_id from cs_user where login_id = 'qaauto_super'), 'CLIENT', true, -1, now()),
  ((select user_id from cs_user where login_id = 'qaauto_super'), 'FCL_BUY', true, -1, now()),
  ((select user_id from cs_user where login_id = 'qaauto_super'), 'FCL_SELL', true, -1, now()),
  ((select user_id from cs_user where login_id = 'qaauto_super'), 'LCL_BUY', true, -1, now()),
  ((select user_id from cs_user where login_id = 'qaauto_super'), 'LCL_SELL', true, -1, now()),
  ((select user_id from cs_user where login_id = 'qaauto_super'), 'MRA1', true, -1, now()),
  ((select user_id from cs_user where login_id = 'qaauto_super'), 'MRA2', true, -1, now());

INSERT INTO cs_api_tokens
  (token, client_id, limit_per_hour, enabled, created_by, created_date)
VALUES (
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJDYXJnb1NwaGVyZSIsInVzZXJJZCI6InFhYXV0b19zdXBlciIsImNsaWVudElkIjoiODAwIiwiY2xpZW50TmFtZSI6Im1hbnVhbC10b2tlbiIsInNvdXJjZSI6ImludGVybmFsIiwic2VydmljZSI6Im5vdGlmaWNhdGlvbi1zZXJ2aWNlIiwicGVybWlzc2lvbnMiOlsiU01UUF9TRU5EIl19.7J_RXwJjSWSwgNtkApYfxDqzzIenootjJwNLNa2ut08',
  800,
  5000,
  TRUE,
  -1,
  now()
);

 INSERT INTO cs_permissions (user_id,permission,created_by,created_date,allow)
 VALUES
 ((select user_id from cs_user where login_id = 'qaauto_super'),'rateManagement', -1,now(),true ),
 ((select user_id from cs_user where login_id = 'qaauto_super'),'accountAdmin', -1,now(),true ),
 ((select user_id from cs_user where login_id = 'qaauto_super'),'fmc', -1,now(),true ),
 ((select user_id from cs_user where login_id = 'qaauto_super'),'quoting', -1,now(),true ),
 ((select user_id from cs_user where login_id = 'qaauto_super'),'reports', -1,now(),true ),
 ((select user_id from cs_user where login_id = 'qaauto_super'),'rateMesh', -1,now(),true ),
 ((select user_id from cs_user where login_id = 'qaauto_super'),'systemAdmin', -1,now(),true ),
 ((select user_id from cs_user where login_id = 'qaauto_super'),'rateSearch', -1,now(),true );

INSERT INTO cs_permissions_rate_search (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'rateSearch'), 'VIEW_LCL_BUY','','{"geographies": [{"id": 0, "origins": [{"country": "World", "countryCode": "00"}], "destinations": [{"country": "World", "countryCode": "00"}]}]}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'rateSearch'), 'VIEW_FCL_SELL','','{"geographies": [{"id": 0, "origins": [{"country": "World", "countryCode": "00"}], "destinations": [{"country": "World", "countryCode": "00"}]}]}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'rateSearch'), 'VIEW_LCL_SELL','','{"geographies": [{"id": 0, "origins": [{"country": "World", "countryCode": "00"}], "destinations": [{"country": "World", "countryCode": "00"}]}]}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'rateSearch'), 'VIEW_FCL_BUY','','{"geographies": [{"id": 0, "origins": [{"country": "World", "countryCode": "00"}], "destinations": [{"country": "World", "countryCode": "00"}]}]}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'rateSearch'), 'VIEW_MRA1','','{"geographies": [{"id": 0, "origins": [{"country": "World", "countryCode": "00"}], "destinations": [{"country": "World", "countryCode": "00"}]}]}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'rateSearch'), 'VIEW_MRA2','','{"geographies": [{"id": 0, "origins": [{"country": "World", "countryCode": "00"}], "destinations": [{"country": "World", "countryCode": "00"}]}]}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'rateSearch'), 'VIEW_CONTRACT_WITH_SCOPE','ALL_SCOPE','{}',true,-1,now() ),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'rateSearch'), 'VIEW_MARK_UP','','{}',true,-1,now() ),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'rateSearch'), 'VIEW_NAMED_ACC','ALL_NA','{}',true,-1,now());

INSERT INTO cs_permissions_sys_admin (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'systemAdmin'), 'MANAGE_BUSI_UNITS','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'systemAdmin'), 'MANAGE_SUPER_USR','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'systemAdmin'), 'MANAGE_SYS_PASSWORD','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'systemAdmin'), 'MANAGE_IP_PERMIT','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'systemAdmin'), 'MANAGE_COUNTRY_RESTRICT','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'systemAdmin'), 'MANAGE_INDUS_COMMO','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'systemAdmin'), 'MANAGE_CONTRACT_MARK','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'systemAdmin'), 'MANAGE_MRA_DISCOUNT','','{"options": {"mra1": true, "mra2": true}}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'systemAdmin'), 'MANAGE_QUOTE_SETTINGS','','{"options": {"disclaimers": true, "currencyBump": true, "valueAddedTax": true, "termsAndConditions": true, "quotePackagePreferences": true, "globalForwarderOrBrokerFees": true}}',true,-1,now());

INSERT INTO cs_permissions_rate_management (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'rateManagement'), 'MANAGE_CONTRACTS','ALL_CONTRACTS','{"options": {"viewAndUpdateContractRates": true, "reviewAndApproveContractRates": true, "manageSurchargesWithinAContract": true, "SUDSUploadContractsAndAmendments": true}}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'rateManagement'), 'CAN_BE_INTERNAL_CONTRACT_OWNER','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'rateManagement'), 'MANAGE_GBL_SUR_GRI','','{}',true,-1,now());

INSERT INTO cs_permissions_account_admin (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'accountAdmin'), 'MANAGE_CARRIERS','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'accountAdmin'), 'MANAGE_CUST_AGENTS','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'accountAdmin'), 'MANAGE_FMC_USR','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'accountAdmin'), 'MANAGE_TARIFF_RECORD','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'accountAdmin'), 'MANAGE_USERS','ALL_USERS','{}',true,-1,now());


INSERT INTO cs_permissions_fmc (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'fmc'), 'CREATE_MANAGE_TARRIF','','{"requireApprovalForRelease": true}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'fmc'), 'REVIEW_RELEASE_TARRIF','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'fmc'), 'VIEW_TARIFF','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'fmc'), 'VIEW_TARIFF_FMC','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'fmc'), 'VIEW_NRAs','','{}',true,-1,now());

INSERT INTO cs_permissions_quote (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'quoting'), 'CREATE_CUST_QUOTES','','{"emailQuotes": true, "receiveInternalRateRequests": true}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'quoting'), 'CREATE_RATE_REQ','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'quoting'), 'UPD_APP_CUST_QUOTES','ALL','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'quoting'), 'VIEW_CUST_QUOTES','ALL','{}',true,-1,now());

INSERT INTO cs_permissions_reports (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'reports'), 'VIEW_REPORTS','ALL_REPORTS','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'reports'), 'VIEW_DASHBOARDS','ALL_DASHBOARDS','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'reports'), 'VIEW_SYSTEM_USAGE','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'reports'), 'VIEW_QUOTE_ANA','','{}',true,-1,now());


INSERT INTO cs_permissions_rate_mesh (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'qaauto_super') AND permission = 'rateMesh'), 'MANAGE_RM_CONNECT','','{}',true,-1,now());
