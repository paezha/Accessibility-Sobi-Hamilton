#pycno_interp.R
# This script demonstrates how to interpolate 
# attribute values from a polygon dataset tiling a 
# region of interest to different set of polygons 
# covering the same area.
# Written by A. Shortridge, 8/2019, 11/2019

library(sp)
library(pycno)
library(raster)
require(RColorBrewer)

## Load data
load("ingham_tracts_zips.RData")

## Plot data
plot(ingTracts, bor='blue', main="Ingham Co. Zips (red) and Tracts (blue)")
plot(ingZips, bor='red', add=TRUE)
plot(ingCo, lty=2, lwd=2, add=TRUE)
#dev.print(png, "ingham_geogs.png", height=400, width=500)

names(ingZips)

# Set up a color ramp
OR7 <- brewer.pal(7, "OrRd") # A sequential ramp, Orange to Red
OrRd <- colorRampPalette(OR7)

## The goal is to interpolate data in the Zip Codes polygons - the number 
## of kids eligible for reduced/free school lunch - to the census tracts.

## 1. Create the variable
ingZips$numEligible <- ingZips$FreeEligib + ingZips$ReducedEli
summary(ingZips$numEligible)
ingZips$numEligible[is.na(ingZips$numEligible)] <- 0   # Convert NAs to 0
spplot(ingZips, "numEligible", col.regions=OrRd(17), 
       main="Lunch Eligible by Zip Code")
#dev.print(png, "ingham_lunch_zip.png", height=400, width=500)

## 2. Crop tracts to the county extent.
ingTracts2 <- crop(ingTracts, ingCo)

## 3. Use Pycnophylactic Interpolation to convert.
# First, interpolate numEligible to a raster with 200x200 m cells
# Each cell is an estimated count of the number of eligible kids in that cell.
zipEligDens <- pycno(ingZips, ingZips$numEligible, celldim=200)
spplot(zipEligDens, col.regions=OrRd(17), main="Lunch Eligible (estimated counts)")

# Crop count surface to Ingham County only
denRast <- raster(zipEligDens)
zipEligDens2 <- as(crop(denRast, ingCo), 'SpatialPointsDataFrame')
spplot(zipEligDens2, col.regions=OrRd(17), main="Lunch Eligible (estimated counts)")

crosses <- gIntersects(ingCo, zipEligDens2, byid=TRUE)
zipEligDens3 <- zipEligDens2[crosses[,1],]
spplot(zipEligDens3, "dens", col.regions=OrRd(17), 
       main="Lunch Eligible (estimated counts)")
#dev.print(png, "ingham_lunch_raster_interp_raster.png", height=400, width=500)

# Plot different elements to make sure everything lines up
plot(crop(denRast, ingCo))
plot(zipEligDens3, add=TRUE)

plot(zipEligDens3)
plot(ingCo, bor='yellow', add=T)
plot(ingTracts2, bor='orange', add=T)

# Second, aggregate the densities from cells to the tract boundaries.
tractElig <- estimate.pycno(zipEligDens3, ingTracts2)

# Fix the vector tractElig so that NAs are accounted for
tractElig2 <- rep(NA, length(ingTracts2[,1]))
rn <- as.numeric(row.names(tractElig))
for(i in 1:length(tractElig)) {
  tractElig2[rn[i]] <- tractElig[i]
}
ingTracts2$tractElig <- tractElig2

## 4. Plot and summarize the result
spplot(ingTracts2, "tractElig", col.regions=OrRd(17), 
       main="Lunch Eligible (estimated counts) by Tract")
#dev.print(png, "ingham_lunch_raster_interp_tracts.png", height=400, width=500)

sum(ingTracts2$tractElig, na.rm=TRUE)
sum(zipEligDens3$dens)
