# ---- Set working directory ------------------------------------------------------------

setwd("~/Downloads/spatial-application")

# ---- Install necessary packages -------------------------------------------------------

library(sf)
library(terra)
library(exactextractr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(units)

# ---- File paths -----------------------------------------------------------------------

counties_file <- ("/Users/grace/Downloads/spatial-application/data/us_counties.shp")
plants_file <- ("/Users/grace/Downloads/spatial-application/data/us_powerplants.shp")
pm25_file <- ("/Users/grace/Downloads/spatial-application/data/us_pm25.tif")

# ---- Common CRS ----------------------------------------------------------------------

target_crs <- 5070

# ---- Load and reproject -------------------------------------------------------------

counties <- st_read(counties_file, quiet = TRUE) %>%
    st_transform(target_crs) %>% 
    st_make_valid()

plants <- st_read(plants_file, quiet = TRUE) %>%
    st_transform(target_crs)

pm25 <- rast(pm25_file)
if (is.na(crs(pm25)) || crs(pm25) == "") {
    crs(pm25) <- "EPSG:4326"
}

pm25 <- terra::project(pm25, paste0("EPSG:", target_crs))

# ---- Sanity checks ----------------------------------------------------------------

stopifnot(st_crs(counties) == st_crs(plants))
stopifnot(st_crs(counties)$epsg == target_crs)

cat("Setup complete.\n")
cat(" counties: ", nrow(counties), "polygons,  CRS =", st_crs(counties)$epsg, "\n")
cat(" plants:      ", nrow(plants), "points,    CRS =", st_crs(plants)$epsg, "\n")
cat(
  " pm25:     ", ncol(pm25), "x", nrow(pm25), "raster, CRS =",
  crs(pm25, describe = TRUE)$code, "\n"
)
