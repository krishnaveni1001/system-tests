-- Create E-ANLC environment
INSERT INTO cs_environment (
  environment_type, client_name,      client_short_name,
  address1,         address2,         contact_number,
  client_view_id,   deployment_type,  association_belong_ids,
  suds_enabled,     gdpr_accepted,
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
) VALUES ('E-ANLC','E-ANLC','E-ANLC',' ',' ',' ',NEXTVAL('cs_environment_client_view_id_seq'),'S',NULL, TRUE, TRUE,TRUE,1,TRUE,'t',TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,true,TRUE);

INSERT INTO cs_environment_domain VALUES ('E-ANLC','dev','localhost','e-anlc@cargosphere.biz','f','t');

INSERT INTO cs_default VALUES ('E-ANLC',300,'test-payflow.verisign.com',443,30,10,0,0,0,FALSE,TRUE,FALSE,TRUE,FALSE,'M','S',TRUE,'B','B','B');

INSERT INTO cs_environment_url_auth_users VALUES
  ('E-ANLC','e-anlc',(SELECT md5('e-anlc:CargoSphere:e-anlc')),'csuser'),
  ('E-ANLC','ade-anlc',(SELECT md5('ade-anlc:CargoSphere:admin')),'csadmin');

-- Create an entry for enviroment disclaimer for ANLC
INSERT INTO cs_environment_disclaimer (client_view_id, disclaimer_title, disclaimer)
SELECT client_view_id, 'Standard Disclaimer', quote_disclaimer FROM cs_environment WHERE environment_type = 'E-ANLC';

-- Create the super company
INSERT INTO cs_company (name, entity_type_id, hear_entity, level_ind, client_view_id, co_active)
VALUES ('E-ANLC', 12, 'Business', '9', (SELECT client_view_id FROM cs_environment WHERE environment_type  = 'E-ANLC'), true);

-- Create super user
insert into cs_user (user_type, active, view_seller_offers, post_buyer_offers, private_permission, company_id, login_id, contact, email_addr, password, add_users, default_trader_parms, default_mode_type_id, view_buyer_offers_l2,
post_seller_offers_l2,public_permission_l2, sea_enabled,view_quotes,create_quotes, view_tariffs, create_tariffs,email_quotes, receive_requests_for_portal,review_tariffs,view_entire_tariffs, allow_rate_share_req_upd,
can_view_rates_shared_in_crn, landing_page_id,user_type_id)
values ('S',true, true, true, true, (select company_id from cs_company where level_ind ='9' and hear_entity='Business' and client_view_id = (select client_view_id from cs_environment where environment_type = 'E-ANLC') limit 1),
'e-anlc_super', 'Super User', 'dontuse@cargosphere.com', 'pass', true, '9F',3,true,true,true,true,true,true,true,true,true,true,true,true,true, true,2,4);

-- Create carrier company
insert into cs_company (name, entity_type_id, hear_entity, level_ind, client_view_id, co_active, mode_id, scac_id, esuds_notify_email)
values ('ANLC eSUDS', 5, '2', '1', (select client_view_id from cs_environment where environment_type  = 'E-ANLC'), true, 3, 'ANLC', '{carrier-engagement@cargosphere.com}');

--CARRIER USER
insert into cs_user (user_type, active, view_buyer_offers, post_seller_offers, public_permission, company_id, login_id, contact, email_addr, password, add_users, default_trader_parms,
sea_enabled)
values ('S',true, true, true, true, (select company_id from cs_company where level_ind ='1' and client_view_id = (select client_view_id from cs_environment where environment_type = 'E-ANLC') limit 1),
'tempuser', 'eSUDS CARRIER', 'carrier_engagement@cargosphere.com', 'pass', true, '0F',true);

-- Create API company
INSERT INTO cs_company (name,level_ind,client_view_id, scac_id) VALUES ('ESUDS API', '3', (select client_view_id from cs_environment where environment_type = 'E-ANLC'), 'ANLC');

-- Create API user
INSERT INTO cs_user (user_type, company_id, login_id, contact, password, active)
VALUES ('N', (select company_id from cs_company where level_ind ='3' and client_view_id = (select client_view_id from cs_environment where environment_type = 'E-ANLC') limit 1), 'e-anlc_api', 'eSUDS API User', 'pass', true);

