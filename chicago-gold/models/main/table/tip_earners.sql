WITH max_trip_date AS (
    SELECT
        MAX(CAST(trip_start_timestamp AS DATE)) AS max_date
    FROM 
        {{ source('silver', 'taxi_trip') }}
),

recent_trips AS (
    SELECT
        taxi_id,
        tips
    FROM 
        {{ source('silver', 'taxi_trip') }},
        max_trip_date
    WHERE
        CAST(trip_start_timestamp AS DATE) >= DATE_SUB(max_trip_date.max_date, INTERVAL 3 MONTH)
),
tip_earnings AS (
    SELECT
        taxi_id,
        SUM(tips) AS total_tips
    FROM 
        recent_trips
    GROUP BY
        taxi_id
)
SELECT
    taxi_id,
    total_tips
FROM
    tip_earnings
ORDER BY
    total_tips DESC
LIMIT 100