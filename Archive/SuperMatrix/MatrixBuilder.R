install.packages("oro.nifti")
library("oro.nifti")
setwd('C:\\Users\\lcadalzo\\Documents\\STAT405')


#pass patientNumber through in format '###' (ie '002' for patient 2), isResponder must pass through value 'Responders' or 'Non-Responders'
buildMatrix = function(patientNumber,isResponder){
  preFile = paste('C:\\Users\\lcadalzo\\Documents\\CAAM Senior Design\\Processed Niftis\\',isResponder,'\\Predict1',patientNumber,'\\Pre.nii.gz',sep="")
  preArray = readNIfTI(preFile)
  preVector = as.vector(preArray)
  
  artFile = paste('C:\\Users\\lcadalzo\\Documents\\CAAM Senior Design\\Processed Niftis\\',isResponder,'\\Predict1',patientNumber,'\\Art.nii.gz',sep="")
  artArray = readNIfTI(artFile)
  artVector = as.vector(artArray)
  
  delFile = paste('C:\\Users\\lcadalzo\\Documents\\CAAM Senior Design\\Processed Niftis\\',isResponder,'\\Predict1',patientNumber,'\\Del.nii.gz',sep="")
  delArray = readNIfTI(delFile)
  delVector = as.vector(delArray)
  
  venFile = paste('C:\\Users\\lcadalzo\\Documents\\CAAM Senior Design\\Processed Niftis\\',isResponder,'\\Predict1',patientNumber,'\\Ven.nii.gz',sep="")
  venArray = readNIfTI(venFile)
  venVector = as.vector(venArray)
  
  tumorMaskFile = paste('C:\\Users\\lcadalzo\\Documents\\CAAM Senior Design\\Processed Niftis\\',isResponder,'\\Predict1',patientNumber,'\\TumorMask.nii.gz',sep="")
  tumorMaskArray = readNIfTI(tumorMaskFile)
  tumorMaskVector = as.vector(tumorMaskArray)

  tumorTruthFile = paste('C:\\Users\\lcadalzo\\Documents\\CAAM Senior Design\\Processed Niftis\\',isResponder,'\\Predict1',patientNumber,'\\TumorTruth.nii.gz',sep="")  
  tumorTruthArray = readNIfTI(tumorTruthFile)
  tumorTruthVector = as.vector(tumorTruthArray)
  
  liverMaskFile = paste('C:\\Users\\lcadalzo\\Documents\\CAAM Senior Design\\Processed Niftis\\',isResponder,'\\Predict1',patientNumber,'\\LiverMask.nii.gz',sep="")
  liverMaskArray = readNIfTI(liverMaskFile)
  liverMaskVector = as.vector(liverMaskArray)
  
  allTruthFile = paste('C:\\Users\\lcadalzo\\Documents\\CAAM Senior Design\\Processed Niftis\\',isResponder,'\\Predict1',patientNumber,'\\AllTruth.nii.gz',sep="")
  allTruthArray = readNIfTI(allTruthFile)
  allTruthVector = as.vector(allTruthArray)
  
  roiFile = paste('C:\\Users\\lcadalzo\\Documents\\CAAM Senior Design\\Processed Niftis\\',isResponder,'\\Predict1',patientNumber,'\\Roi.nii.gz',sep="")
  roiArray = readNIfTI(roiFile)
  roiVector = as.vector(roiArray)
  
  patientMatrix=data.frame(preVector,artVector,delVector,venVector,tumorMaskVector,tumorTruthVector,liverMaskVector,allTruthVector,roiVector)
  return(patientMatrix)
}


pat17matrix = buildMatrix('017','Responders')

write.csv(x=pat17matrix,file='C:\\Users\\lcadalzo\\Documents\\CAAM Senior Design\\Processed Niftis\\Responders\\Predict1017\\matrixRows.csv')
length(unique(pat17matrix$artVector))




