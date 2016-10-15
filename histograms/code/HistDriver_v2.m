function HistDriver_v2
close all hidden

%PICK WHICH SCRIPTS TO RUN BY SETTING IT EQUAL TO 1
Individual_Patient_Histograms=1;
Cumulative_Hist_Per_Phase=0;
Overlay_Hist_Per_Image_Type=0;
Create_img_CSVs=0; %creates single-column CSV's for each img type (~20 GB of data)

%load structures with all patient data
load('../../../nonRespondersStruct.mat')
load('../../../respondersStruct.mat')

% Create Histograms for Individual Patients
if Individual_Patient_Histograms==1
    HistPerPatient(respondersStruct);
    HistPerPatient(nonRespondersStruct);
end

%Create cumulative Histograms for each type of image (Art, Del, etc.)
if Cumulative_Hist_Per_Phase==1
    HistPerImageType(respondersStruct,nonRespondersStruct);
end

%Overlay histograms for each patient for each type of image (Art, Del,
%etc.)
if Overlay_Hist_Per_Image_Type==1
   OverlayPerImageType(respondersStruct,nonRespondersStruct);
end

%Create CSV's for eac image as one column of voxel values
if Create_img_CSVs==1
   create_img_CSV(respondersStruct);
   create_img_CSV(nonRespondersStruct);
end

end

