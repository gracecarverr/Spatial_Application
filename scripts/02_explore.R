# ---- Setup --------------------------------------------------------------------------

source("scripts/01_setup.R")

# ---- Counties: polygon layer ---------------------------------------------------------

print(counties)
cat("\nColumns:\n")
print(names(counties))
cat("\nNumber of counties:", nrow(counties), "\n")
cat("CRS (EPSG):", st_crs(counties)$epsg, "\n")

counties |>
    st_drop_geometry() |>
    head()

# ---- Plants: point layer ------------------------------------------------------

print(plants)
cat("\nNumber of Plants:", nrow(plants), "\n")

# ---- PM25: raster ----------------------------------------------------------

print(pm25) 
cat("\nSummary of PM2.5 cell values:\n")
print(summary(values(pm25))) # max 43 - seems like a lot?

# ---- Data-quality checks -----------------------------------------------------

# 1. Is join key unique? 

cat(
    "counties: GEOID unique?     ", !any(duplicated(counties$GEOID)),
    " (", length(unique(counties$GEOID)), "distinct of", nrow(counties), ")\n"
)
cat(
    "plants:      plant_id unique?     ", !any(duplicated(plants$plant_d)),
    " (", length(unique(plants$plant_d)), "distinct of", nrow(plants), ")\n"
)

# 2. Duplicate records vs. duplicate geometries. 

cat("\nplants: fully duplicated rows: ", sum(duplicated(st_drop_geometry(plants))), "\n")
cat(
    "plants: duplicated coordinates: ", sum(duplicated(st_coordinates(plants))),
    " (co-located facilities)\n"
)

# 3. Missing values, by column. 

cat("\nNAs per column (plants):\n")
print(colSums(is.na(st_drop_geometry(plants))))

# 4. Dead columns. 

cat("\nDistinct values per plants column:\n")
print(sapply(st_drop_geometry(plants), function(x) length(unique(x))))

# 5. Geometry health. 

cat(
    "\nempty geometries -- counties:", sum(st_is_empty(counties)),
    " plants:", sum(st_is_empty(plants)), "\n"
)
cat(
    "invalid geometries -- counties:", sum(!st_is_valid(counties)),
    " plants:", sum(!st_is_valid(plants)), "\n"
)

# ---- Plot them together -------------------------------------------------------

plot(st_geometry(counties),
    border = "grey40",
    main = "Counties + Plants (do the points land on the map?)"
)
plot(st_geometry(plants), add = TRUE, pch = 20, cex = 0.5, col = "#E57200")

# PM2.5 on its own:
plot(pm25, main = "PM2.5 surface (ug/m^3)")

# Distribution of PM2.5 values:

hist(values(pm25),
    breaks = 40, col = "#00B3BE", border = "white",
    main = "Distribution of PM2.5 cell values", xlab = "PM2.5 (ug/m^3)"
) 

# Distribution looks a little wacky, large spike at 0 and tail out to 40. Could
# be due to cells over the ocean. 