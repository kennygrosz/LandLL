setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) #set directory to current directory
setwd("../../SuperMatrix/")
source("MatrixBuilder2.R")
setwd("../Features/Tumor Features")

library(dplyr)

T_LT = cbind(T_df,Liver_df,Tumor_df)
centXDiff = array(0,dim = dim(T_LT)[1]) # initialize vectors for liver position
centYDiff = array(0,dim = dim(T_LT)[1])
centZDiff = array(0,dim = dim(T_LT)[1])

index = 1
for (p in Patients) { 
  numVoxels = dim(filter(T_df,Patient == p))[1] # total number of voxels in image
  
  xDiff = lCentX[index] - tCentX[index]
  yDiff = lCentY[index] - tCentY[index]
  zDiff = lCentZ[index] - tCentZ[index]
  
  centXDiff[index:(index+numVoxels-1)] <- xDiff # fill in data for appropriate patient - this is the part that doesn't work
  centYDiff[index:(index+numVoxels-1)] <- yDiff
  centZDiff[index:(index+numVoxels-1)] <- zDiff
  
  index = index + numVoxels # update index to move onto next patient
}

diffData = data.frame(centXDiff,centYDiff,centZDiff)
T_LT = cbind(T_LT,diffData)
colnames(T_LT)[18:24]= c("TumorVolume","TumorCentroidX","TumorCentroidY","TumorCentroidZ","CentroidDiffX","CentroidDiffY","CentroidDiffZ")

