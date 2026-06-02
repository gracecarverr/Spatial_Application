# --- Pull data in ----------------------------------------------------------------------------

source("scripts/01_setup.R")
source("scripts/03_overlay_points.R")
source("scripts/04_overlay_buffer.R")
source("scripts/04_overlay_raster.R")

# --- Join ----------------------------------------------------------------------------

counties_combined <- counties_pip %>%
  st_drop_geometry() %>%
  select(GEOID, n_plants) %>%
  left_join(
    counties_near %>% st_drop_geometry() %>% select(GEOID, n_plants_within_25km),
    by = "GEOID"
  ) %>%
  left_join(
    counties_pm_exact %>% st_drop_geometry() %>% select(GEOID, mean_pm25_exact),
    by = "GEOID"
  )

counties_combined <- counties_combined %>%
  mutate(
    has_plants = n_plants > 0,
    has_nearby_plants = n_plants_within_25km > 0
  )

# --- Descriptive statistics ----------------------------------------------------------------------------


# Comparison 1: within-county
counties_combined %>%
  group_by(has_plants) %>%
  summarize(mean_pm25 = mean(mean_pm25_exact, na.rm = TRUE), n = n())

# Comparison 2: nearby (25 km buffer)
counties_combined %>%
  group_by(has_nearby_plants) %>%
  summarize(mean_pm25 = mean(mean_pm25_exact, na.rm = TRUE), n = n())

write.csv(
  counties_combined |>
    rename(`Has Plants` = has_plants) |>
    group_by(`Has Plants`) |>
    summarize(
      `Mean PM2.5 (µg/m³)` = round(mean(mean_pm25_exact, na.rm = TRUE), 2),
      `Number of Counties` = n()
    ),
  "output/comparison_within_county.csv",
  row.names = FALSE
)

write.csv(
  counties_combined |>
    rename(`Has Nearby Plants (25km)` = has_nearby_plants) |>
    group_by(`Has Nearby Plants (25km)`) |>
    summarize(
      `Mean PM2.5 (µg/m³)` = round(mean(mean_pm25_exact, na.rm = TRUE), 2),
      `Number of Counties` = n()
    ),
  "output/comparison_nearby_25km.csv",
  row.names = FALSE
)