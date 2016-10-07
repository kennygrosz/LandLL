function HistPerPatient(Struct)
%given a structure of patients, create subplots of histograms per image
%per patient

FieldNames=fieldnames(Struct);
type={'Pre','Art','Ven','Del','Del-Art'};
B=linspace(-1000, 1000, 1000);

for i = 1:length(FieldNames) %for each patient
    figure
    for j = 1:5 %for each type of image
        %       plot histogram 
        if j ==5 
            subplot(3,2,j);
            [del_freq,del_bin]=histcounts(Struct(4).(FieldNames{i}).Scans.img, B);
            [art_freq,art_bin]=histcounts(Struct(1).(FieldNames{i}).Scans.img, B);
            if del_bin ~=art_bin, error('bin sizes must be equal'), end
            gcf=plot(del_bin(1:end-1),del_freq-art_freq);
            title(strcat(FieldNames{i},', ',type{j}));axis([-1100, 1000, -1e6 , 1e6]);
            xlabel('HU');ylabel('Freq');
        else
            subplot(3,2,j);
            gcf=histogram(Struct(j).(FieldNames{i}).Scans.img) ;
            title(strcat(FieldNames{i},', ',type{j}));axis([-1100, 1000, 0, 2e6]);
            xlabel('HU');ylabel('Freq');
        end
    end
    %save histogram
    saveas(gcf,strcat('../results/patient_histograms/figures/',FieldNames{i},'_hist.jpg'));
    
    %save CSV of histogram values to be passed onto 
    if  j <= 4
        csvwrite(strcat('../results/patient_histograms/CSV/',FieldNames{i},'_',type{j},'_hist.csv'),[gcf.BinEdges(1:end-1), gcf.Values]);
    else
        csvwrite(strcat('../results/patient_histograms/CSV/',FieldNames{i},'_',type{j},'_hist.csv'),[del_bin,del_freq-art_freq]);
    end
end
    

%KEEPING CODE FOR WHEN WE NEED TO DO DELAY - ARTERIAL HISTOGRAM
% for i = 1:length(FieldNames) %for each patient
%     figure
%     for j = 1:5 %for each type of image
%         if j == 5 %plot Del - Art histogram
%             subplot(2,3,j);
%             gcf=histogram((Struct(3).(FieldNames{i}).Scans.img)-(Struct(1).(FieldNames{i}).Scans.img)) ;
%             title(strcat(FieldNames{i},', ',type{j}));%axis([-1100, 1000, 0, 2e6]);
%         xlabel('HU');ylabel('Freq');
% 
%         else
%             %       plot histogram
%             subplot(2,3,j);
%             gcf=histogram(Struct(j).(FieldNames{i}).Scans.img) ;
%             title(strcat(FieldNames{i},', ',type{j}));axis([-1100, 1000, 0, 2e6]);
%         xlabel('HU');ylabel('Freq');

%         end
%     end
% %     saveas(gcf,strcat('../results/',FieldNames{i},'_hist.jpg'));
% end

end