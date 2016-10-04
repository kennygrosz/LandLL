function OverlayPerImageType(Struct1,Struct2)
%this function takes two structures containing CT scan images and produces
%overlain histogram for all images of a particular type (Art, Pre, Ven,
%Del) from both structures.
%all image matrices are turned into one long vector, then combined with
%other images of the same type to make histograms

FN1=fieldnames(Struct1);
FN2=fieldnames(Struct2);
type={'Art','Pre','Del','Ven','Del-Art'};

for j=1:4 %for each type of picture
    figure; hold on;axis([-1100, 1000, 0, 2e6]);
    title({'Overlain Patient Histograms, ',type{j}})
    xlabel('Hounsfield Units (HU)');ylabel('Freq');

    for i=1:length(FN1) %for each patient in Structure 1, plot their histogram
        temp=histogram(Struct(j).(FN1{i}).Scans.img);
        
    end
end




%STRUCTURE 1
for i=1:length(FN1) %for each patient in Structure 1
    Art=[Art;reshape(Struct1(1).(FN1{i}).Scans.img,[],1)];
    Pre=[Pre;reshape(Struct1(2).(FN1{i}).Scans.img,[],1)];
    Del=[Del;reshape(Struct1(3).(FN1{i}).Scans.img,[],1)];
    Ven=[Ven;reshape(Struct1(4).(FN1{i}).Scans.img,[],1)];
end
%STRUCTURE 2
for i=1:length(FN2) %for each patient in Structure 2
    Art=[Art;reshape(Struct2(1).(FN2{i}).Scans.img,[],1)];
    Pre=[Pre;reshape(Struct2(2).(FN2{i}).Scans.img,[],1)];
    Del=[Del;reshape(Struct2(3).(FN2{i}).Scans.img,[],1)];
    Ven=[Ven;reshape(Struct2(4).(FN2{i}).Scans.img,[],1)];
end


%crate figures and save images as well as CSV files

%ART
figure
gcf=histogram(Art); 
title('Art Cumulative Histogram');axis([-1100, 1000, 0, 2e7]);
xlabel('HU');ylabel('Freq');
saveas(gcf,strcat('../results/cumulative_histograms/figures/','Art_hist.jpg'));
csvwrite(strcat('../results/cumulative_histograms/CSV/','Art_hist.csv'),[gcf.BinEdges(1:end-1), gcf.Values]);

%PRE
figure
gcf=histogram(Pre); 
title('Pre Cumulative Histogram');axis([-1100, 1000, 0, 2e7]);
xlabel('HU');ylabel('Freq');
saveas(gcf,strcat('../results/cumulative_histograms/figures/','Pre_hist.jpg'));
csvwrite(strcat('../results/cumulative_histograms/CSV/','Pre_hist.csv'),[gcf.BinEdges(1:end-1), gcf.Values]);

%DEL
figure
gcf=histogram(Del); 
title('Del Cumulative Histogram');axis([-1100, 1000, 0, 2e7]);
xlabel('HU');ylabel('Freq');
saveas(gcf,strcat('../results/cumulative_histograms/figures/','Del_hist.jpg'));
csvwrite(strcat('../results/cumulative_histograms/CSV/','Del_hist.csv'),[gcf.BinEdges(1:end-1), gcf.Values]);

%VEN
figure
gcf=histogram(Ven); 
title('Ven Cumulative Histogram');axis([-1100, 1000, 0, 2e7]);
xlabel('HU');ylabel('Freq');
saveas(gcf,strcat('../results/cumulative_histograms/figures/','Ven_hist.jpg'));
csvwrite(strcat('../results/cumulative_histograms/CSV/','Ven_hist.csv'),[gcf.BinEdges(1:end-1), gcf.Values]);
