# Explore Historical Asset Movement

## Introduction

Time reveals how field assets moved through the operating area. You will configure field-asset history as a non-live moving-object dataset and inspect its timeline before moving into aggregation and analysis.

Estimated Time: 25 minutes

### Objectives

In this lab, you will:

- Enable historical spatiotemporal behavior for moving assets.
- Add asset history to the project timeline.

## Task 1: Configure the historical asset dataset

1. Save and close the active project, and then open **Datasets**.

2. Open the properties for `FIELD_ASSET_HISTORY`.

3. Locate the spatiotemporal settings and switch **Enable Spatiotemporal** on.

4. Select `OBSERVED_AT` as the timestamp column.

5. Switch **Data is live** off and switch **Moving objects** on.

6. Select `ASSET_ID` as the entity identifier and use seconds as the time unit.

7. Apply the changes.

    The workshop timestamps use UTC. Spatial Studio expects UTC or GMT timestamps for moving-object visualization.

## Task 2: Add asset history to the timeline

1. Reopen `Regional Operations Explorer` and make `FIELD_ASSET_HISTORY` visible on the map.

2. Open the map settings, switch **Show timeline** on, and apply the setting.

3. Open the primary `FIELD_ASSET_HISTORY` layer menu and select **Add to Timeline**.

4. Select **Zoom Timeline to Range** for the layer.

5. Use the timeline controls to play forward, pause, and move to a different time.

6. Confirm that the asset locations change across the historical range and that a trail layer appears for each moving object.

7. Open the primary `FIELD_ASSET_HISTORY` layer menu and select **Configure Animation**. Set the trail length to `20` minutes, apply the setting, and play the timeline again.

    This is historic data. The Cesium timeline loops over its timestamp range; do not configure automatic dataset refresh for this layer.

## Task 3: Check your work

1. Confirm that the project contains a temporal asset layer and that the timeline is visible.

2. Confirm that the timeline covers the full timestamp range in `FIELD_ASSET_HISTORY`.

You may now **proceed to the next lab**.

## Learn More

- [Enable Spatiotemporal for a Dataset](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adstu/enable-spatiotemporal-dataset.html)
- [Visualize Spatiotemporal Datasets](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adstu/visualize-spatiotemporal-datasets.html)

## Acknowledgements

- **Authors** - Oracle LiveLabs
- **Last Updated By/Date** - Oracle LiveLabs, July 2026
- **Source** - [Using Oracle Spatial Studio on Autonomous AI Database, Release 26.1](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adstu/get-started-using-spatial-studio1.html)
