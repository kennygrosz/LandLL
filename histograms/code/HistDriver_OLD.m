function HistDriver
close all hidden

% RID=[2,17,48,49,62,69,83,87,98,124];
RID=[2,17,48,49,62,83,87,98,124]; %file 69 isn't working for some reason.....

NID=[5,20,53,70,71,92,100,102,121,122];

[Full_R,Pre_R,Art_R,Ven_R,Del_R]=ConstructFileNames(RID,'Responders');
[Full_NR,Pre_NR,Art_NR,Ven_NR,Del_NR]=ConstructFileNames(NID,'Non_responders');

[Pre_R;Pre_NR]

createHistogram(ListVoxelVals([Pre_R;Pre_NR],'Pre Image Per-Petient Histograms'),'Pre Image Cumulative Histogram');

% createHistogram(ListVoxelVals(Art_R),'Art Image Histogram');
% createHistogram(ListVoxelVals(Ven_R),'Ven Image Histogram');
% createHistogram(ListVoxelVals(Del_R),'Del Image Histogram');
% createHistogram(ListVoxelVals(Full_R),'All Respondents Histogram');

end

function [full,Pre,Art,Ven,Del]=ConstructFileNames(IDs,FolderName)
%Given a vector of patient ID's and the name of the folder containing the
%patient ID folders, this function returns 5 vectors. Four are vectors of 
%Pre, Art, Ven, and Del filepaths that feed into the load_nii() function; 
%the last vector combines all of these paths into one long list for
%convenience

n=length(IDs);

%Initialize variables
Pre=cell(n,1);
Art=cell(n,1);
Ven=cell(n,1);
Del=cell(n,1);

%Create paths
for i=1:n
    Pre{i}=strcat('TrainingData-Unprocessed/',FolderName,'/',num2str(IDs(i)),'/Pre.nii.gz');
    Art{i}=strcat('TrainingData-Unprocessed/',FolderName,'/',num2str(IDs(i)),'/Art.nii.gz');
    Ven{i}=strcat('TrainingData-Unprocessed/',FolderName,'/',num2str(IDs(i)),'/Ven.nii.gz');
    Del{i}=strcat('TrainingData-Unprocessed/',FolderName,'/',num2str(IDs(i)),'/Del.nii.gz');
end
full= [Pre;Art;Ven;Del]; %concate
end

function y=ListVoxelVals(CellPath,Title)
%given a cell of Path Names too nii.gz files, pull out the matrix and add
%its values to a long list of values from the images in that path

n=length(CellPath);
y=[];
figure;hold on;xlabel('Hounsfield Units (HU)');ylabel('Frequency');title(num2str(Title))

for i = 1:n
   temp=load_nii(CellPath{i});
   new = reshape(temp.img,[],1);
   y=[y;new];
       
   %Also create superimposed histograms
   [h1,h2]=histcounts(temp.img(temp.img>-1100),250);
   plot(h2(1:end-1),h1);
end
end


function createHistogram(X,title1)
%this function creates a histogram from a matrix X representing a CT scan
%image

figure; hold on
histogram(X(X>-1200),500); %only plot values which are greater than -1200
xlabel('Hounsfield Units (HU)');ylabel('Frequency');title(num2str(title1))

end