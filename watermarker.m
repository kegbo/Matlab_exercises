clear all;
close all;
clc;


disp('WATERMARKER');
disp('This application is used to embed a water marker into an image using dct method');
disp('Instructions:'); 
disp('1) To begin, hit enter and select the image you want watermarker using the dialog box');
disp('2) hit enter select the image you will like to use as the watermarker');
disp('Note: Selection will be rejcted if watermarker is larger than original image');
disp('3) Enter the coefficient of water marking strength.The higher the value the more visible the water marker');


%image for watermarking
disp('To begin hit enter to select the image for watermarking');
WT = input(':::');
filename = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'Water Marker');
      
original_img = imread(filename);
[binary_watermarking_img n] = size(original_img);
original_img_size = binary_watermarking_img*n;
original_img_type_double = double(original_img);
final_watermarked_img = original_img_type_double;

WTsize = 10^10;

%watermarker
while(WTsize > original_img_size)
    disp('Water marker has to be smaller than original image');
    disp('Hit enter to select image to be used as a water marker:');
    WT = input(':::'); 
   
    filename = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'Water Marker');
      
    watermarker_img = imread(filename);
    [binary_watermarking_img,n] = size(watermarker_img);
    WTsize = binary_watermarking_img*n;
end

%coefficient of watermarking strength
watermarking_coefficient = 10;
while(watermarking_coefficient < 11)
    disp('Enter a watermarking strength coefficient greater than 10 ');
    watermarking_coefficient = input(':::');
end

%watermarking img
grey_watermarker_img = rgb2gray(watermarker_img);
binary_watermarking_img = grey_watermarker_img > 128;
disp('converting to greyscale...');
%watermarking
%image channels
original_img_red_channel = original_img_type_double(:,:,1);
original_img_green_channel = original_img_type_double(:,:,2);
original_img_blue_channel = original_img_type_double(:,:,3);
%dicrete cosine tranformationon channels
orignal_img_dct_red_channel_ = dct2(original_img_red_channel);
%dct_red_channel_1 = dct_red_channel;
original_img_dct_blue_channel = dct2(original_img_green_channel);
%dct_blue_channel_1 = dct_blue_channel;
original_img_dct_green_channel = dct2(original_img_blue_channel);
%dct_green_channel_1 = dct_green_channel;
disp('Some discrete cosine transformation going on here...');
[rm,cm] = size(binary_watermarking_img);
%adding mask and watermarking strength
orignal_img_dct_red_channel_(1:rm,1:cm) = orignal_img_dct_red_channel_(1:rm,1:cm) + watermarking_coefficient * binary_watermarking_img;
original_img_dct_blue_channel(1:rm,1:cm) = original_img_dct_blue_channel(1:rm,1:cm) + watermarking_coefficient * binary_watermarking_img;
original_img_dct_green_channel(1:rm,1:cm) = original_img_dct_green_channel(1:rm,1:cm) + watermarking_coefficient * binary_watermarking_img;
disp('Go grab a cup of tea while i work OK...');
%Inverse discrete cosine transform
final_img_red_channel = idct2(orignal_img_dct_red_channel_);
final_img_green_channel = idct2(original_img_dct_blue_channel);
final_img_blue_channel = idct2(original_img_dct_green_channel);
disp('Almost there...');
%reconstructing final image
final_watermarked_img(:,:,1) = final_img_red_channel;
final_watermarked_img(:,:,2) = final_img_green_channel;
final_watermarked_img(:,:,3) = final_img_blue_channel;
disp('Please provide a name for your output file in the format imgname.imgformat');
disp('Do not forget the quotes');
filename = input('::');
imwrite((final_watermarked_img/255),filename);
disp('DONE');
%displaying result
figure('name','Watermarker');
subplot(1,3,1);
imshow(original_img);
title('Original Image');
subplot(1,3,2);
imshow(watermarker_img);
title('WaterMarker');
subplot(1,3,3);
imshow(final_watermarked_img/255);
title('Watermarkered Original')
%subplot(2,2,4);
%imshow(abs(y-x)*100);
%title('Difference');

