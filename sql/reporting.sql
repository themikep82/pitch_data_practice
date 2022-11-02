--Identify gaps in the at_bat_index in the pitches data
WITH at_bat_gaps AS (
    WITH at_bat_indexes AS (
        SELECT
            DISTINCT at_bat_index
        FROM core_data.pitches
        WHERE at_bat_index != 0
    ORDER BY at_bat_index)    
    SELECT
        at_bat_index,
        LEAD(at_bat_index) OVER (ORDER BY at_bat_index) AS next_at_bat
    FROM at_bat_indexes
)
SELECT
    at_bat_index + 1 AS ab_index_gap_start,
    next_at_bat - 1 AS ab_index_gap_end
INTO reporting.pitches_ab_index_gaps
FROM at_bat_gaps
WHERE next_at_bat != at_bat_index + 1;

--Identify gaps in the pitchno in the tracking data
WITH pitchno_gaps AS (

    SELECT
        pitchno,
        LEAD(pitchno) OVER (ORDER BY pitchno) AS next_pitchno
    FROM core_data.tracking 
)
SELECT
    pitchno + 1 AS pitchno_gap_start,
    next_pitchno - 1 AS pitchno_gap_end
INTO reporting.tracking_pitchno_gaps
FROM pitchno_gaps
WHERE next_pitchno != pitchno + 1;

--Some aggregates for pitchers using tracking data. Would be more useful with pitch classification (2-seam, 4-seam, slider, change, etc)
SELECT
    pitcher,
    COUNT(*) AS num_pitches,
    AVG(spinrate) AS average_spinrate,
    MAX(spinrate) AS max_spinrate
INTO reporting.spinrates
FROM core_data.tracking
GROUP BY pitcher
ORDER BY average_spinrate DESC;

--Pitch total aggregates appended to play by play data
WITH pitch_totals AS (
    SELECT
        game_pk,
        at_bat_index,
        COUNT(*) AS num_pitches
    FROM core_data.pitches
    GROUP BY game_pk, at_bat_index
)
SELECT 
    core_data.play_by_play.*,
    num_pitches
INTO reporting.play_by_play_with_pitch_totals
FROM core_data.play_by_play
LEFT JOIN pitch_totals
    ON core_data.play_by_play.game_pk = pitch_totals.game_pk
    AND core_data.play_by_play.at_bat_index = pitch_totals.at_bat_index;