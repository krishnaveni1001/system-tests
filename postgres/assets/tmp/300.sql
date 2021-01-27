-- Get the cs_commodity_commodity_id_seq up to the correct value after pulling data over from the remote database.
select setval('cs_commodity_commodity_id_seq', (select max(commodity_id) from cs_commodity));
