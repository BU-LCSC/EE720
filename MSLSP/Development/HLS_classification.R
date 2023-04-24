# Script to estimate classification model and map marsh 
# vegetation classes based on HLS iimagery and phenology.

setwd("/projectnb/nasa-marsh/MarshVegMapping")

# load libraries
library(terra)
library(ranger)

# set path for image data year and HLS tile for analysis
tile <- '15RXN'
year <- 2021
mPath <- '/projectnb/nasa-marsh/MarshVegMapping/HLS/MSLSP/Output/'

######### old stuff for reading in and merging training data and labels
# read veg labels for each training pixel from csv file
# cls.lidar <- read.csv("/projectnb/modislc/users/mkmoon/coastal/training/Marsh_Classes_stats.csv")[,4]
# cls.lidar <- read.csv("/projectnb/nasa-marsh/Marsh_Classes_stats.csv")[,4]
# read HLS data for points previously extracted
# hls <- read.csv("/projectnb/modislc/users/mkmoon/coastal/training/point_mslsp_15RXN_2020.csv")[,-1]
# merge into single data frame
# alldat <- cbind(cls.lidar,hls)
# add name for column with class labels
# colnames(alldat)[1] <- 'EE.Class'

# fix cases with mislabeled class labels
# alldat[cls.lidar=="TM","EE.Class"] <- "HM"
# alldat[cls.lidar=="UNK","EE.Class"] <- "HM"
# alldat[cls.lidar=="UM","EE.Class"] <- "HM"

# create list of MSLSP metrics
# hls.metrics <- colnames(hls)

# create data frame with HLS & Marsh Classes, excluding cases w/missing HLS data
# hls.cls <- na.omit(data.frame(alldat[,"EE.Class"],alldat[,hls.metrics]))
# colnames(hls.cls) <- c("EE.Class",hls.metrics)
# marsh.clss <- hls.cls[,"EE.Class"]
# hls.cls[,"EE.Class"] <- as.factor(hls.cls[,"EE.Class"]) 

alldat <- read.csv("TrainingData/MarshLabelData.csv")
# alldat <- read.csv("TrainingData/MarshLabelData.csv", check.names = F)

# convert veg class labels to factor
alldat[,"EE.Class"] <- as.factor(alldat[,"EE.Class"])

# create dataframe for RF model
hls.cls <- alldat[,c(4:68)]

# and, get rid of cases with missing data
hls.cls <- na.omit(hls.cls)

# Estimate RandomForest Model
vgRF <- ranger(EE.Class~.,
               data=hls.cls,
               num.trees=1000,
               importance='none')

# check out results
vgRF$prediction.error
vgRF$confusion.matrix

# now estimate with HLS metrics only
hls.cls <- alldat[,c(4,17:68)]
hls.cls <- na.omit(hls.cls)
# colnames(hls.cls)[2:53] <- mNames[c(2:11,27:68)]

# Estimate RandomForest Model
vgRF <- ranger(EE.Class~.,
               data=hls.cls,
               num.trees=1000,
               importance='none')

# check out results
vgRF$prediction.error
vgRF$confusion.matrix

### Now import HLS LSP and reflectance products  ###

# first create a raster with HLS data
mlsp   <- rast(paste0(mPath,tile,'/phenoMetrics/MSLSP_',tile,'_',year,'.nc'))

# names for the different raster layers included in rasters
mNames <- mlsp@ptr$names

# and layers that we will use in the analysis (correspond to mNames)
lyrs   <- c(2:11,27:68)
mNames[lyrs]

# Assign all values as a matrix  
dat <- matrix(NA,(nrow(mlsp)*ncol(mlsp)),length(lyrs))
for(i in 1:length(lyrs)){
  mr1 <- subset(mlsp,lyrs[i])
  dat[,i] <- values(mr1)
  print(i)
}

# Find pixels with non-NA values
cCase <- complete.cases(dat)
cCase <- which(cCase==1)

# subset dataframe to exclude NA's?
dDat <- dat[cCase,]
# colnames(dDat) <- hls.metrics
# colnames(dDat) <- mNames[lyrs]
colnames(dDat) <- colnames(alldat)[c(17:68)]

# fudge to fix issue with names in alldat
mNames[lyrs]

# Predict classes
pClass <- predict(vgRF,dDat)
rfPred <- pClass$predictions

# Set classes to map 
rVals <- matrix(NA,(nrow(mlsp)*ncol(mlsp)),1)
rVals[cCase,1] <- rfPred

imgBase <- subset(mlsp,1)
rfMap   <- setValues(imgBase,rVals)

# Plot
plot(rfMap, type="classes")

# writeRaster(rfMap,filename = '/projectnb/modislc/users/mkmoon/coastal/training/rf_map.tif')




