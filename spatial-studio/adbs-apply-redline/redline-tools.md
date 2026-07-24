# Annotate the Map with Redline Tools

## Introduction

Redline tools capture operational context directly on a map without changing the source dataset. You will mark an advisory area, label an access route, edit the shapes, and export the drawing set as GeoJSON.

Estimated Time: 20 minutes

### Objectives

In this lab, you will:

- Draw point, line, and polygon Redline features.
- Edit, duplicate, resize, rotate, and annotate features.
- Save the project and export Redline features as GeoJSON.

## Task 1: Draw an advisory area and access route

1. Open `Regional Operations Explorer` and zoom to the service centers.

2. Select **Actions** on the map toolbar, and then select **Redline**.

3. Select **Draw Polygon** and draw an advisory area that intersects several weather observations.

4. Select **Draw Line** and trace a possible access route from the nearest service center into the advisory area.

5. Select **Draw Point** and mark a proposed staging location.

6. Change the drawing color and add a rectangle or circle to mark another area of interest.

## Task 2: Edit the Redline features

1. Select **Select Feature**, and then select the advisory polygon.

2. Move one or more vertices to refine its boundary.

3. Open **Edit Feature Properties**, enter `Weather advisory area` as the description, and adjust its fill or outline.

4. Duplicate the staging point and move the copy to a second location.

5. Select the rectangle, press `ctrl + r`, and drag to rotate it.

6. Press `ctrl + s` and drag to resize the selected rectangle.

7. Press `esc` to clear the selection.

## Task 3: Save and export the drawing set

1. Select **Save** to persist the Redline drawings with the project.

2. In the Redline toolbar, select **Export Features**.

3. Select **Download as GeoJson** and save the file as `regional-operations-redline.geojson`.

4. Note that the export preserves feature IDs and descriptions but does not preserve custom colors or outline widths.

5. Toggle Redline visibility off and on to confirm that the saved features remain available.

## Task 4: Check your work

1. Close and reopen the project.

2. Open the Redline tool again so the saved shapes become editable.

3. Select the advisory polygon and confirm that its description is present.

You may now **proceed to the next lab**.

## Learn More

- [Use the Redline Map Tool](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adstu/style-map-layer1.html)

## Acknowledgements

- **Authors** - Oracle LiveLabs
- **Last Updated By/Date** - Oracle LiveLabs, July 2026
- **Source** - [Style a Map Layer](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adstu/style-map-layer1.html)
