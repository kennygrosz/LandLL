function HistPerPatient(Struct)
%given a structure of patients, create subplots of histograms per image
%per patient

FieldNames=fieldnames(Struct);
type={'Art','Pre','Del','Ven','Del-Art'};

for i = 1:length(FieldNames) %for each patient
    figure
    for j = 1:4 %for each type of image
        %       plot histogram
        subplot(2,2,j);
        gcf=histogram(Struct(j).(FieldNames{i}).Scans.img) ;
        title(strcat(FieldNames{i},', ',type{j}));axis([-1100, 1000, 0, 2e6]);
        xlabel('HU');ylabel('Freq');
    end
    %save histogram
    saveas(gcf,strcat('../results/patient_histograms/figures/',FieldNames{i},'_hist.jpg'));
    
    %save CSV of histogram values to be passed onto 
    csvwrite(strcat('../results/patient_histograms/CSV/',FieldNames{i},'_',type{j},'_hist.csv'),[gcf.BinEdges(1:end-1), gcf.Values]);
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