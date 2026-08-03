/*
* Project: Bangladesh Project Relay
* Project ID: bangladesh-project-relay
* File: add_sample_data.sql
* Author: Ronan Wallace (https://github.com/ronanwa)
*
* Sample / Pseudo Data for RELAY MVP
* Scope: community_member, phone_call_record, report, media_attachment
*
* Populates staging tables with 20 community members, 10 phone call records,
* 20 reports, and 10 media attachments for testing
*
* IMPORTANT: this script matches rows by phone_number rather than hardcoded
* community_member_id values, so it works correctly regardless of the actual
* auto-generated IDs (safe to re-run after clear_sample_data.sql, safe even
* if the sequence isn't at 1). Anonymous community members are given a
* temporary placeholder phone_number purely so this script can link their
* rows; it is set back to NULL at the very end.
*
* NOTE: report.has_attachment (boolean) is left NULL by this script —
* it isn't set to TRUE for the 10 reports that do get an attachment below.
* Worth deciding whether to populate it here or leave it to the application
* layer to set when an attachment is actually uploaded.
*/

-- ============================================================
-- COMMUNITY_MEMBER (20 rows)
-- Anonymous rows get a temporary placeholder phone_number (+8800000000xx)
-- so later inserts can link to them; nulled out at the end of this script.
-- ============================================================
INSERT INTO community_member (anonymous, name, age, gender, phone_number, address, location) VALUES
(FALSE, 'Abdul Karim',      45, 'male',   '+8801711000001', 'Mirpur, Dhaka',        ST_MakePoint(90.3654, 23.8223)::geography),
(FALSE, 'Fatima Begum',     38, 'female', '+8801711000002', 'Mohammadpur, Dhaka',   ST_MakePoint(90.3589, 23.7663)::geography),
(FALSE, 'Rashed Hasan',     29, 'male',   '+8801711000003', 'Sylhet Sadar',         ST_MakePoint(91.8687, 24.8949)::geography),
(TRUE,  NULL,               NULL, NULL,   '+8800000000004', NULL,                   ST_MakePoint(90.4203, 23.7808)::geography),
(FALSE, 'Nasrin Akter',     52, 'female', '+8801711000005', 'Khulna Sadar',         ST_MakePoint(89.5644, 22.8456)::geography),
(FALSE, 'Jamal Uddin',      61, 'male',   '+8801711000006', 'Rangpur Sadar',        ST_MakePoint(89.2752, 25.7439)::geography),
(TRUE,  NULL,               NULL, NULL,   '+8800000000007', NULL,                   ST_MakePoint(90.4125, 23.8103)::geography),
(FALSE, 'Shirin Sultana',   34, 'female', '+8801711000008', 'Barisal Sadar',        ST_MakePoint(90.3535, 22.7010)::geography),
(FALSE, 'Mahbub Alam',      41, 'male',   '+8801711000009', 'Gazipur Sadar',        ST_MakePoint(90.4203, 23.9999)::geography),
(FALSE, 'Ruma Chowdhury',   27, 'female', '+8801711000010', 'Chattogram Sadar',     ST_MakePoint(91.8317, 22.3569)::geography),
(FALSE, 'Sohel Rana',       33, 'male',   '+8801711000011', 'Dhaka North',          ST_MakePoint(90.4074, 23.7925)::geography),
(TRUE,  NULL,               NULL, NULL,   '+8800000000012', NULL,                   ST_MakePoint(90.3773, 23.7461)::geography),
(FALSE, 'Amena Khatun',     58, 'female', '+8801711000013', 'Kurigram Sadar',       ST_MakePoint(89.6362, 25.8054)::geography),
(FALSE, 'Habibur Rahman',   47, 'male',   '+8801711000014', 'Jamalpur Sadar',       ST_MakePoint(89.9370, 24.9375)::geography),
(FALSE, 'Taslima Nasrin',   31, 'female', '+8801711000015', 'Faridpur Sadar',       ST_MakePoint(89.8429, 23.6070)::geography),
(FALSE, 'Iqbal Hossain',    39, 'male',   '+8801711000016', 'Bogura Sadar',         ST_MakePoint(89.3776, 24.8465)::geography),
(TRUE,  NULL,               NULL, NULL,   '+8800000000017', NULL,                   ST_MakePoint(90.3990, 23.8759)::geography),
(FALSE, 'Momtaz Begum',     44, 'female', '+8801711000018', 'Netrokona Sadar',      ST_MakePoint(90.7280, 24.8824)::geography),
(FALSE, 'Zahid Hasan',      26, 'male',   '+8801711000019', 'Tangail Sadar',        ST_MakePoint(89.9167, 24.2513)::geography),
(FALSE, 'Salma Islam',      36, 'female', '+8801711000020', 'Comilla Sadar',        ST_MakePoint(91.1809, 23.4607)::geography);

