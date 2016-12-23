clear all;
close all;
clc;

filename = 'img.jpg';
RGBimg = imread(filename);
RGBimg = rot90(RGBimg);
figure('name','Segmentation - 1439692');

grey_img = rgb2gray(RGBimg);

%---------------A----------------
subplot(2,5,1);
%split red channels
img_red_channel = RGBimg(:,:,1);
%split green channels
img_green_channel = RGBimg(:,:,2);
%split bluell channels
img_blue_channel = RGBimg(:,:,3);
a = zeros(size(RGBimg, 1), size(RGBimg, 2));
just_red = cat(3, img_red_channel, a, a);
just_green = cat(3, a, img_green_channel, a);
just_blue = cat(3, a, a, img_blue_channel);

%threshold red channels
%limimt gottenn using the color thresholding application
red_channel_upper_threshold_lim = 239;
red_channel_lower_threshold_lim = 101;
green_channel_upper_threshold_lim = 201;
green_channel_lower_threshold_lim = 61;
blue_channel_upper_threshold_lim = 187;
blue_channel_lower_threshold_lim = 28;

threshhold_red = img_red_channel < red_channel_upper_threshold_lim;
shred = uint8(threshhold_red) .* img_red_channel;
threshhold_red = shred > red_channel_lower_threshold_lim;
%thred = uint8(thred);
%threshold green channel
threshold_green = img_green_channel < green_channel_upper_threshold_lim;
shgreen = uint8(threshold_green) .* img_green_channel;
threshold_green = shgreen > green_channel_lower_threshold_lim;
%thgreen = uint8(thgreen);
%threshold green channels
threshold_blue = img_blue_channel < blue_channel_upper_threshold_lim;
shblue = uint8(threshold_blue) .* img_blue_channel;
threshold_blue = shblue > blue_channel_lower_threshold_lim;
%thblue = uint8(thblue) ;
%thorig =  cat (3,thred,thgreen,thblue);
bin_img = (threshhold_red .* threshold_green) .* threshold_blue;
imshow(bin_img);
title('(A)');

%---------------B----------------
subplot(2,5,2);
%masked =  cat(3,thred,thgreen,thblue);
bin_img = repmat(bin_img,1,1,3);
masked_rgb_img = (uint8(bin_img) .* RGBimg );
plot(imhist(img_red_channel),'r:');
hold on;
plot(imhist(img_green_channel),'m:');
plot(imhist(img_blue_channel), 'k:');
plot([red_channel_upper_threshold_lim,red_channel_upper_threshold_lim],[0,255],'r--');
plot([red_channel_lower_threshold_lim,red_channel_lower_threshold_lim],[0,255],'r--');
plot([blue_channel_upper_threshold_lim,blue_channel_upper_threshold_lim],[0,255],'m--');
plot([blue_channel_lower_threshold_lim,blue_channel_lower_threshold_lim],[0,255],'m--');
plot([green_channel_upper_threshold_lim,green_channel_upper_threshold_lim],[0,255],'k--');
plot([green_channel_lower_threshold_lim,green_channel_lower_threshold_lim],[0,255],'k--');
xlim([0 255]);ylim([0 max(imhist(img_red_channel))]);
title('(B)');


%---------------C----------------
subplot(2,5,3);
imshow(masked_rgb_img);
title('(C)');

%---------------D----------------
subplot(2,5,4);
s = strel('disk',10);
eroded_bin_mask = imerode(bin_img(:,:,1),s);
imshow(eroded_bin_mask);
title('(D)');

%---------------E----------------
subplot(2,5,5);
eroded_rgb_img = uint8(eroded_bin_mask) .* RGBimg ;
imshow(eroded_rgb_img);
title('(E)');

%---------------F----------------
subplot(2,5,6);
s = strel('disk',60);
morph_clsd_bin_mask = imclose(eroded_bin_mask,s);
imshow(morph_clsd_bin_mask);
title('(F)');

%---------------G----------------
subplot(2,5,7);
morph_clsd_rgb_img = uint8(morph_clsd_bin_mask) .* RGBimg;
imwrite(morph_clsd_rgb_img,'morpcls.jpg');
imshow(morph_clsd_rgb_img);
title('(G)');

%---------------H----------------
subplot(2,5,8);
bounding_region = regionprops(morph_clsd_bin_mask, 'BoundingBox', 'Area');
bounding_box = bounding_region(1).BoundingBox;
imshow(RGBimg);
rectangle('Position', [bounding_region.BoundingBox(1),bounding_region.BoundingBox(2),bounding_region.BoundingBox(3),bounding_region.BoundingBox(4)], 'EdgeColor', 'blue');
title('(H)');

%---------------I----------------
subplot(2,5,9);
face_edge = edge(morph_clsd_bin_mask,'Prewitt',0.01,'both');
s = strel('disk',5);
face_edge = imdilate(face_edge,s);
imshow(face_edge); 
title('(I)');

%---------------H----------------
subplot(2,5,10);
dim = size(face_edge);
col = round(dim(2)/2)-90;
row = min(find(face_edge(:,col)));
boundary = bwtraceboundary(face_edge,[row, col],'N');
imshow(grey_img);
hold on;
plot(boundary(:,2),boundary(:,1),'y','LineWidth',1);
title('(J)');
