-- Generic global data
-- Add available domains
INSERT INTO cs_available_domain_types (
  environment_ind,
  available_domain_type
) VALUES
( 'dev', 'dev' );

INSERT INTO cs_api_tokens (
  token,
  client_id,
  limit_per_hour,
  enabled,
  created_by,
  created_date
) VALUES
( 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJDYXJnb1NwaGVyZSIsInVzZXJJZCI6ImRtYXN0ZXIiLCJjbGllbnRJZCI6IjEwMiIsImNsaWVudE5hbWUiOiJyYXYtY2xpZW50Iiwic291cmNlIjoic3lzdGVtIGdlbmVyYXRlZCBhdXRvbWF0ZWQgdGVzdCBzdWl0ZSJ9.tD_9GQRmRlOWuTTy0ya7dnj3WU8uEbyHYnTEJDDSWRY', 800, 5000, true, -1, now() ),
( 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJDYXJnb1NwaGVyZSIsInVzZXJJZCI6ImRtYXN0ZXIiLCJjbGllbnRJZCI6IjEwMiIsImNsaWVudE5hbWUiOiJzdWRzLWVuZ2luZS1jbGllbnQiLCJzb3VyY2UiOiJzeXN0ZW0gZ2VuZXJhdGVkIGF1dG9tYXRlZCB0ZXN0IHN1aXRlIn0.jb4TPXUBrfg6Gxz_yL9vWIha0IV8FuCuNgnrhr70LD0', 800, 5000, true, -1, now() ),
-- CW1 SSO token
( 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoic2VydmljZSIsInVzZXJJZCI6LTEsInVzZXJUeXBlSWQiOjQsImFkbWluSWQiOjIsImNsaWVudFZpZXdJZCI6MTAyLCJwZXJtaXNzaW9ucyI6e30sImlzcyI6IkNhcmdvU3BoZXJlIiwiaWF0IjoxNTYyMDA4Mjc2fQ.pq2TdBOvOaSlvwuMfuxAty17ggtp8lKXJqSOGaiISJs2y5f_HDlCbJ4H3FAPNNYh41XPQNxUwjIYq2fIX3G7jfmu8UrhdryMGRmgnWBiM5MM1AA1VKTN0ZyI6q33Goh0N-Sz7uRfovUnG2n5wzHt3RZIC2ADzjlTUdZoBMcMgV8QWz1IroN0pTaomqjk3I_Web6ZwuTXoZdZ8dAsqvXEDnOL00xGKZjPavTQ8elBVKVhpunW0-b7wE4jTU54gIIE-IKamxYXDgLi88mOn0VgnydMuDwsH68emfyOj6Ei6lWlE_DmtUTEoCnL-nywiAcBMwlhYnbwj1SSBV8-XR2XcA', 800, 5000, true, -1, now() ),
( 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoic2VydmljZSIsInVzZXJJZCI6LTEsInVzZXJUeXBlSWQiOjQsImFkbWluSWQiOjAsImNsaWVudFZpZXdJZCI6MCwicGVybWlzc2lvbnMiOnt9LCJpc3MiOiJDYXJnb1NwaGVyZSIsImlhdCI6MTU2MjAwODI3Nn0.bsUyFI8HMgUdhFWF4GCVYGGCEZ4I3a2HJ7fT8JbGA-03vneAAkaAfyOPI7WQMZyIWIqc06nWlBh8R7p2ZCGCqaVEm39zRT366qoxT30I7-88li-rnr9YGGlGaU3DjNhtkbL0QhdYe2jzBGTcYpFlwAhowheNbhG6lLjBppW7z3WMdriEpDZMVn7PNz0Z9J4GANcWKQD9PU5pBBZghPxCctrkmfw9AmZol1BfIdoyDVegoNPp4Sh--AIRfIbYaIaL56tuuCFyY80s0eEeRCP2qrqqRusqBxNTp8fy3rj-KhWDU1MJUkQ8NeWWJDc1BlEKGNHYJxtdxXesoKSpi5DbTw', 800, 5000, true, -1, now());

-- Create rate search version entries
INSERT INTO cs_rate_search_versions
  (rate_search_version, end_point, status, initial)
VALUES(
  '2.0.1', '/2', 'active', true
);

-- Create default quote package preferences entries
INSERT INTO cs_quote_package_preferences (
  user_id,                      environment_id,                   transport_mode,
  display_carrier_names,        display_all_surcharges,           display_surcharge_values,
  show_subject_to_surcharges,   display_rate_fee_total,           suppress_inland_routing,
  suppress_rate_valid_to_date,  suppress_service_info,            suppress_service_type,
  suppress_rate_type,           suppress_transit_time,            suppress_service_frequency,
  suppress_inland_rate_type,    suppress_inland_mode_type,        display_container_and_unit_together,
  display_rate_breakdown,       display_separate_by_lane_segment, display_surcharge_legend,
  display_country_legend,       allow_interactive,                allow_agents_inherit_qp,
  use_filter_override,          display_comm_group_name,          display_currency_conversions
) VALUES
  (-1, -1, 1, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false),
  (-1, -1, 2, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false),
  (-1, -1, 3, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false);

-- Create default single quote preferences entry
INSERT INTO cs_single_quote_preferences
(user_id, environment_id, transport_mode, display_carrier_names, display_freight_detail, display_inland_detail, display_piece_info_detail, display_shipment_fee_detail, display_lump_sum, display_surcharge_detail, display_dimension_weight_detail, display_surcharge_legend, allow_interactive, display_currency_conversions, allow_agents_inherit_qp)
VALUES(-1, -1, 1, false, false, false, false, false, false, false, false, false, false, false, false),(-1, -1, 2, false, false, false, false, false, false, false, false, false, false, false, false),(-1, -1, 3, false, false, false, false, false, false, false, false, false, false, false, false);

-- Create default search preferences entry
INSERT INTO cs_rate_search_preferences
(user_id, search_type, surcharge_type, view_style, currency_id, environment_id, sort_order, carrier_filters)
VALUES(-1, 'FB', 'B', 1, 1, -1, 'L', 1);

-- Add dimension and weight types
INSERT INTO cs_dimension_type
(dimension_type_id, name)
VALUES
(1, 'inch(es)'),
(2, 'foot/feet'),
(3, 'cm(s)'),
(4, 'meter(s)');

INSERT INTO cs_weight_type
(weight_type_id, name)
VALUES
(0, 'Lbs'),
(1, 'Kgs');

-- Add base data for every scac so SUDS will work
INSERT INTO cs_suds_master_data_definitions_scac_v2
(scac_id,cell_definitions)
select scac_id, '{}'::json from cs_scac;

INSERT INTO cs_suds_master_data_validations_scac_v2
(scac_id,cell_validations)
select scac_id, '{}'::json from cs_scac;

INSERT INTO cs_esuds_common_key_string_cols
(col_list,scac_id,data_type,is_fmc)
VALUES
('trade_lane_id, commodity_group_id,container_type_id, service_type_ind,inland_rate_type,rate_type_2,service_string_id, vessel_id,base_location_id, base_location_type, base_port_id,location_id, location_type, port_id,orig_dest_ind,named_account_group_id,chassis_provided::text,weight_break_ind,rate_type, inland_routes::text,inland_mode_type_ind', 'All', 'Inland', NULL),
('surcharge_id,surcharge_type,surcharge_category_ind', 'All', 'surcharge_key', NULL),
('surcharge_id,surcharge_type,surcharge_category_ind', 'All', 'inland_surcharge_key', NULL),
('surcharge_id,surcharge_type,surcharge_category_ind', 'All', 'surcharge_key_ocean_contract', NULL),
('trade_lane_id, commodity_group_id, container_type_id, service_type_ind, rate_type, rate_type_2, service_string_id, vessel_id, origination_id, orig_location_type, orig_routing_id, destination_id, dest_location_type, dest_routing_id, named_account_group_id, arbs_ind, ocean_routes::text,origin_transport_mode,destination_transport_mode', 'All', 'Contract', NULL),
('environment_id,carrier_id,trade_lane_id,origination_id,orig_country_code,destination_id,dest_country_code,container_type_id,surcharge_id,surcharge_type, designation_ind,price_by_id,load_type_ind,orig_routing_id, dest_routing_id, srt_location_id, srt_country_code, vp1_location_id,vp2_location_id,vp3_location_id,vm1_location_id,vm2_location_id,vm3_location_id,vo1_location_id,vo2_location_id,vo3_location_id, end_location_id, end_country_code, container_size_ind,container_type_ind,external_reference_id,rate_type,service_string_id,external_rate_ref_id, quantity_per_rate,price_by_unit_of_measure,tier_lower_bound,tier_upper_bound,tier_unit_of_measure,free_time_orig_or_dest,free_time_level,free_time_lower_bound, free_time_number_days,free_time_type,service_type_id ,payment_type,eincoming,free_time_count_rule,is_haz,is_nor,is_soc,is_oog,named_account_id', 'All', 'Level2', false),
('environment_id,carrier_id,trade_lane_id,origination_id,orig_country_code,destination_id,dest_country_code, container_type_id,container_size_ind,container_type_ind, surcharge_id,surcharge_type,designation_ind,price_by_id,bill_of_lading_nbr,recipient_env_id,load_type_ind, orig_routing_ids::text,orig_routing_loc_ids::text,dest_routing_ids::text,dest_routing_loc_ids::text, container_size_ind,container_type_ind, orig_location_type,dest_location_type,rate_type,service_string_id,external_rate_ref_id, quantity_per_rate,price_by_unit_of_measure,tier_lower_bound,tier_upper_bound,tier_unit_of_measure, free_time_orig_or_dest,free_time_level,free_time_lower_bound,free_time_number_days,free_time_type,service_type_id ,payment_type,eincoming,free_time_count_rule, is_haz,is_nor,is_soc,is_oog,named_account_id,tariff_type,tariff_ref_id, vp1_location_ids::text,vp2_location_ids::text,vp3_location_ids::text,vm1_location_ids::text,vm2_location_ids::text,vm3_location_ids::text,vo1_location_ids::text,vo2_location_ids::text,vo3_location_ids::text', 'All', 'level3', false);
