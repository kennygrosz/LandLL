setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) #set directory to current directory
setwd("../../SuperMatrix/")
source("MatrixBuilder2.R")
setwd("../Features/Liver%20Features")

library(dplyr)

tVol = array(0,dim = dim(T_df)[1]) # initialize vector for liver volume
tCentX = array(0,dim = dim(T_df)[1]) # initialize vectors for liver position
tCentY = array(0,dim = dim(T_df)[1])
tCentZ = array(0,dim = dim(T_df)[1])

#find unique patients
Patients = unique(T_df$Patient)

# find size of livermask for each patient
index = 1
for (p in Patients) { 
  tempTV = dim(filter(T_df,Patient == p,TumorMask == 1))[1] # get number of voxels in liver
  numVoxels = dim(filter(T_df,Patient == p))[1] # total number of voxels in image
  tVol[index:(index+numVoxels-1)] <- tempTV # fill in data for appropriate patient - this is the part that doesn't work
  index = index + numVoxels # update index to move onto next patient
}


# find centroid of livermask for each patient
index = 1
for (p in Patients) { 
  numVoxels = dim(filter(T_df,Patient == p))[1] # get number of voxels in that patient imaage
  tempMat = filter(T_df,Patient ==p, TumorMask ==1) # get liver voxels
  xCent = mean(tempMat[["x_dim"]]) # calculate average positions in x,y,z
  yCent = mean(tempMat[["y_dim"]])
  zCent = mean(tempMat[["z_dim"]])
  tCentX[index:(index+numVoxels-1)] = xCent # fill in data for appropriate patient - this is the part that doesn't work
  tCentY[index:(index+numVoxels-1)] = yCent
  tCentZ[index:(index+numVoxels-1)] = zCent
  index = index + numVoxels # update index to move onto next patient
}


Tumor_df = data.frame(tVol,tCentX,tCentY,tCentZ) # create data frame for liver features
colnames(Liver_df)[1:4]= c("TumorVolume","TumorCentroidX","TumorCentroidY","TumorCentroidZ")

T_withTumor = cbind(T_df,Tumor_df)
head(T_withTumor)
