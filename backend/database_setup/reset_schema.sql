/*
* Project: Bangladesh Project Relay
* Project ID: bangladesh-project-relay
* File: reset_schema.sql
* Author: Ronan Wallace (https://github.com/ronanwa)
*
* Drops all RELAY MVP tables entirely (structure + data), so create_schema.sql
* can be re-run from scratch. Use this when the table structure itself
* has changed, not just the data — for clearing data only, use clear_sample_data.sql.
*
* Dropped in child-to-parent order, CASCADE also removes dependent
* indexes and foreign key constraints.
*
* After running this file, re-run create_schema.sql to recreate the tables.
*/

DROP TABLE IF EXISTS media_attachment CASCADE;
DROP TABLE IF EXISTS report CASCADE;
DROP TABLE IF EXISTS phone_call_record CASCADE;
DROP TABLE IF EXISTS community_member CASCADE;
