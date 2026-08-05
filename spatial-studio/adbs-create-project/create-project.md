# Geocode Service Centers and Build a Base Map

## Introduction

Geocoding turns address details into a geometry that you can map and analyze. You will geocode the supplied service-center addresses, create a project, and build a map and table that answer basic operations questions.

Estimated Time: 25 minutes

### Objectives

In this lab, you will:

- Geocode an address dataset and verify its result.
- Create and save a Spatial Studio project.
- Add operational datasets to a map.
- Style point layers and inspect records in a table.

## Task 1: Geocode the service-center addresses

1. Open **Datasets**, open the menu for `SERVICE_CENTER_ADDRESSES`, select **Prepare**, and then select **Geocode Addresses**.

  ![Geocode addresses](./images/geocode-addresses.png "Geocode-addresses")

2. On the **Setup** tab, keep **Single column address** off. Map `ADDRESS`, `CITY`, `STATE`, `POSTAL_CODE`, and `COUNTRY` to the matching address components.

  ![Setup geocode](./images/geocode-setup.png "Geocode-addresses")

3. Switch **Save coordinates in columns** on. Enter `LATITUDE` and `LONGITUDE` as the output column names, then select **Apply**.

  ![Setup geocode](./images/geocode-setup-1.png "Geocode-addresses")

4. Open **Jobs** and wait for the geocoding job to finish. If a row fails, inspect its address fields before rerunning the job.

  ![Jobs page](./images/spatial-jobs.png "Jobs page")

5. Open the dataset properties and confirm that `GC_GEOMETRY` is present as an `SDO_GEOMETRY` column.

  ![Dataset properties](./images/dataset-properties.png "Dataset properties")

## Task 2: Create the project

1. Open **Projects** and select **Create Project**.

  ![Create project](./images/create-project.png "Create project")

2. Click **Actions**, and then **Save project as...**. Enter `Regional Operations Explorer` as the project name and enter `Movement, weather, wind, and response coverage` as the description.

  ![Save project as](./images/save-project-as.png "Save project as")

3. Select **Save**, and then save the project.

  ![Save as](./images/save-as.png "Save as")

## Task 3: Add the uploaded datasets

1. In the active project, open the **Data** tab and select **Add Dataset**.

  ![Add dataset](./images/add-dataset.png "Add dataset")

2. Select `SERVICE_CENTER_ADDRESSES`, `SERVICE_CENTERS`, `FIELD_ASSET_HISTORY`, and `WEATHER_OBSERVATIONS`, and then select **OK**.

  ![Add datasets](./images/add-datasets.png "Add datasets")

3. From **Data**, drag `SERVICE_CENTER_ADDRESSES` onto the map.

  ![Add service center addresses to map](./images/service-center-address.png "Add service center addresses to map")

4. Drag `WEATHER_OBSERVATIONS` onto the same map.

  ![Add weather observations to map](./images/weather-observations.png "Add weather observations to map")

5. Drag `FIELD_ASSET_HISTORY` onto the map.

  ![Add field asset history to map](./images/field-asset-history.png "Add field asset history to map")

    Spatial Studio renders later layers above earlier layers. Use the Layers list to change visibility while you inspect each dataset.

      ![Move layers](./images/move-layers.png "Move layers")

## Task 4: Style and inspect the layers

1. Open the `SERVICE_CENTER_ADDRESSES` layer menu, select **Settings**, and choose a distinct point color and a larger radius.

  ![Open settings](./images/service-center-addresses-settings.png "Open settings")
  ![Change formatting](./images/service-center-addresses-layer.png "Change formatting")

2. Open the `WEATHER_OBSERVATIONS` layer settings and apply data-driven color using `WIND_SPEED`.

  ![Open settings](./images/weather-obs-settings.png "Open settings")
  ![Choose based on data](./images/weather-obs-based-on-data.png "Choose based on data")
  ![Select wind speed](./images/weather-obs-wind-speed.png "Select wind speed")

3. Open **Visualizations** and drag **Table** next to the map.

  ![Add table](./images/add-table.png "Add table")

4. Add `SERVICE_CENTER_ADDRESSES` to the table and select a row.

  ![Add service center addresses](./images/add-serv-cent-add.png "Add service center addresses")

5. Confirm that Spatial Studio highlights the matching map feature or lets you locate it from the selected table record.

  ![Highlight map](./images/highlight-table.png "Highlight map")

6. Save the project.

## Learn More

- [Typical Workflow for Visualizing Spatial Data](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adstu/typical-workflow-visualizing-spatial-data.html)
- [Geocode a Dataset](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adstu/geocode-dataset.html)
- [Using Oracle Spatial Studio on Autonomous AI Database, Release 26.1](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adstu/get-started-using-spatial-studio1.html)

## Acknowledgements

* **Authors** - Oracle LiveLabs
* **Last Updated By/Date** - Oracle LiveLabs, July 2026
* **Source** - [Typical Workflow for Visualizing Spatial Data](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adstu/typical-workflow-visualizing-spatial-data.html)
