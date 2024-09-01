WITH daily_work_hours AS (
    SELECT
        taxi_id,
        DATE(trip_start_timestamp) AS work_date,
        SUM(TIMESTAMP_DIFF(trip_end_timestamp, trip_start_timestamp, SECOND)) / 3600.0 AS daily_hours
    FROM
        {{ source('silver', 'taxi_trip') }}
    GROUP BY
        taxi_id,
        DATE(trip_start_timestamp)
)
SELECT
    taxi_id,
    SUM(daily_hours) AS total_work_hours
FROM
    daily_work_hours
GROUP BY
    taxi_id
ORDER BY
    total_work_hours DESC
LIMIT 100
