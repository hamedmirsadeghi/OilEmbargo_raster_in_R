library(udunits2)
library(units)
library(rgdal)
library(raster)
library(rgeos)
library(gdistance)
library(doParallel) 

setwd('/data/home/mpx383/')
#setwd('Desktop/satelite_proj/')
num.nodes = 24

# import the shape files for the port and the world dowloaded from GDAM
ports = shapefile('WPI_Shapefile/WPI_Shapefile/WPI.shp')

# importing the cost raster of the land/sea
tif = 'final_world_land_sea_raster_ALL.tif'

cost = raster(tif)
cost[cost<999] <- 1 # sea cost equal 1
#res(cost)
#aggregate from 40x40 resolution to 120x120 (factor = 4)
cost.aggregate <- aggregate(cost, fact = 2, fun = max)
#res(cost.aggregate)
# e = extent(-50 , -40, -30, -20)
# cost_e = crop(cost, e)
# plot(cost_e)
# plot(ports, add = TRUE, pch=20, cex=1 )
# cost.aggregate_e = crop(cost.aggregate,e)
# plot(cost.aggregate_e)
# plot(ports, add = TRUE, pch=20, cex=1, col = 'blue' )

## Produce transition matrices, and correct because 8 directions
t1 = Sys.time()
trCost <- transition(1/cost.aggregate, mean, directions=8)
trCost <- geoCorrection(trCost, type="c")
Sys.time() - t1
saveRDS(trCost, 'transition_layer.rds')