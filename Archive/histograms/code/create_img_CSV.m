function create_img_CSV(Struct)
%given a structure, create single-column CSV's for each patient and each
%image

FN=fieldnames(Struct); %patients
type={'Pre','Art','Ven','Del','Del-Art'};


for i = 1:length(FN) %for each patient
    for j = 1:4 %for each type of image
        
        %create the single-column img value
        img = reshape(Struct(j).(FN{i}).Scans.img,[],1);
        
        %saveas CSV
        strcat('../../img_csv_files/',type{j},'/',FN{i},'_',type{j},'_CSV.csv')
        writeCsvFile(strcat('../../image_csv_files/',type{j},'/',FN{i},'_',type{j},'_CSV.csv'),img);
    end
end

end