function tumor_encapsulation_driver
close all hidden
pat_num = [17]; %patient number to be tested (17,49,71,98)
                    % must make sure that the appropriate delay image file
                    % is in the patient image folder


for i = 1:length(pat_num)
    TE(i) = TE_calc(pat_num(i))
end

end

function TE = TE_calc(pat_num)

TE=0;
%GET NIFTI IMAGE FOR DELAY PHASE AND TUMOR MASK
[Del,Tumor] = get_nifty_del_tumor(pat_num);

%FIND TUMOR POINTS
T_points = find_nonzeros(Tumor);

% CLUSTER POINTS SO THAT YOU ONLY GET ONE TUMOR and no outside area
    %i.e. pick the center of the big cluster from graph, make the smallest
    %possible box (or sphere?? Ellipsoid??) that excapsulates the biggest cluster

%FIND TUMOR CENTER
T_center = get_center(T_points);


%FIND TUMOR BOUNDARY
T_bound = get_boundary(T_points);

%GET GRADIENT TO CENTER OF THE TUMOR AT EACH BOUNDARY POINT
T_grad = get_gradient(T_bound,T_center);

%GENERATE DIFFERENT LAYERS OF INDICES AT WHICH TO CHECK BRIGHTNESSES
T_layers = get_layers(T_bound,T_grad);


%GET BRIGHTNESS FROM VOXELS INSIDE AND OUTSIDE THE BOUNDARY (per layer)
T_bright = get_brightness(T_layers,Del);


%CREATE GRAPH OF AVERAGE INTENSITY PER LAYER


end

function b = get_brightness(L,Del)

n=length(L);
B = cell(size(L));

for i = 1:length(L)
    [r,~]=size(L{i});
    
    for j = 1:r
        
    end
end
b=0;

end

function L = get_layers(bound,grad)
offset = [-3:3];

L = cell(size(offset)); %initialize cell
for i = 1:length(offset)
    L{i} = round(bound + offset(i)*grad);
end
end

function grad = get_gradient(boundary, center)
[m,~] = size(boundary);
center_mat = repmat(center,m,1);
diff = boundary - center_mat;
mags = sqrt(diff(:,1).^2 + diff(:,2).^2 + diff(:,3).^2);
mags_matrix = repmat(mags,1,3);
grad =  diff./mags_matrix;
end

function [Del,Tum]=get_nifty_del_tumor(pat_num)
%get the image matrices for tumor and delay phase image

%Delay Phase Full Image
Del_struct = load_nii(strcat('Patient Images/',num2str(pat_num),'/Del.nii.gz'));
Del=Del_struct.img;

%Tumor Truth Full Image-- RIGHT NOW USING TUMOR MASK-- NOT TUMOR TRUTH
Tum_struct = load_nii(strcat('Patient Images/',num2str(pat_num),'/TumorTruth.nii.gz'));
Tum = Tum_struct.img;

if size(Del) ~= size(Tum), error('Delay and Tumor Mask Images not the same size'), end

end

function B = find_nonzeros(A)
%given a 3D matrix A, return a 3xn list of the indices of points that are
%nonzero

[k]= find(A>0); %find all values greater than zero

[x,y,z]=ind2sub(size(A),k);

B = [x,y,z];
end

function bound = get_boundary(points)
points(1:20,:)
bound = boundary(points,1);

bound_indices = sort(unique(bound));

bound = points(bound_indices,:);

figure
plot3(bound(:,1),bound(:,2),bound(:,3),'.')
% figure
% % plot3(points(:,1),points(:,2),points(:,3),'.')
% hold on
% trisurf(bound,points(:,1),points(:,2),points(:,3),'Facecolor','red','FaceAlpha',0.1)
% hold off
end

function C = get_center(A)
%find the center of a cluster of points A, using human help

%optional code for visualizing indices of nonzero values extracted from
%image
% figure; hold on
% gcf = plot3(A(:,1),A(:,2),A(:,3),'.')

%get x and y coordinates coordinates
   gcf = figure; hold on
   title({'Press the center point of biggest cluster and then click ENTER.'; ...
       'Only last click will be registered'})
   
   plot(A(:,1),A(:,2),'.')
   [x_c,y_c] = getpts(gcf);
   
   %in case of multiple clicks, grab only the last one
   x_c = round(x_c(end)); y_c=round(y_c(end));
   close(gcf)
    
%grab z-coordinate based on projection on x coordinate
    A_z = A(find(A(:,1)==x_c),:);

   gcf = figure; hold on
   title({'Press the center point and then click ENTER.'; ...
       'Only last click will be registered'})
   plot(A(:,2),A(:,3),'.')
   [~,z_c] = getpts(gcf);
   close(gcf)
   
   z_c = round(z_c(end));
   
C = [x_c,y_c,z_c]
end