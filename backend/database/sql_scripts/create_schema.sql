/*
* Project: Bangladesh Project Relay
* Project ID: bangladesh-project-relay
* File: create_schema.sql
* Author: Ronan Wallace (https://github.com/ronanwa)
*
* Database Schema for RELAY MVP
* Scope: community_member, phone_call_record, report, media_attachment (device, installation, sensor_reading deferred post-MVP)
* 
* Uses PostgreSQL (17) + PostGIS extension
* Locations use SRID 4326, which sets location values to WGS 84 GPS coordinate system
*
* Run once per instance, before this file:
* CREATE EXTENSION IF NOT EXISTS postgis;
*/

-- ============================================================
-- COMMUNITY_MEMBER TABLE
-- 
-- This contains information about the community member
-- ============================================================
CREATE TABLE community_member (
    community_member_id   SERIAL PRIMARY KEY,         -- randomly generated community member ID number (primary key)
    anonymous             BOOLEAN,                    -- optional anonymity; if yes, null all info columns
    name                  TEXT,                       -- name
    age                   INT,                        -- age
    gender                TEXT,                       -- gender
    phone_number          TEXT UNIQUE,                -- unique when present; NULLs allowed
    address               TEXT,                       -- qualitative address
    location              GEOGRAPHY(POINT, 4326)      -- location coordinate derived from phone location and/or manual input 
);

-- ============================================================
-- PHONE_CALL_RECORD TABLE
-- 
-- This contains the raw capture of an inbound IVR call, before cleaning/extraction.
-- ============================================================
CREATE TABLE phone_call_record (
    call_record_id       SERIAL PRIMARY KEY,                                    -- randomly generated record ID number (primary key)
    community_member_id  INT REFERENCES community_member(community_member_id),  -- associated community member (foreign key)
    timestamp            TIMESTAMPTZ NOT NULL,                                  -- timestamp of phone call
    location             GEOGRAPHY(POINT, 4326),                                -- location coordinate derived from phone location and/or manual input
    transcript           TEXT,                                                  -- transcript derived from audio capture
    url_audio            TEXT                                                   -- cloud storage pointer to raw audio file
);

-- ============================================================
-- REPORT TABLE
--
-- This contains information dervied from phone calls and mobile app submissions. This is the communal report in its cleaned and processed form.
-- ============================================================
CREATE TABLE report (
    report_id                SERIAL PRIMARY KEY,                                                    -- randomly generated report ID number (primary key)
    community_member_id      INT REFERENCES community_member(community_member_id),                  -- nullable: anonymous report (foreign key)
    call_record_id           INT UNIQUE REFERENCES phone_call_record(call_record_id),               -- nullable: optional 0..1 (not every report comes from a call; not every call yields a report)
    location                 GEOGRAPHY(POINT, 4326) NOT NULL,                                       -- location coordinate derived from phone location and/or manual input
    timestamp                TIMESTAMPTZ NOT NULL,                                                  -- timestamp at submission
    submission_type          TEXT CHECK (submission_type IN ('voice_call', 'mobile_app')),          -- submission derived from phone call or mobile app
    flood_depth              TEXT CHECK (flood_depth IN ('waist', 'knee', 'ankle', 'below_ankle')), -- reported flood depth
    food_available           BOOLEAN,                                                               -- food available?
    water_available          BOOLEAN,                                                               -- water available?
    electricity_available    BOOLEAN,                                                               -- electricity available?
    flood_water_rising_fast  BOOLEAN,                                                               -- flood water rising fast?
    home_damaged             BOOLEAN,                                                               -- home damaged?
    road_damaged             BOOLEAN,                                                               -- road damaged?
    family_member_sick       BOOLEAN,                                                               -- family member sick?
    family_member_injured    BOOLEAN,                                                               -- family member injured?
    family_member_missing    BOOLEAN,                                                               -- family member missing?
    flood_shelter_crowded    BOOLEAN,                                                               -- flood shelter crowded?
    daily_job_affected       BOOLEAN,                                                               -- daily job (income) affected?
    has_attachment           BOOLEAN                                                                -- are there attachments with this report?
);

-- ============================================================
-- MEDIA_ATTACHMENT TABLE
-- 
-- Photo / video / audio (voice note) a community member deliberately attaches as evidence.
-- Distinct from phone_call_record, which is the phone call capture itself.
-- ============================================================
CREATE TABLE media_attachment (
    media_id                 SERIAL PRIMARY KEY,                                    -- randomly generated media ID number (primary key)
    report_id                INT REFERENCES report(report_id),                      -- associated report ID (foreign key)
    community_member_id      INT REFERENCES community_member(community_member_id),  -- associated community member ID (foreign key)
    timestamp                TIMESTAMPTZ,                                           -- timestamp at submission (verify with media metadata?)
    location                 GEOGRAPHY(POINT, 4326),                                -- location coordinate derived from phone location and/or manual input
    type                     TEXT CHECK (type IN ('image', 'video', 'audio')),      -- media type
    which_report_attribute   TEXT,                                                  -- links to an attribute in REPORT table (e.g. 'home_damaged', 'flood_depth', ...)
    url_attachment           TEXT                                                   -- cloud storage pointer to media file
);

-- ============================================================
-- INDEXING
-- 
-- Indexing for quicker row lookups
-- ============================================================
-- create indexes for foreign keys
CREATE INDEX idx_report_community_member_id ON report (community_member_id);
CREATE INDEX idx_report_call_record_id ON report (call_record_id);
CREATE INDEX idx_media_attachment_report_id ON media_attachment (report_id);
CREATE INDEX idx_media_attachment_community_member_id ON media_attachment (community_member_id);
CREATE INDEX idx_phone_call_record_community_member_id ON phone_call_record (community_member_id);

-- create location indexes across all tables
CREATE INDEX idx_community_member_location ON community_member USING GIST (location);
CREATE INDEX idx_phone_call_record_location ON phone_call_record USING GIST (location);
CREATE INDEX idx_report_location ON report USING GIST (location);
CREATE INDEX idx_media_attachment_location ON media_attachment USING GIST (location);