insert into cs_carrier_customer_mapping
values
(
  (select client_view_id from cs_environment where environment_type='E-ANLC'),
  'QA001',
  'QA001',
  (select client_view_id from cs_environment where environment_type = 'QAAUTO'),
  (select company_id from cs_company where level_ind ='9' and hear_entity='Business' and client_view_id =
    (select client_view_id from cs_environment where environment_type = 'QAAUTO')
  )
),
(
  (select client_view_id from cs_environment where environment_type='E-ANLC'),
  'DACHSER SE',
  'DACHSER SE',
  (select client_view_id from cs_environment where environment_type = 'QAAUTO'),
  (select company_id from cs_company where level_ind ='9' and hear_entity='Business' and client_view_id =
    (select client_view_id from cs_environment where environment_type = 'QAAUTO')
  )
),
(
  (select client_view_id from cs_environment where environment_type='E-ANLC'),
  'KUEHNE+NAGEL', 'KUEHNE+NAGEL',
  (select client_view_id from cs_environment where environment_type = 'QAAUTO'),
  (select company_id from cs_company where level_ind ='9' and hear_entity='Business' and client_view_id =
    (select client_view_id from cs_environment where environment_type = 'QAAUTO')
  )
);

-- Enable Rate Share
UPDATE cs_environment SET
  env_share_ids = ('{' || (SELECT client_view_id FROM cs_environment WHERE environment_type = 'QAAUTO')::text || '}')::int[],
  connected_environment_ids = ('{' || (SELECT client_view_id FROM cs_environment WHERE environment_type = 'QAAUTO')::text || '}')::int[],
  is_global_deployment = true,
  allow_1to1rate_share = true
WHERE environment_type = 'E-ANLC';

INSERT INTO cs_rate_permissions
  (user_id, permission_type, allow, created_by, created_date)
VALUES
  ((select user_id from cs_user where login_id = 'e-anlc_super'), 'CLIENT', true, -1, now()),
  ((select user_id from cs_user where login_id = 'e-anlc_super'), 'FCL_BUY', true, -1, now()),
  ((select user_id from cs_user where login_id = 'e-anlc_super'), 'FCL_SELL', true, -1, now()),
  ((select user_id from cs_user where login_id = 'e-anlc_super'), 'LCL_BUY', true, -1, now()),
  ((select user_id from cs_user where login_id = 'e-anlc_super'), 'LCL_SELL', true, -1, now()),
  ((select user_id from cs_user where login_id = 'e-anlc_super'), 'MRA1', true, -1, now()),
  ((select user_id from cs_user where login_id = 'e-anlc_super'), 'MRA2', true, -1, now());

