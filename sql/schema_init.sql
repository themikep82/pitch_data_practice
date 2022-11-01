DROP SCHEMA raw_data CASCADE;

DROP SCHEMA staging_data CASCADE;

DROP SCHEMA core_data CASCADE;

DROP SCHEMA reporting CASCADE;

CREATE SCHEMA IF NOT EXISTS raw_data;

CREATE TABLE IF NOT EXISTS raw_data.play_by_play
(
    raw_json TEXT
);

CREATE TABLE IF NOT EXISTS raw_data.pitches
(
    raw_json TEXT
);

CREATE TABLE IF NOT EXISTS raw_data.tracking
(
    raw_json TEXT
);

CREATE SCHEMA IF NOT EXISTS staging_data;

CREATE SCHEMA IF NOT EXISTS core_data;

CREATE SCHEMA IF NOT EXISTS reporting;
