# Chicago Taxi Trip Data Pipeline

This project contains the dbt models for processing and analyzing Chicago taxi trip data. The data is organized into two layers: Silver and Gold.

### Ingestion Process

- **Public Dataset to BigQuery**: The raw taxi trip data is ingested from a public dataset into BigQuery. This ingestion is scheduled to run daily using a BigQuery scheduled query. The scheduled query should merge new data into the existing dataset and appends new data to ensure that the most up-to-date information is available for downstream processing.

#### Screenshot of the schedule query
![Screenshot 2024-09-01 at 11 56 53 PM](https://github.com/user-attachments/assets/4fc1652e-e179-48a7-abb3-2237b99dd207)


```bash
MERGE raw.taxi_trip AS target
USING `bigquery-public-data.chicago_taxi_trips.taxi_trips` AS source
ON target.unique_key = source.unique_key
WHEN MATCHED THEN
  UPDATE SET
    target.taxi_id = source.taxi_id
WHEN NOT MATCHED THEN
  INSERT (unique_key, taxi_id, trip_start_timestamp, trip_end_timestamp, trip_seconds, trip_miles, pickup_census_tract, dropoff_census_tract, pickup_community_area, dropoff_community_area, fare, tips, tolls, extras, trip_total, payment_type, company, pickup_latitude, pickup_longitude, pickup_location, dropoff_latitude, dropoff_longitude, dropoff_location)
  VALUES (source.unique_key, source.taxi_id, source.trip_start_timestamp, source.trip_end_timestamp, source.trip_seconds, source.trip_miles, source.pickup_census_tract, source.dropoff_census_tract, source.pickup_community_area, source.dropoff_community_area, source.fare, source.tips, source.tolls, source.extras, source.trip_total, source.payment_type, source.company, source.pickup_latitude, source.pickup_longitude, source.pickup_location, source.dropoff_latitude, source.dropoff_longitude, source.dropoff_location);
```

## Overview of Layers

### Silver Layer
The Silver layer primarily focuses on transforming raw data into clean and structured formats, which are then used as the basis for further aggregation and analysis in the Gold layer.

### Gold Layer
The Gold layer focuses on advanced aggregations, metrics, and business logic that provide insights into taxi operations, such as top earners, overworked drivers, and other key metrics.

## How to Run dbt

### Setup your environment
- Ensure that you have Python and dbt installed.
- Activate your Python virtual environment if using one.

```bash
source dbt-env/bin/activate

### To run silver layer
dbt run --profiles-dir ~/.dbt --profile my-bigquery-db --target silver
dbt run --profiles-dir ~/.dbt --profile my-bigquery-db --target silver -m <model_name>


### To run silver layer
dbt run --profiles-dir ~/.dbt --profile my-bigquery-db --target gold
dbt run --profiles-dir ~/.dbt --profile my-bigquery-db --target gold -m <model_name>
```

## Silver Layer

### taxi_trip
- Contains detailed information about taxi trips, including timestamps, locations, fare details, and distances.
- This table is used as a foundation for further aggregations and transformations in the Gold layer.

## Gold Layer

### tip_earners
- Identifies the top 100 taxi drivers who earn the most tips over the last three months.
- Based on the taxi_trip data from the Silver layer.

### over_workers
- Identifies the top 100 taxi drivers who work the most hours without taking significant breaks.
- Based on the taxi_trip data from the Silver layer.

## Screenshots of Data Structure in GCP
![Screenshot 2024-09-01 at 11 53 32 PM](https://github.com/user-attachments/assets/93ac6735-19e7-4f4d-95a6-ef48ed655133)

## CI/CD
This was implemented using GitHub Actions. There are two workflows:

1. **dbt_run_on_push**:
   - **Trigger**: This workflow is triggered whenever there is a push to the `main` branch.
   - **Purpose**: It automatically runs the DBT models for both the silver and gold datasets, ensuring that the latest changes are always applied to your data models as soon as they are pushed to the repository.
   - **Steps**:
     - Checks out the repository.
     - Sets up Python.
     - Installs dependencies including `dbt-core` and `dbt-bigquery`.
     - Configures DBT profiles for both silver and gold datasets.
     - Runs DBT models for the silver and gold datasets.

2. **dbt_run_daily_schedule**:
   - **Trigger**: This workflow is scheduled to run daily at midnight UTC.
   - **Purpose**: It ensures that the DBT models for both the silver and gold datasets are updated daily, even if no new changes are pushed to the repository.