-- -- Container Mapping
INSERT INTO cs_container_vendor_mapping (
  container_type_id,
  scac_id,
  vendor_text,
  soc_flag,
  nor_flag,
  ref_flag,
  or_flag,
  container_type,
  container_cargo_type,
  container_owner,
  cntr_load_flag
) VALUES
(1, 'ANLC', '22G0', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(2, 'ANLC', '42G0', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(4, 'ANLC', '45G1', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(173, 'ANLC', '22G0', 'F', 'T', 'F', NULL, NULL, NULL, NULL, 'B'),
(174, 'ANLC', '42G0', 'F', 'T', 'F', NULL, NULL, NULL, NULL, 'B'),
(175, 'ANLC', '45G1', 'F', 'T', 'F', NULL, NULL, NULL, NULL, 'B'),
(181, 'ANLC', '22G0', 'T', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(182, 'ANLC', '42G0', 'T', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(15, 'ANLC', '40HREF', 'F', 'F', 'T', NULL, NULL, NULL, NULL, 'B'),
(174, 'ANLC', '42G0', 'F', 'T', 'F', NULL, NULL, NULL, NULL, 'B'),
(181, 'ANLC', '22G0', 'T', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(13, 'ANLC', '20REEF', 'F', 'F', 'T', NULL, NULL, NULL, NULL, 'B'),
(181, 'ANLC', '20DRY_SOC', 'T', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(182, 'ANLC', '40DRY_SOC', 'T', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(183, 'ANLC', '40HDRY_SOC', 'T', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(11, 'ANLC', '20OPEN', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(39, 'ANLC', '40FLAT', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(12, 'ANLC', '40OPEN', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(547, 'ANLC', '40FLAT_SOC', 'T', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(546, 'ANLC', '20FLAT_SOC', 'T', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(188, 'ANLC', '20OPEN_SOC', 'T', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(269, 'ANLC', '40OPEN_SOC', 'T', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(309, 'ANLC', '45HDRY_SOC', 'T', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(173, 'ANLC', '22G0', 'F', 'T', 'F', NULL, NULL, NULL, NULL, 'B'),
(175, 'ANLC', '45G1', 'F', 'T', 'F', NULL, NULL, NULL, NULL, 'B'),
(1, 'ANLC', '22G0', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(4, 'ANLC', '45G1', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(182, 'ANLC', '42G0', 'T', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(2, 'ANLC', '42G0', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(200, 'ANLC', 'PER_CONTAINER', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(1, 'ANLC', '20DRY', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(2, 'ANLC', '40DRY', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(3, 'ANLC', '40HDRY', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(173, 'ANLC', '20REEF_NOR', 'F', 'T', 'T', NULL, NULL, NULL, NULL, 'B'),
(175, 'ANLC', '40HREF_NOR', 'F', 'T', 'T', NULL, NULL, NULL, NULL, 'B'),
(306, 'ANLC', 'PER_DOC', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B'),
(4, 'ANLC', '45HDRY', 'F', 'F', 'F', NULL, NULL, NULL, NULL, 'B');

INSERT INTO cs_esuds_common_key_string_cols
(col_list,scac_id,data_type,is_fmc)
VALUES
('receipt,loadport,effectivedate,expirydate,currency,cargotype,cntr_20dry,cntr_20ref,cntr_20refnor,cntr_40dry,cntr_40hdry,cntr_40href,cntr_40hrefnor,cntr_45hdry,quotenumber','ANLC','inland_error_duplicate_cols',false),
('receipt,loadport,effectivedate,expirydate,currency,cargotype,cntr_20dry,cntr_20ref,cntr_20refnor,cntr_40dry,cntr_40hdry,cntr_40href,cntr_40hrefnor,cntr_45hdry,quotenumber','ANLC','inland_compare_cols',false),
('receipt,portofloading,portofdischarge,delivery,effectivedate,expirydate,servicemode,commodityname,inclusivesurcharge,charge,ratebasis,cntr_20dry,cntr_20reefnor,cntr_40dry,cntr_40hdry,cntr_40href,cntr_40hrefnor,cntr_45hdry,cntr_20drysoc,cntr_40drysoc,cntr_40hdrysoc,cntr_20open,cntr_40flat,cntr_40open,quotenumber','ANLC','contract_error_duplicate_cols',false),
('receipt,portofloading,portofdischarge,delivery,effectivedate,expirydate,servicemode,commodityname,inclusivesurcharge,charge,ratebasis,cntr_20dry,cntr_20reefnor,cntr_40dry,cntr_40hdry,cntr_40href,cntr_40hrefnor,cntr_45hdry,cntr_20drysoc,cntr_40drysoc,cntr_40hdrysoc,cntr_20open,cntr_40flat,cntr_40open,quotenumber,basketcontract','ANLC','contract_compare_cols',false);


INSERT INTO cs_permissions (user_id,permission,created_by,created_date,allow)
VALUES
((select user_id from cs_user where login_id = 'e-anlc_super'),'rateManagement', -1,now(),true ),
((select user_id from cs_user where login_id = 'e-anlc_super'),'accountAdmin', -1,now(),true ),
((select user_id from cs_user where login_id = 'e-anlc_super'),'fmc', -1,now(),true ),
((select user_id from cs_user where login_id = 'e-anlc_super'),'quoting', -1,now(),true ),
((select user_id from cs_user where login_id = 'e-anlc_super'),'reports', -1,now(),true ),
((select user_id from cs_user where login_id = 'e-anlc_super'),'rateMesh', -1,now(),true ),
((select user_id from cs_user where login_id = 'e-anlc_super'),'systemAdmin', -1,now(),true ),
((select user_id from cs_user where login_id = 'e-anlc_super'),'rateSearch', -1,now(),true );

INSERT INTO cs_permissions_rate_search (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'rateSearch') , 'VIEW_LCL_BUY','','{"ids": [{"id": 0, "origins": [{"country": "World", "countryCode": "00"}], "destinations": [{"country": "World", "countryCode": "00"}]}]}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'rateSearch'), 'VIEW_FCL_SELL','','{"ids": [{"id": 0, "origins": [{"country": "World", "countryCode": "00"}], "destinations": [{"country": "World", "countryCode": "00"}]}]}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'rateSearch'), 'VIEW_LCL_SELL','','{"ids": [{"id": 0, "origins": [{"country": "World", "countryCode": "00"}], "destinations": [{"country": "World", "countryCode": "00"}]}]}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'rateSearch'), 'VIEW_FCL_BUY','','{"ids": [{"id": 0, "origins": [{"country": "World", "countryCode": "00"}], "destinations": [{"country": "World", "countryCode": "00"}]}]}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'rateSearch'), 'VIEW_MRA1','MRA1','{"ids": [{"id": 0, "origins": [{"country": "World", "countryCode": "00"}], "destinations": [{"country": "World", "countryCode": "00"}]}]}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'rateSearch'), 'VIEW_MRA2','MRA2','{"ids": [{"id": 0, "origins": [{"country": "World", "countryCode": "00"}], "destinations": [{"country": "World", "countryCode": "00"}]}]}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'rateSearch'), 'VIEW_CONTRACT_WITH_SCOPE','ALL_SCOPE','{}',true,-1,now() ),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'rateSearch'), 'VIEW_MARK_UP','','{}',true,-1,now() ),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'rateSearch'), 'VIEW_NAMED_ACC','ALL_NA','{}',true,-1,now());

INSERT INTO cs_permissions_sys_admin (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'systemAdmin'), 'MANAGE_COMP_PROFILE','','{}',true,-1,now() ),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'systemAdmin'), 'MANAGE_BUSI_UNITS','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'systemAdmin'), 'MANAGE_SUPER_USR','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'systemAdmin'), 'MANAGE_APP_SETTINGS','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'systemAdmin'), 'MANAGE_IP_PERMIT','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'systemAdmin'), 'MANAGE_COUNTRY_RESTRICT','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'systemAdmin'), 'MANAGE_INDUS_COMMO','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'systemAdmin'), 'MANAGE_CONTRACT_MARK','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'systemAdmin'), 'MANAGE_MRA_DISCOUNT','','{"options": {"mra1": true, "mra2": true}}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'systemAdmin'), 'MANAGE_QUOTE_SETTINGS','','{"options": {"disclaimers": true, "currencyBump": true, "valueAddedTax": true, "termsAndConditions": true, "quotePackagePreferences": true, "globalForwarderOrBrokerFees": true}}',true,-1,now());

INSERT INTO cs_permissions_rate_management (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'rateManagement'), 'MANAGE_CONTRACTS','ALL_CONTRACTS','{"options": {"viewAndUpdateContractRates": true, "reviewAndApproveContractRates": true, "manageSurchargesWithinAContract": true, "SUDSUploadContractsAndAmendments": true}}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'rateManagement'), 'CAN_BE_INT_OWNER','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'rateManagement'), 'MANAGE_GBL_SUR_GRI','','{}',true,-1,now());

INSERT INTO cs_permissions_account_admin (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'accountAdmin'), 'MANAGE_CARRIERS','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'accountAdmin'), 'MANAGE_CUST_AGENTS','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'accountAdmin'), 'MANAGE_FMC_USR','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'accountAdmin'), 'MANAGE_TARIFF_RECORD','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'accountAdmin'), 'MANAGE_USERS','ALL_USERS','{}',true,-1,now());


INSERT INTO cs_permissions_fmc (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'fmc'), 'CREATE_MANAGE_TARRIF','','{"requireApprovalForRelease": true}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'fmc'), 'REVIEW_RELEASE_TARRIF','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'fmc'), 'VIEW_TARIFF','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'fmc'), 'VIEW_TARIFF_FMC','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'fmc'), 'VIEW_NRAs','','{}',true,-1,now());

INSERT INTO cs_permissions_quote (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'quoting'), 'CREATE_CUST_QUOTES','EMAIL_QUOTE','{"emailQuotes": true, "receiveInternalRateRequests": true}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'quoting'), 'CREATE_RATE_REQ','','{"toPricing": true, "toCarriers": true}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'quoting'), 'UPD_APP_CUST_QUOTES','ALL','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'quoting'), 'VIEW_CUST_QUOTES','ALL','{}',true,-1,now());

INSERT INTO cs_permissions_reports (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'reports'), 'VIEW_REPORTS','ALL_REPORTS','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'reports'), 'VIEW_DASHBOARDS','ALL_DASHBOARDS','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'reports'), 'VIEW_SYSTEM_USAGE','','{}',true,-1,now()),
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'reports'), 'VIEW_QUOTE_ANA','','{}',true,-1,now());


INSERT INTO cs_permissions_rate_mesh (permission_id,permission,permission_attribute,xref,allow,created_by,created_date)
VALUES
((select permission_id FROM cs_permissions WHERE user_id = (select user_id from cs_user where login_id = 'e-anlc_super') AND permission = 'rateMesh'), 'MANAGE_RM_CONNECT','','{}',true,-1,now());
