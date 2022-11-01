WITH non_numeric_tokens_fixed AS (

    WITH quotes_fixed AS (
        SELECT
            REPLACE(
                TRIM(CHR(34) FROM raw_json::text),
            CHR(39), CHR(34)) AS quotes_fixed_json
        FROM raw_data.play_by_play)
        SELECT quotes_fixed_json
        FROM quotes_fixed)
        
SELECT 
    REPLACE(REPLACE(quotes_fixed_json, 'True', '1'), 'False', '0')::json AS pbp_json
INTO staging_data.play_by_play
FROM non_numeric_tokens_fixed;

SELECT
    (pbp_json->>'game_pk')::INT AS game_pk,
    (pbp_json->>'inning')::INT AS inning,
    CASE WHEN (pbp_json->>'top')::INT = 1
        THEN True
        ELSE False 
    END AS top,
    (pbp_json->>'at_bat_index')::INT AS at_bat_index,
    (pbp_json->>'batter_id')::INT AS batter_id,
    pbp_json->>'batter_side' AS batter_side,
    (pbp_json->>'pitcher_id')::INT AS pitcher_id,
    pbp_json->>'pitcher_throws' AS pitcher_throws,
    pbp_json->>'event_type' AS event_type,
    pbp_json->>'description' AS description
INTO core_data.play_by_play
FROM staging_data.play_by_play;
