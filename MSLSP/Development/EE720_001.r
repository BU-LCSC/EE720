#Load required libraries
library(sf)
library(terra)

library(rjson)


#############################################################################
# Inputs
############
# Tile 
tile <- '15RXN'

# json files
params <- fromJSON(file='/usr3/graduate/mkmoon/GitHub/EE720/MSLSP/MSLSP_Parameters.json')

# List of files
imgList <- list.files(paste0(params$SCC$dataDir,'HLS30/',tile,'/images'),pattern=glob2rx('*hdf'),full.names=T)

# Set base image
sds <- unlist(gdal_subdatasets(imgList[360]))
qaName  <-  sds[14]
baseImage  <-  rast(qaName) 

# Get raster info
baseImage

# Plot the raster
plot(baseImage)


#############################################################################
# Calculate VIs
############
# Get red and nir bands 
bRed <- rast(sds[4])
bNir <- rast(sds[9])

# Calculate VIs
ndvi <- (bNir - bRed) / (bNir + bRed)
evi2 <- 2.5*(bNir - bRed) / (bNir + 2.4*bRed + 1)

# Plot
par(mfrow=c(1,2))
plot(ndvi,type="interval", breaks=seq(0,1,0.2))
plot(evi2,type="interval", breaks=seq(0,1,0.2))


# #############################################################################
# # Get time series
# ############
# 
# # Get raster info
# numPix <- ncol(baseImage)*nrow(baseImage) # The total number of pixels
# imgNum <- setValues(baseImage,1:numPix) 
# numChunks <- params$SCC$numChunks
# chunk <- numPix%/%numChunks
# 
# ptShp <- vect(paste0('/projectnb/nasa-marsh/MSLSP/Shp/pt_',tile,'_01.shp'))
# ptShp <- project(ptShp,baseImage)
# pixNums <- as.numeric(extract(imgNum,ptShp)[,2])
#       
#       
# dev.off() # Clean plot window
# plot(ndvi,type="interval", breaks=seq(0,1,0.2))
# plot(ptShp,add=T)
# 
# 
# # Load chunk data 
# pixNum  <- pixNums[1]
# ckNum <- pixNum%/%chunk+1
# files <- list.files(path=paste0(params$SCC$workDir,tile,'/imageChunks/c',ckNum),pattern=glob2rx('*.Rds'),full.names=T)
# 
# dat <- matrix(NA,length(files),2)
# for(i in 1:length(files)){
#   dat[,1] <- substr(unlist(strsplit(files[i],'/'))[9],16,22)
#   dat[,2] <- readRDS(files[i])[pixNum%%chunk]
# }
# 
# plot(dat[,2])
