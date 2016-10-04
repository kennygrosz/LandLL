function HistPerPatient(Struct)
%given a structure of patients, create subplots of histograms per image
%per patient

FieldNames=fieldnames(Struct);
type={'Art','Pre','Del','Ven'};

for i = 1:length(FieldNames) %for each patient
%     figure; 
    for j = 1:4 %for each type of image
        %plot histogram
%         subplot(2,2,j);         
        gcf=histogram(Struct(j).(FieldNames{i}).Scans.img) ;
        x=
%         title(strcat(FieldNames{i},', ',type{j}));axis([-1100, 1000, 0, 2e6]);
    end
%     saveas(gcf,strcat('../results/',FieldNames{i},'_hist.jpg'));
end
end