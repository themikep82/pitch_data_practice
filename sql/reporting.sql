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