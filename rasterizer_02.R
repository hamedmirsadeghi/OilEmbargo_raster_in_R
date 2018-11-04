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
shape.dir = 'countries_shapefile/'

#setting number of cores for paralle processing
no_cores <- 24 


# import the shape files for the port and the world dowloaded from GDAM
countries = ( read.csv(file = 'countries.csv', header = TRUE, stringsAsFactors=F ) )
#ports = shapefile('WPI_Shapefile/WPI_Shapefile/WPI.shp')

# importing the tif satelite image downloaded from https://ngdc.noaa.gov/eog/dmsp/downloadV4composites.html
tif = 'F182013.v4/F182013.v4c_web.avg_vis.tif'
f18 = raster(tif)

### Function to download shape files 
country.code = countries[[1]]

#xad.shape = shapefile(  paste0(shape.dir, 'gadm36_XAD_0.shp')  ) 

#sum = rasterize(xad.shape, f18 ,progress='text', field = 0,background = 0)

# calculating the rasters of each country and summing them
#t1 = Sys.time()
#l = list()
#for (i in 2:3 ) {
#  shape = shapefile( paste0(shape.dir,'gadm36_', country.code[i],
#                            "_0.shp") )
#  l[[i-1]] =rasterize(shape, f18 ,progress='text',field = 1000,
#                    background = 0, overwrite=TRUE,
#                    filename = paste0(raster.dir,country.code[i],"_raster.tif"))
#}
#s = calc(l, sum)
#Sys.time() - t1


#plot(sum)

myCluster <- makeCluster(no_cores) # why "FORK"?
registerDoParallel(myCluster)

t1 = Sys.time()
is = c(1,15)
r <- foreach(i = 1:length(country.code), .combine='+', .packages = 'raster', 
             .inorder = FALSE) %dopar% {
  rasterize( x = shapefile( paste0(shape.dir,'gadm36_', country.code[i],
                                  "_0.shp") ) ,
            f18 , progress='text', 
            field = 1000, background = 0 , overwrite=TRUE,
            filename = paste0(raster.dir,country.code[i],"_raster.tif"))
}

Sys.time() - t1
stopCluster(myCluster)
#plot(r)

####### saving the final world raster file with sea pixels = 0 and land =1000
writeRaster(r, filename = "final_world_land_sea_raster_2.tif")










