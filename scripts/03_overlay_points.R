# ---- Set working directory ----------------------------------------------------------

setwd("~/Downloads/spatial-application")

# ---- The join -------------------------------------------------------------------------

plants_with_county <- st_join(plants, counties, join = st_within)

# ---- Aggregate to county level ----------------------------------------------

plants_counts <- plants_with_county |>
  st_drop_geometry() |>
  count(GEOID, name = "n_plants")

counties_pip <- counties |>
  left_join(plants_counts, by = "GEOID") |>
  mutate(n_plants = tidyr::replace_na(n_plants, 0L))

  # ---- Sanity check -----------------------------------------------------------

cat("Total Plants:        ", nrow(plants), "\n")
cat("Sum of plants-per-county:", sum(counties_pip$n_plants), "\n")

# ---- Plot -------------------------------------------------------------------

print(
  ggplot(counties_pip) +
    geom_sf(aes(fill = n_plants), color = "white", linewidth = 0.1) +
    scale_fill_viridis_c(name = "Plants", option = "magma", trans = "sqrt") +
    labs(title = "Plants per U.S. County") +
    theme_void() +
    theme(legend.position = "right")
)

counties_density_pip <- counties_pip |>
  mutate(
    area_km2 = as.numeric(units::set_units(st_area(geometry), "km^2")),
    plant_density = n_plants / area_km2 * 100
  )

print(
  ggplot(counties_density_pip) +
    geom_sf(aes(fill = plant_density), color = "white", linewidth = 0.1) +
    scale_fill_viridis_c(name = "Plants per 100km2", option = "magma", trans = "sqrt") +
    labs(title = "Plants per 100km2") +
    theme_void() +
    theme(legend.position = "right")
)

