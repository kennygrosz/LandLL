function tumor_encapsulation_driver_v2
%v2 adjusts so that if it doesn't have enough layers, it goes back and
%pulls more
    

close all hidden
pat_num = [17,49,71]; %patient number to be tested (17,49,71,98)
                    % must make sure that the appropriate delay image file
                    % is in the patient image folder

TE = zeros(length(pat_num),1);
for i = 1:length(pat_num)
    TE(i) = TE_calc(pat_num(i));
end

TE
end

function T_brightness = TE_calc(pat_num)

TE=0;
%GET NIFTI IMAGE FOR DELAY PHASE AND TUMOR MASK
[Del,Tumor] = get_nifty_del_tumor(pat_num);

% CLUSTER POINTS SO THAT YOU ONLY GET ONE TUMOR and no outside area
[Tumor,T_center] = get_main_tumor(Tumor);
T_center = T_center([2,1,3]); %permute generated centroid to make sense w data

%FIND TUMOR POINTS
T_points = find_nonzeros(Tumor);

%FIND TUMOR CENTER
% T_center = get_center(T_points)
% pause
% T_center=[ 143   329    46]; %for patient 17, use for testing

%FIND TUMOR BOUNDARY
T_bound = get_boundary(T_points);

%GET GRADIENT TO CENTER OF THE TUMOR AT EACH BOUNDARY POINT
T_grad = get_gradient(T_bound,T_center);

%GENERATE DIFFERENT LAYERS OF INDICES AT WHICH TO CHECK BRIGHTNESSES
% rT_layers = get_layers(T_bound,T_grad);

%GET BRIGHTNESS FROM VOXELS INSIDE AND OUTSIDE THE BOUNDARY (per layer)
T_median= med_tumor_brightness(Del,T_points);

T_brightness = get_brightness(T_bound, T_grad,Del,T_median);


end


function b = get_brightness(T_bound, T_grad,Del,median_b)

flag = 0; %flag indicates enough layers have been collected
    %flag == 1 indicates we found a maximum

%boundaries for layer collection
a = -3;
b = 3;

figure
hold on
while flag == 0;
    flag = 1; %exit loop unless flag is modified
    
    L = get_layers(T_bound, T_grad,a,b);
    
    n=length(L);
    B = cell(size(L));
    L_mean = zeros(n,1);
    L_median = zeros(n,1);
    
    for i = 1:n
        [r,~]=size(L{i});
        B{i} = zeros(r,1);
        
        for j = 1:r
            loc = L{i}(j,:);
            B{i}(j)= Del(loc(1),loc(2),loc(3));
        end
        L_mean(i) = mean(B{i});
        L_median(i) = median(B{i});
        
        subplot(n,1,i)
        hist(B{i})
        hold on
        title(strcat('Layer =',num2str(i-6)))
        xlim([-400,200])
        hold off
        
    end
    
    L_max = find(L_median == max(L_median),1,'last');
    
    if L_max==1
        disp('boundary not completely captured by layers collected. collecting more layers')
        flag = 0;
        a = a-3;
    elseif L_max == length(L_median)
        disp('boundary not completely captured by layers collected. collecting more layers')
        flag = 0;
        b = b+3;
    end
end


bound_layers = [L_max-1, L_max, L_max+1];
bound_med_brightness = mean(L_median(bound_layers));

b = bound_med_brightness - median_b;

B2 = [];
for i = 1:length(bound_layers)
    [r,~]=size(L{bound_layers(i)});    
    for j = 1:r
        loc = L{bound_layers(i)}(j,:);
        B2 = [B2, Del(loc(1),loc(2),loc(3))];
    end
end
bound_med_brightness = median(B2);



figure
% plot(1:n,L_mean)
plot(1:n,L_median)
hold on
plot(1:n,median_b*ones(1,n),'--') %tumor brightness
plot(1:n,bound_med_brightness*ones(1,n),'--') %bound brightness
plot(bound_layers, L_median(bound_layers),'g.','MarkerSize',15)
title({'Median brightness per layer'; strcat('Bound Brightness - Tumor Brightness =',num2str(b))}); 
legend('Layerwise Boundary Brightness', 'Median Tumor Brightness', 'Median Boundary Brightness','Tumor Boundary Layers','Location','SouthEast')
xlabel('Away from tumor center     ----->        Towards tumor center')


