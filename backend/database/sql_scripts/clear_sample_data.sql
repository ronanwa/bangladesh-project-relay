/*
* Project: Bangladesh Project Relay
* Project ID: bangladesh-project-relay
* File: clear_sample_data.sql
* Author: Ronan Wallace (https://github.com/ronanwa)
* 
* RELAY: Clear all data from MVP tables
* Deletes rows in child-to-parent order to respect foreign keys.
* Resets identity sequences so new inserts start back at 1.
*/

TRUNCATE TABLE
    media_attachment,
    report,
    phone_call_record,
    community_member
RESTART IDENTITY CASCADE;
