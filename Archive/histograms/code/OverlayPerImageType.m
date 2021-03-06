function OverlayPerImageType(Struct1,Struct2)
%this function takes two structures containing CT scan images and produces
%overlain histogram for all images of a particular type (Art, Pre, Ven,
%Del) from both structures.
%all image matrices are turned into one long vector, then combined with
%other images of the same type to make histograms
B=linspace(-1000, 1000, 1000); %create binedges for histograms

FN1=fieldnames(Struct1);
FN2=fieldnames(Struct2);
type={'Pre','Art','Ven','Del','Del-Art'};
freq=[];

for j=1:5 %for each type of picture
    figure; hold on;axis([-1100, 1000, 0, 2e6]);
    if j ==5 , axis([-1100, 1100, -1e6, 1e6]); end
    title({'Overlain Patient Histograms, ',type{j}})
    xlabel('Hounsfield Units (HU)');ylabel('Freq');
    plot([0 1],[0 1],'r');plot([0 1],[0 1],'b');legend('Responders','Non-Responders');
    for i=1:length(FN2) %for each patient in Structure 2, plot their histogram
        if j==5
            [del_freq(i+length(FN1),:),~]=histcounts(Struct2(4).(FN2{i}).Scans.img, B);
            [art_freq(i+length(FN1),:),~]=histcounts(Struct2(1).(FN2{i}).Scans.img, B);
            freq(i+length(FN1),:)=del_freq(i+length(FN1),:)-art_freq(i+length(FN1),:);
        else
            [freq(i+length(FN1),:),~]=histcounts(Struct2(j).(FN2{i}).Scans.img(Struct2(j).(FN2{i}).Scans.img>-1100),B);
        end
        plot(B(1:end-1),freq(i+length(FN1),:),'b')
    end 
    for i=1:length(FN1) %for each patient in Structure 1, plot their histogram
        if j==5
            [del_freq(i,:),~]=histcounts(Struct1(4).(FN1{i}).Scans.img, B);
            [art_freq(i,:),~]=histcounts(Struct1(1).(FN1{i}).Scans.img, B);
            freq(i,:)=del_freq(i,:)-art_freq(i,:);
        else
            [freq(i,:),~]=histcounts(Struct1(j).(FN1{i}).Scans.img(Struct1(j).(FN1{i}).Scans.img>-1100),B);
        end
        plot(B(1:end-1),freq(i,:),'r')
    end
    
    %save figures and histogram values
    saveas(gcf,strcat('../results/overlay_histograms/figures/',type{j},'_overlay_hist.jpg'));

    %save CSV of histogram values to be passed onto 
    csvwrite(strcat('../results/overlay_histograms/CSV/',type{j},'_overlay_hist_freq.csv'),[freq]');
    csvwrite(strcat('../results/overlay_histograms/CSV/',type{j},'_overlay_hist_bins.csv'),[B]');

end
   
end