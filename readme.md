# Chicago Taxi Trip Data Pipeline

This project contains the dbt models for processing and analyzing Chicago taxi trip data. The data is organized into two layers: Silver and Gold.

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
