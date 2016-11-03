setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) #set directory to current directory
setwd("../../SuperMatrix/")
source("MatrixBuilder2.R")
setwd("../Features/Liver%20Features")

library(dplyr)

lVol = array(0,dim = dim(T_df)[1]) # initialize vector for liver volume
lCentX = array(0,dim = dim(T_df)[1]) # initialize vectors for liver position
lCentY = array(0,dim = dim(T_df)[1])
lCentZ = array(0,dim = dim(T_df)[1])

#find unique patients
Patients = unique(T_df$Patient)
Patients

# find size of livermask for each patient
index = 1
for (p in Patients) { 
  tempLV = dim(filter(T_df,Patient == p,LiverMask == 1))[1] # get number of voxels in liver
  numVoxels = dim(filter(T_df,Patient == p))[1] # total number of voxels in image
  index
  index+numVoxels-1
  lVol[index:(index+numVoxels-1)] <- tempLV # fill in data for appropriate patient - this is the part that doesn't work
  index = index + numVoxels # update index to move onto next patient
}
head(lVol)

# find centroid of livermask for each patient
index = 1
for (p in Patients) { 
  numVoxels = dim(filter(T_df,Patient == p))[1] # get number of voxels in that patient imaage
  tempMat = filter(T_df,Patient ==p, LiverMask ==1) # get liver voxels
  xCent = mean(tempMat[["x_dim"]]) # calculate average positions in x,y,z
  yCent = mean(tempMat[["y_dim"]])
  zCent = mean(tempMat[["z_dim"]])
  lCentX[index:(index+numVoxels-1)] = xCent # fill in data for appropriate patient - this is the part that doesn't work
  lCentY[index:(index+numVoxels-1)] = yCent
  lCentZ[index:(index+numVoxels-1)] = zCent
  index = index + numVoxels # update index to move onto next patient
}


Liver_df = data.frame(lVol,lCentX,lCentY,lCentZ) # create data frame for liver features
colnames(Liver_df)[1:4]= c("LiverVolume","LiverCentroidX","LiverCentroidY","LiverCentroidZ")




T_withLiver = cbind(T_df,Liver_df)
head(T_withLiver)
