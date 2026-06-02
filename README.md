# Spatial Application — Day 6

Power plants, proximity, and PM2.5 across US counties.

## Data

- **us_counties.shp** — county polygons for the contiguous US
- **us_powerplants.shp** — electricity-generating facilities from EIA-860 (≥1 MW)
- **us_pm25.tif** — annual mean PM2.5 surface (~5 km resolution)

## Scripts

1. `01_setup.R` — loads packages, reads data, reprojects to EPSG:5070
2. `02_explore.R` — data exploration and quality checks
3. `03_overlay_points.R` — point-in-polygon: plants per county
4. `04_overlay_buffer.R` — buffer overlay: plants within 25 km
5. `04_overlay_raster.R` — raster extraction: mean PM2.5 per county
6. `05_comparison.R` — combines results and compares groups

## Output

- `comparison_within_county.csv` — mean PM2.5 by plant presence
- `comparison_nearby_25km.csv` — mean PM2.5 by nearby plant presence