-- ============================================================
-- PHONE_CALL_RECORD (10 rows)
-- Linked to community members via phone_number match, not hardcoded ID.
-- ============================================================
INSERT INTO phone_call_record (community_member_id, timestamp, location, transcript, url_audio)
SELECT cm.community_member_id, v.ts, v.loc, v.transcript, v.url_audio
FROM (VALUES
    ('+8801711000001', '2026-07-20T08:15:00Z'::timestamptz, ST_MakePoint(90.3654, 23.8223)::geography, 'Water is knee deep near my home, rising slowly.', 'gs://relay-media/calls/call_001.mp3'),
    ('+8801711000002', '2026-07-20T09:02:00Z'::timestamptz, ST_MakePoint(90.3589, 23.7663)::geography, 'Road is flooded, cannot reach the market.', 'gs://relay-media/calls/call_002.mp3'),
    ('+8801711000003', '2026-07-20T09:40:00Z'::timestamptz, ST_MakePoint(91.8687, 24.8949)::geography, 'Water is at waist level, need help immediately.', 'gs://relay-media/calls/call_003.mp3'),
    ('+8801711000005', '2026-07-20T10:05:00Z'::timestamptz, ST_MakePoint(89.5644, 22.8456)::geography, 'No electricity since last night, water below ankle.', 'gs://relay-media/calls/call_005.mp3'),
    ('+8801711000006', '2026-07-20T10:30:00Z'::timestamptz, ST_MakePoint(89.2752, 25.7439)::geography, 'Shelter is overcrowded, need more supplies.', 'gs://relay-media/calls/call_006.mp3'),
    ('+8801711000008', '2026-07-20T11:12:00Z'::timestamptz, ST_MakePoint(90.3535, 22.7010)::geography, 'One family member is sick, water still rising.', 'gs://relay-media/calls/call_008.mp3'),
    ('+8801711000009', '2026-07-20T11:45:00Z'::timestamptz, ST_MakePoint(90.4203, 23.9999)::geography, 'House is damaged, roof leaking badly.', 'gs://relay-media/calls/call_009.mp3'),
    ('+8801711000010', '2026-07-20T12:20:00Z'::timestamptz, ST_MakePoint(91.8317, 22.3569)::geography, 'Road destroyed, no access to nearby town.', 'gs://relay-media/calls/call_010.mp3'),
    ('+8801711000013', '2026-07-20T13:00:00Z'::timestamptz, ST_MakePoint(89.6362, 25.8054)::geography, 'Water below ankle, but rising quickly this hour.', 'gs://relay-media/calls/call_013.mp3'),
    ('+8801711000016', '2026-07-20T13:35:00Z'::timestamptz, ST_MakePoint(89.3776, 24.8465)::geography, 'Family member missing since this morning.', 'gs://relay-media/calls/call_016.mp3')
) AS v(phone_number, ts, loc, transcript, url_audio)
JOIN community_member cm ON cm.phone_number = v.phone_number;

-- ============================================================
-- REPORT (20 rows)
-- Linked via phone_number for community_member_id; call_record_id pulled
-- from phone_call_record via that same community member (LEFT JOIN so
-- mobile_app rows with no call correctly get a NULL call_record_id).
-- ============================================================
INSERT INTO report (community_member_id, call_record_id, location, timestamp, submission_type, flood_depth,
                     food_available, water_available, electricity_available, flood_water_rising_fast,
                     home_damaged, road_damaged, family_member_sick, family_member_injured,
                     family_member_missing, flood_shelter_crowded, daily_job_affected)