figure
hist(B2)
title({'Tumor Boundary Brightness Distribution'; strcat('Median Tumor Boundary Brightness =',num2str(bound_med_brightness))})


end

function L = get_layers(bound,grad,a,b)
offset = a:b;

L = cell(size(offset)); %initialize cell
for i = 1:length(offset)
    L{i} = round(bound + offset(i)*grad);
end
end

function [Tumor,Cent] = get_main_tumor(Tumor)
% Given a binary 3D tumor image, return only the main connectivity tumor

% T_points = find_nonzeros(Tumor);
% figure
% plot3(T_points(:,1),T_points(:,2),T_points(:,3),'.','MarkerSize',15)
% title('Untrimmed Tumor')
% hold off 


A = bwconncomp(Tumor);

%get the largest group

numPixels = cellfun(@numel,A.PixelIdxList);
[~,idx] = max(numPixels);
n = length(numPixels);

erase = [1:(idx-1), (idx+1):n];

for i = 1:length(erase)
    Tumor(A.PixelIdxList{erase(i)}) = 0; 
end

%find Centroid of new Tumor Image
B = bwconncomp(Tumor);

if length(B.PixelIdxList) ~=1
    error('Tumor isn''t one connected piece')
end
centroid = regionprops(B,'Centroid');

Cent = centroid.Centroid;

% T_points = find_nonzeros(Tumor);
% figure
% plot3(T_points(:,1),T_points(:,2),T_points(:,3),'.','MarkerSize',15)
% title('Trimmed Tumor')
% hold off 
% pause

end



function median_b = med_tumor_brightness(Del,points)
%return measures of central tendency for the brightness over an entire
%tumor mask

[n,~]=size(points);
brightness = zeros(n,1);

for i = 1:n
    brightness(i) = Del(points(i,1),points(i,2),points(i,3));
end

median_b = median(brightness);

figure
hist(brightness)
title({'Tumor Brightness Distribution';strcat('Tumor Brightness Median =',num2str(median_b))})
xlabel('HU')
end



function grad = get_gradient(boundary, center)
%return normalized gradient of each boundary pointing towards the center

[m,~] = size(boundary);
center_mat = repmat(center,m,1);
diff = center_mat - boundary ;
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
Tum_struct = load_nii(strcat('Patient Images/',num2str(pat_num),'/TumorMask.nii.gz'));
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
bound = boundary(points,1);

bound_indices = sort(unique(bound));

bound = points(bound_indices,:);

figure
plot3(bound(:,1),bound(:,2),bound(:,3),'.')
title('Generated Tumor Boundary')

% figure
% plot3(points(:,1),points(:,2),points(:,3),'.')
% hold on
% trisurf(bound,points(:,1),points(:,2),points(:,3),'Facecolor','red','FaceAlpha',0.1)
% hold off
end

function C = get_center(A)
%find the center of a cluster of points A, using human help

%optional code for visualizing indices of nonzero values extracted from
%image
figure; hold on
gcf = plot3(A(:,1),A(:,2),A(:,3),'.');

figure
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
%     A_z = A(find(A(:,1)==x_c),:);

   gcf = figure; hold on
   title({'Press the center point and then click ENTER.'; ...
       'Only last click will be registered'})
   plot(A(:,2),A(:,3),'.')
   [~,z_c] = getpts(gcf);
   close(gcf)
   
   z_c = round(z_c(end));
   
C = [x_c,y_c,z_c];

figure; hold on
histogram(A(:,1))
histogram(A(:,2))
histogram(A(:,3))
title({'X, Y, and Z distribution of tumor voxel locations';...
    'Unimodal Histograms indicate good tumor bounding'})
legend('x','y','z')
xlabel('Voxel Location')
ylabel('Frequency')


end