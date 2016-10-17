function GMM_driver
fit_individual_patient_histograms = 1;

type={'Pre','Art','Ven','Del','Del-Art'};
RID=[2,17,48,49,62,69,83,87,98,124]; 
NID=[5,20,53,70,71,92,100,102,121,122];


if fit_individual_patient_histograms ==1
    R_CSV=cell(length(RID),1); %initialize cell
    NR_CSV=cell(length(RID),1); %initialize cell
    
    %create cells of paths to each histogram
    for i=1:length(RID)
        R_CSV{i}=makefilename(type,RID(i));
    end
    for i=1:length(NID)
        NR_CSV{i}=makefilename(type,RID(i));
    end
    load(R_CSV{1}{1})
    
    %for each histogram:
    c=1;
    for i=1:length(R_CSV) %for each patient
        for j = 1:length(R_CSV{i}) %for each image type
            %load vectors
            A=load(R_CSV{i}{j});
            
            %split csv into frequency and bins
            bins=A(:,1);
            freq=A(:,2);
            
            %filter out the part of the histogram of interest
                %in our case, between -200 and 400 HU
            bins2=bins(find(bins>=-200 & bins <=400));
            freq2=freq(find(bins>=-200 & bins <=400));
            
            %run fitting model
            coeffs=GMM(bins2,freq2);
            
            %append new values to big matrices
            C(c,:)=coeffs;
            Patient(c,:)=RID(i);
            ImageType(c,:)=j;
            
            %update counter
            c=c+1;
        end
    end
    RIDMatrix=[Patient,ImageType,C]; %create matrix
    
    %save matrix as CSV
    csvwrite('../results/ResponderGMMPeaks2.csv',RIDMatrix)
    
    c=1;
    for i=1:length(NR_CSV) %for each patient
        for j = 1:length(NR_CSV{i}) %for each image type
            %load vectors
            A=load(NR_CSV{i}{j});
            
            %split csv into frequency and bins
            bins=A(:,1);
            freq=A(:,2);
            
            %filter out the part of the histogram of interest
            %in our case, between -200 and 400 HU
            bins2=bins(find(bins>=-200 & bins <=400));
            freq2=freq(find(bins>=-200 & bins <=400));
            
            %run fitting model
            coeffs=GMM(bins2,freq2);
            
            %append new values to big matrices
            C(c,:)=coeffs;
            Patient(c,:)=NID(i);
            ImageType(c,:)=j;
            
            %update counter
            c=c+1;
        end
    end
    NRIDMatrix=[Patient,ImageType,C]; %create matrix
    
    %save matrix as CSV
    csvwrite('../results/NonResponderGMMPeaks2.csv',NRIDMatrix)

end
   
end

function name=makefilename(type,ID)
%given a patient ID and the types of images, make a list of filenames for
%that patient, including navigating to the proper folder containing the
%CSVs for individual patients

name=cell(5,1);

for j = 1:length(type)
   name{j}= strcat('../../histograms/results/patient_histograms/CSV/','Patient',num2str(ID),'_',type{j},'_hist.csv');
end

end

% 1. Load CSV IN DRIVER

%call fit function 

    %2. split into bins and frequency

    %3. cut off bins that aren't within desired range (-200-400)

    %4. create and fit 4 cluster gaussian model

    %5. print and return relevant parameters
   
%BACK IN DRIVER
    %create a matrix with relevant parameters
   
    %print results in a formatted CSV file
    






