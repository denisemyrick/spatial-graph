# Set Up Access and Load Operations Data

## Introduction

You will create or inspect a Spatial Studio author account in Database Users. Then open the built-in Spatial Studio tool and load four small datasets for one operating region.

Estimated Time: 25 minutes

### Objectives

In this lab, you will:

- Create or inspect a `SPATIAL_AUTHOR` account with Database Users.
- Access Spatial Studio from Autonomous AI Database Serverless.
- Upload GeoJSON and address datasets to your database schema.
- Verify dataset keys, geometry columns, and timestamps.

## Task 1: Create or confirm the Spatial Studio user

1. If your instructor provided a `SPATIAL_AUTHOR` username, record it and proceed to Task 2. Do not create another user.

2. If you have `ADMIN` credentials, open **Database Actions** from the Autonomous AI Database and select **Database Users** in the Administration group.

3. Select **Create User**. Enter the username supplied by your instructor, set the password, and assign a quota on the `DATA` tablespace.

4. Open **Granted Roles**, grant `SPATIAL_AUTHOR`, and select **Create User**.

5. Ask the instructor or database administrator to confirm the documented privileges and proxy access for this user. Database Users cannot apply these one-time grants.

    A Spatial Studio author needs the `SPATIAL_AUTHOR` role, object privileges, and `CONNECT THROUGH "SPATIAL$PROXY_USER"`. Do not share the password in the project or workshop chat.

## Task 2: Access Spatial Studio

1. Sign in to Oracle Cloud and open the Autonomous AI Database Serverless instance supplied for this workshop.

2. Open **Tool configuration**, locate **Spatial Studio**, and copy its public access URL.

    You can also select **Database Actions**, then **View all database actions**, and **Spatial Studio** in the Development group.

3. Open Spatial Studio and sign in with the workshop database username and password.

4. Confirm that the application header identifies your database and that you can open the **Datasets** page.

    If you can view data but cannot create a dataset, ask the instructor to confirm that your user has the `SPATIAL_AUTHOR` role and quota on the `DATA` tablespace.

## Task 3: Upload service-center data

1. Download [service-centers.geojson](files/service-centers.geojson) and [service-center-addresses.csv](files/service-center-addresses.csv) from the workshop files.

2. In Spatial Studio, open **Datasets**, select **Create Dataset**, and then select **Local File**.

3. Upload `service-centers.geojson`, and then select **Create**.

4. Select your workshop connection in **Upload to connection**.

5. Set the destination dataset name to `SERVICE_CENTERS`, review the detected columns, and then select **Submit**.

6. Open the dataset properties and confirm that `CENTER_ID` is the key and that the GeoJSON geometry column contains points.

## Task 4: Upload the address, movement, and weather datasets

1. Upload `service-center-addresses.csv` through **Create Dataset** > **Local File**. Name it `SERVICE_CENTER_ADDRESSES`. Use `CENTER_ID` as the key. Retain the address fields as text.

2. Repeat the Local File upload for [field-asset-history.geojson](files/field-asset-history.geojson).

3. Name the dataset `FIELD_ASSET_HISTORY`, use `OBS_ID` as the key, and confirm that Spatial Studio imports `OBSERVED_AT` as a date or timestamp column.

4. Repeat the upload for [weather-observations.geojson](files/weather-observations.geojson).

5. Name the dataset `WEATHER_OBSERVATIONS`, use `OBS_ID` as the key, and confirm that `WIND_SPEED` is numeric.

6. Return to **Datasets** and verify that all four datasets appear without unresolved key or geometry warnings.

    If a warning appears, open it, go to the dataset columns, assign the stated key column, validate the key, and apply the change.

## Task 5: Check your work

1. Confirm that the Datasets page contains `SERVICE_CENTERS`, `SERVICE_CENTER_ADDRESSES`, `FIELD_ASSET_HISTORY`, and `WEATHER_OBSERVATIONS`.

2. Open each dataset and use its preview to confirm that the points fall in the northeastern United States.

3. Confirm that `FIELD_ASSET_HISTORY` contains repeated `ASSET_ID` values with different `OBSERVED_AT` timestamps.

You may now **proceed to the next lab**.

## Learn More

- [Access Spatial Studio](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adstu/access-spatial-studio.html)
- [Set Up Spatial Studio Users and Privileges](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adstu/set-spatial-studio-users-and-privileges.html)
- [Create a Dataset by Uploading a File](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adstu/create-dataset-uploading-file.html)

## Acknowledgements

- **Authors** - Oracle LiveLabs
- **Last Updated By/Date** - Oracle LiveLabs, July 2026
- **Source** - [Create a Dataset by Uploading a File](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adstu/create-dataset-uploading-file.html)
