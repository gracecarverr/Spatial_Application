# ---- Setup --------------------------------------------------------------------------

source("scripts/01_setup.R")

# ---- Exact extract ----------------------------------------------------------------

counties_pm_exact <- counties |>
  mutate(
    mean_pm25_exact = exact_extract(pm25, geometry,
      fun = "mean",
      progress = FALSE
    )
  )

p_pm25 <- ggplot(counties_pm_exact) +
  geom_sf(aes(fill = mean_pm25_exact), color = NA) +
  scale_fill_viridis_c(name = "PM2.5", option = "magma") +
  labs(title = "Mean PM2.5 by county") +
  theme_void()
print(p_pm25)
ggsave("output/mean_pm25.png", p_pm25, width = 8, height = 5)

# ---- Compute max PM2.5 per county ----------------------------------------------------------------

counties_max_pm_exact <- counties |>
  mutate(
    max_pm25_exact = exact_extract(pm25, geometry,
      fun = "max",
      progress = FALSE
    ),
    max_above_9 = max_pm25_exact > 9
  )

print(
  ggplot(counties_max_pm_exact) +
    geom_sf(aes(fill = max_pm25_exact), color = NA) +
    scale_fill_viridis_c(
      name = "PM2.5", option = "magma"
    ) +
    labs(title = "exact_extract (area-weighted)") +
    theme_void()
)
