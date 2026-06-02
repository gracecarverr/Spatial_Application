# ---- Setup --------------------------------------------------------------------------

source("scripts/01_setup.R")

# ---- Confirm we are in a projected CRS ---------------------

stopifnot(sf::st_is_longlat(plants) == FALSE)

# ---- Buffer the points ------------------------------------------------------

buffer_dist_m <- 25000 # 25 km

plants_buf <- st_buffer(plants, dist = buffer_dist_m)

# ---- Find counties intersecting any buffer ---------------------------------

counties_near <- counties |>
  mutate(
    n_plants_within_25km = lengths(st_intersects(geometry, plants_buf)),
    near_plants = n_plants_within_25km > 0
  )

# ---- Sanity check -----------------------------------------------------------

cat(
  "Counties with >=1 Plant within 25 km: ",
  sum(counties_near$near_plants), " of ", nrow(counties_near), "\n"
)

# ---- Plot -------------------------------------------------------------------

print(
  ggplot(counties_near) +
    geom_sf(aes(fill = near_plants), color = "white", linewidth = 0.1) +
    geom_sf(data = plants, color = "black", size = 0.4) +
    scale_fill_manual(
      name   = "Near Plants?",
      values = c(`TRUE` = "#E57200", `FALSE` = "#E5E5E5")
    ) +
    labs(title = "Counties within 25 km of any Plant") +
    theme_void()
)

# ---- Second buffer: 50 km -----------------------------------------------------------

buffer_dist_m <- 50000 # 50 km

plants_buf <- st_buffer(plants, dist = buffer_dist_m)

# ---- Find counties intersecting any buffer ---------------------------------

counties_near_50km <- counties |>
  mutate(
    n_plants_within_50km = lengths(st_intersects(geometry, plants_buf)),
    near_plants = n_plants_within_50km > 0
  )

# ---- Sanity check -----------------------------------------------------------

cat(
  "Counties with >=1 plant within 50 km: ",
  sum(counties_near_50km$near_plants), " of ", nrow(counties_near_50km), "\n"
)

# ---- Plot --------------------------------------------------------------------------

print(
  ggplot(counties_near_50km) +
    geom_sf(aes(fill = near_plants), color = "white", linewidth = 0.1) +
    geom_sf(data = plants, color = "black", size = 0.4) +
    scale_fill_manual(
      name   = "Near Plants?",
      values = c(`TRUE` = "#E57200", `FALSE` = "#E5E5E5")
    ) +
    labs(title = "Counties within 50 km of any plant") +
    theme_void()
)
