library(udunits2)
library(units)
library(rgdal)
library(raster)
library(rgeos)
library(gdistance)
library(doParallel) 

setwd('/data/home/mpx383/')
#setwd('Desktop/satelite_proj/')
#num.nodes =3

# import the shape files for the port and the world dowloaded from GDAM
ports = shapefile('WPI_Shapefile/WPI_Shapefile/WPI.shp')

# importing the cost raster of the land/sea
tif = 'final_world_land_sea_raster_ALL.tif'

#cost = raster(tif)
#e = extent(-50 , -40, -30, -20)
#cost = crop(cost, e)
#cost[cost<999] <- 1 # sea cost equal 1
#plot(cost)

## Produce transition matrices, and correct because 8 directions
#t1 = Sys.time()
#trCost <- transition(1/cost, mean, directions=8)
#trCost <- geoCorrection(trCost, type="c")
#Sys.time() - t1
#saveRDS(trCost, 'transition_layer.rds')
trCost <- readRDS('transition_layer.rds')
## 
e = extent(cost)
pts = crop(ports, e)
#plot(cost); plot(pts, add= TRUE)

## Display results
#plot(cost)
#plot(pts, add=TRUE, pch=20, col="blue")


distances = costDistance(trCost, pts)
saveRDS(distances, 'cost_distances.rds')
#distances = readRDS('cost_distances.rds')





