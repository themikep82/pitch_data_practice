WITH non_numeric_tokens_fixed AS (

    WITH quotes_fixed AS (
        SELECT
            REPLACE(
                TRIM(CHR(34) FROM raw_json::text),
            CHR(39), CHR(34)) AS quotes_fixed_json
        FROM raw_data.tracking)
        SELECT quotes_fixed_json
        FROM quotes_fixed)
SELECT 
    REPLACE(quotes_fixed_json, 'None', '-1')::json AS tracking_json
INTO staging_data.tracking
FROM non_numeric_tokens_fixed;

SELECT 
	TO_DATE(tracking_json->>'date', 'YYYY-MM-DD') AS _date,
	(tracking_json->>'game_pk')::INT AS game_pk,
	(tracking_json->>'pitchno')::INT AS pitchno,
	(tracking_json->>'pa_of_inning')::INT AS pa_of_inning,
	(tracking_json->>'pitch_of_pa')::INT AS pitch_of_pa,
	tracking_json->>'pitcher' AS pitcher,
	(tracking_json->>'pitcherid')::INT AS pitcherid,
	tracking_json->>'pitcherthrows' AS pitcher_throws,
	tracking_json->>'pitcherteam' AS pitcherteam,
	tracking_json->>'batter' AS batter,
	(tracking_json->>'batterid')::INT AS batterid,
	tracking_json->>'batterside' AS batterside,
	tracking_json->>'batterteam' AS batterteam,
	tracking_json->>'topbottom' AS topbottom,
	(tracking_json->>'outs')::INT AS outs,
	(tracking_json->>'balls')::INT AS balls,
	(tracking_json->>'strikes')::INT AS strikes,
	tracking_json->>'playresult' AS playresult,
	(tracking_json->>'relspeed')::FLOAT AS relspeed,
	(tracking_json->>'spinrate')::FLOAT AS spinrate,
	(tracking_json->>'relheight')::FLOAT AS relheight,
	(tracking_json->>'relside')::FLOAT AS relside,
	(tracking_json->>'extension')::FLOAT AS extension,
	(tracking_json->>'vertbreak')::FLOAT AS vertbreak,
	(tracking_json->>'inducedvertbreak')::FLOAT AS inducedvertbreak,
	(tracking_json->>'horzbreak')::FLOAT AS horzbreak
INTO core_data.tracking
FROM staging_data.tracking;