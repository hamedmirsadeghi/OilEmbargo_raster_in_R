library(udunits2)
library(units)
library(rgdal)
library(raster)
library(rgeos)
library(sf)
library(doParallel)

#setting directories
setwd('/data/home/mpx383/')
#setwd('Desktop/satelite_proj/')
raster.dir = 'country_rasterizer/'
#shape.dir = 'countries_shapefile/'

#setting number of cores for paralle processing
no_cores <- 6 


# import the shape files for the port and the world dowloaded from GDAM
countries = ( read.csv(file = 'countries.csv', header = TRUE, stringsAsFactors=F ) )
is = c(42, 243, 187,105)
country.code = countries[[1]][is]



###
myCluster <- makeCluster(no_cores) # why "FORK"?
registerDoParallel(myCluster)

t1 = Sys.time()

r <- foreach(i = 1:length(country.code), .combine='+', .packages = 'raster', 
             .inorder = FALSE) %dopar% {
  raster( paste0(raster.dir,country.code[i],'_raster.tif') )
}

Sys.time() - t1
stopCluster(myCluster)
rr = r+ raster( 'final_world_land_sea_raster.tif')
#plot(r)

####### saving the final world raster file with sea pixels = 0 and land =1000
writeRaster(rr, filename = "final_world_land_sea_raster_plus3countries.tif",overwrite=TRUE)










