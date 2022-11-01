WITH non_numeric_tokens_fixed AS (

    WITH quotes_fixed AS (
        SELECT
            REPLACE(
                TRIM(CHR(34) FROM raw_json::text),
            CHR(39), CHR(34)) AS quotes_fixed_json
        FROM raw_data.pitches)
        SELECT quotes_fixed_json
        FROM quotes_fixed)
SELECT 
    REPLACE(
        REPLACE(
            REPLACE(quotes_fixed_json, 'True', '1'),
                'False', '0'),
                'None', '0')::json AS pitches_json
INTO staging_data.pitches
FROM non_numeric_tokens_fixed;

SELECT
    (pitches_json->>'game_pk')::INT AS game_pk,
    (pitches_json->>'at_bat_index')::INT AS at_bat_index,
    (pitches_json->>'pitch_number')::INT AS pitch_number_pa,
    (pitches_json->>'batter_id')::INT AS batter_id,
    pitches_json->>'batter_side' AS batter_side,
    (pitches_json->>'pitcher_id')::INT AS pitcher_id,
    pitches_json->>'pitcher_throws' AS pitcher_throws,
    (pitches_json->>'terminating')::INT AS terminating,
    pitches_json->>'play_type' AS play_type,
    pitches_json->>'pre_balls' AS pre_balls,
    (pitches_json->>'pre_strikes')::INT AS pre_strikes,
    (pitches_json->>'pre_outs')::INT AS pre_outs,
    (pitches_json->>'post_outs')::INT AS post_outs,
    (pitches_json->>'post_vscore')::INT AS post_vscore,
    (pitches_json->>'post_hscore')::INT AS post_hscore,
    pitches_json->>'call_desc' AS call_description
INTO core_data.pitches
FROM staging_data.pitches;