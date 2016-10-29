#------------------run these if it is your first time running the program------------------------
#install.packages("rstudioapi")
#install.packages("dplyr")
#install.packages("oro.nifti")



#--------INPUTS: FILL OUT INFO-----------------------------------------------#
#INPUTS!!!!!!!!!!!!1

#list of patients
Patients=c(2,5)

#list of responder status of patients
ResponderStatus=c("R","NR") #in the same order as the patients

#list of features given for each patient!!!
FeatureList=c("Pre","Art","Ven","Del","TumorMask","TumorTruth","LiverMask","LiverTruth")

#----------------------------------------------------------------------------#


#load libraries, initialize variables, etc
library("oro.nifti")
library(dplyr)
library(rstudioapi)

#set path to current working path
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) #set directory to current directory

T_df = NULL #reset whole data frame

#for each patient, create patient dataframe (P_df) and append to large data frame (T_df)
for (p in seq(1,length(Patients))){
  print(paste("Working on Patient",Patients[p]))
  P_df = NULL #reset temp data frame
  
  #initialize relevant values

  temp_FN=paste('../Raw_patient_data/',Patients[p],'/Art.nii.gz',sep="")
  temp=readNIfTI(temp_FN) #pull a random image (it has to exist-- Art will always exist)
  dims = dim(temp)
  nx=dims[1] #x dimension of image
  ny=dims[2] # size of y dimension of image
  nz=dims[3] # size of z dimension of image
  N=nx*ny*nz #total number of voxels
  
  #initialize matrices for voxel locations, convert each to a vector
  x_mat = array(seq(1,nx),dim = c(nx,ny,nz)) #crates 3D matrix with values corresponding to location in x dimension
  x_dim = as.vector(x_mat) #converts to a vector
  
  y_mat = array(seq(1,ny), dim = c(ny,nx,nz)) #create 3D matrix with y-values corresponding to location in x-dim
  y_mat2= aperm(y_mat,c(2,1,3)) #flip matrix to be desired dimensions
  y_dim=as.vector(y_mat2)
  
  z_mat= array(seq(1,nz), dim = c(nz,ny,nx))
  z_mat2=aperm(z_mat,c(3,2,1))
  z_dim=as.vector(z_mat2)
  
  #initialize columns for patient number and responder status
  PN = array(Patients[p],dim = N) #vector with patient number in each entry
  RS = array(ResponderStatus[p],N) #vector with responder statur (R or NR) in each entry-- CHARACTER DATA TYPE
  
  #create initial data frame
  P_df=data.frame(PN,RS,x_dim,y_dim,z_dim)
  colnames(P_df)[1:5]= c("Patient","Resp. Status","x_dim","y_dim","z_dim") #change column names
  
  head(P_df)
  
  #now, add columns per feature
  for (f in seq(1,length(FeatureList))){
    #Create filename
    FN=paste('../Raw_patient_data/',Patients[p],'/',FeatureList[f],'.nii.gz',sep="")
    
    #load image
    temp=readNIfTI(FN)
    
    #vectorize inputs
    temp_vec = as.vector(temp)
    
    #print status
    print(paste('loading and adding column',FeatureList[f],'for patient',Patients[p]))
    
    #add column to dataframe
    P_df[FeatureList[f]]=temp_vec
  }
head(P_df)  

#concatinate data frame to existing frame
if (p==1){
  T_df = P_df
}
else {
  T_df = rbind(T_df,P_df)

}
}


#test that T_df exists and test filtering with dplyr
head(T_df)
dim(T_df)

test=filter(T_df, Patient == 5, TumorMask == 1)