SELECT cm.community_member_id, pcr.call_record_id, v.loc, v.ts, v.submission_type, v.flood_depth,
       v.food_available, v.water_available, v.electricity_available, v.flood_water_rising_fast,
       v.home_damaged, v.road_damaged, v.family_member_sick, v.family_member_injured,
       v.family_member_missing, v.flood_shelter_crowded, v.daily_job_affected
FROM (VALUES
    ('+8801711000001', '2026-07-20T08:16:00Z'::timestamptz, ST_MakePoint(90.3654, 23.8223)::geography, 'voice_call',  'knee',        TRUE,  TRUE,  TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE),
    ('+8801711000002', '2026-07-20T09:03:00Z'::timestamptz, ST_MakePoint(90.3589, 23.7663)::geography, 'voice_call',  'below_ankle', TRUE,  TRUE,  TRUE,  FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE),
    ('+8801711000003', '2026-07-20T09:41:00Z'::timestamptz, ST_MakePoint(91.8687, 24.8949)::geography, 'voice_call',  'waist',       FALSE, FALSE, FALSE, TRUE,  TRUE,  TRUE,  TRUE,  FALSE, FALSE, TRUE,  TRUE),
    ('+8800000000004', '2026-07-20T09:55:00Z'::timestamptz, ST_MakePoint(90.4203, 23.7808)::geography, 'mobile_app',  'ankle',       TRUE,  FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE),
    ('+8801711000005', '2026-07-20T10:06:00Z'::timestamptz, ST_MakePoint(89.5644, 22.8456)::geography, 'voice_call',  'below_ankle', TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
    ('+8801711000006', '2026-07-20T10:31:00Z'::timestamptz, ST_MakePoint(89.2752, 25.7439)::geography, 'voice_call',  'knee',        FALSE, TRUE,  TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  TRUE),
    ('+8800000000007', '2026-07-20T10:50:00Z'::timestamptz, ST_MakePoint(90.4125, 23.8103)::geography, 'mobile_app',  'ankle',       TRUE,  TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
    ('+8801711000008', '2026-07-20T11:13:00Z'::timestamptz, ST_MakePoint(90.3535, 22.7010)::geography, 'voice_call',  'knee',        FALSE, FALSE, TRUE,  TRUE,  FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, TRUE),
    ('+8801711000009', '2026-07-20T11:46:00Z'::timestamptz, ST_MakePoint(90.4203, 23.9999)::geography, 'voice_call',  'waist',       TRUE,  FALSE, FALSE, TRUE,  TRUE,  TRUE,  FALSE, TRUE,  FALSE, FALSE, TRUE),
    ('+8801711000010', '2026-07-20T12:21:00Z'::timestamptz, ST_MakePoint(91.8317, 22.3569)::geography, 'voice_call',  'below_ankle', TRUE,  TRUE,  TRUE,  FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE),
    ('+8801711000011', '2026-07-20T12:40:00Z'::timestamptz, ST_MakePoint(90.4074, 23.7925)::geography, 'mobile_app',  'ankle',       TRUE,  TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
    ('+8800000000012', '2026-07-20T12:55:00Z'::timestamptz, ST_MakePoint(90.3773, 23.7461)::geography, 'mobile_app',  'knee',        FALSE, FALSE, TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  TRUE),
    ('+8801711000013', '2026-07-20T13:01:00Z'::timestamptz, ST_MakePoint(89.6362, 25.8054)::geography, 'voice_call',  'below_ankle', TRUE,  TRUE,  TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
    ('+8801711000014', '2026-07-20T13:15:00Z'::timestamptz, ST_MakePoint(89.9370, 24.9375)::geography, 'mobile_app',  'ankle',       TRUE,  TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE),
    ('+8801711000015', '2026-07-20T13:22:00Z'::timestamptz, ST_MakePoint(89.8429, 23.6070)::geography, 'mobile_app',  'knee',        FALSE, TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  TRUE),
    ('+8801711000016', '2026-07-20T13:36:00Z'::timestamptz, ST_MakePoint(89.3776, 24.8465)::geography, 'voice_call',  'ankle',       TRUE,  FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, TRUE),
    ('+8800000000017', '2026-07-20T13:50:00Z'::timestamptz, ST_MakePoint(90.3990, 23.8759)::geography, 'mobile_app',  'below_ankle', TRUE,  TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
    ('+8801711000018', '2026-07-20T14:05:00Z'::timestamptz, ST_MakePoint(90.7280, 24.8824)::geography, 'mobile_app',  'waist',       FALSE, FALSE, FALSE, TRUE,  TRUE,  TRUE,  FALSE, TRUE,  FALSE, TRUE,  TRUE),
    ('+8801711000019', '2026-07-20T14:20:00Z'::timestamptz, ST_MakePoint(89.9167, 24.2513)::geography, 'mobile_app',  'knee',        TRUE,  TRUE,  TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE),
    ('+8801711000020', '2026-07-20T14:35:00Z'::timestamptz, ST_MakePoint(91.1809, 23.4607)::geography, 'mobile_app',  'ankle',       TRUE,  TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)
) AS v(phone_number, ts, loc, submission_type, flood_depth, food_available, water_available,
       electricity_available, flood_water_rising_fast, home_damaged, road_damaged,
       family_member_sick, family_member_injured, family_member_missing,
       flood_shelter_crowded, daily_job_affected)
JOIN community_member cm ON cm.phone_number = v.phone_number
LEFT JOIN phone_call_record pcr ON pcr.community_member_id = cm.community_member_id;

-- ============================================================
-- MEDIA_ATTACHMENT (10 rows)
-- Linked via phone_number for community_member_id, then to that member's report.
-- ============================================================
INSERT INTO media_attachment (report_id, community_member_id, timestamp, location, type, which_report_attribute, url_attachment)
SELECT r.report_id, cm.community_member_id, v.ts, v.loc, v.type, v.which_attr, v.url
FROM (VALUES
    ('+8801711000002', '2026-07-20T09:04:00Z'::timestamptz, ST_MakePoint(90.3589, 23.7663)::geography, 'image', 'road_damaged',           'gs://relay-media/attachments/att_002.jpg'),
    ('+8801711000003', '2026-07-20T09:42:00Z'::timestamptz, ST_MakePoint(91.8687, 24.8949)::geography, 'image', 'flood_depth',            'gs://relay-media/attachments/att_003.jpg'),
    ('+8800000000004', '2026-07-20T09:56:00Z'::timestamptz, ST_MakePoint(90.4203, 23.7808)::geography, 'image', 'home_damaged',           'gs://relay-media/attachments/att_004.jpg'),
    ('+8801711000006', '2026-07-20T10:32:00Z'::timestamptz, ST_MakePoint(89.2752, 25.7439)::geography, 'video', 'flood_shelter_crowded',  'gs://relay-media/attachments/att_006.mp4'),
    ('+8801711000009', '2026-07-20T11:47:00Z'::timestamptz, ST_MakePoint(90.4203, 23.9999)::geography, 'image', 'home_damaged',           'gs://relay-media/attachments/att_009.jpg'),
    ('+8801711000011', '2026-07-20T12:41:00Z'::timestamptz, ST_MakePoint(90.4074, 23.7925)::geography, 'image', 'flood_depth',            'gs://relay-media/attachments/att_011.jpg'),
    ('+8800000000012', '2026-07-20T12:56:00Z'::timestamptz, ST_MakePoint(90.3773, 23.7461)::geography, 'audio', 'flood_water_rising_fast','gs://relay-media/attachments/att_012.mp3'),
    ('+8801711000015', '2026-07-20T13:23:00Z'::timestamptz, ST_MakePoint(89.8429, 23.6070)::geography, 'image', 'water_available',        'gs://relay-media/attachments/att_015.jpg'),
    ('+8801711000018', '2026-07-20T14:06:00Z'::timestamptz, ST_MakePoint(90.7280, 24.8824)::geography, 'video', 'road_damaged',           'gs://relay-media/attachments/att_018.mp4'),
    ('+8801711000019', '2026-07-20T14:21:00Z'::timestamptz, ST_MakePoint(89.9167, 24.2513)::geography, 'image', 'flood_depth',            'gs://relay-media/attachments/att_019.jpg')
) AS v(phone_number, ts, loc, type, which_attr, url)
JOIN community_member cm ON cm.phone_number = v.phone_number
JOIN report r ON r.community_member_id = cm.community_member_id;

-- ============================================================
-- Restore true anonymity: clear the temporary placeholder
-- phone numbers now that all linked rows are correctly in place.
-- ============================================================
UPDATE community_member SET phone_number = NULL WHERE anonymous = TRUE;
