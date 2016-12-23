clear all;
close all;
clc;


disp('Image Validator');
disp('This application is used to validate an original watermarked image using dct method');
disp('and also remove to a dewatermark a watermarked image');
disp('Instructions:'); 
disp('1) To begin, hit enter and select the image you want to validate or dewatermark using the dialog box');
disp('2) hit enter select the image used as a watermarker');
disp('Note: If the resulting difference is Zero then the image is an original');
disp('This techniques works with non modified images only');
disp('The watermarked version and non waterwarked version have to be of same size');
disp('Disclaimer:If image provided is for de watermarking has not been watermarked,output will be distorted');

figure('name','Image Validator');
%Menu option
menu = 4;
while(menu < 0) || (menu > 2)
   disp('Enter 1 for Dewatermarking');
   disp('Enter 2 for image validation');
   menu = input('::');
end

%image selection
disp('Hit enter to select the image');
WT = input(':::');
filename = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'Water Marker');

%test image to check if original
original_watermarked_rgb_img = double(imread(filename));

%watermarker selector
disp('Hit enter to select image used as a water marker:');
WT = input(':::'); 
   
filename = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'Water Marker');
      
disp('converting to greyscale...');
watermarker_img = imread(filename);
grey_watermarker_img = rgb2gray(watermarker_img);
binary_watermarker_img = grey_watermarker_img > 128;

[rm,cm] = size(binary_watermarker_img);
%watermarking cooefficient used
watermarking_cooefficient = 0;
while(watermarking_cooefficient < 1)
    disp('Enter the coefficient of watermarking used');
    watermarking_cooefficient = input(':::');
end

disp('Some discrete cosine transformation going on here...');
%discrete cosine transformatiohn
original_img_red_channel_dct = dct2(original_watermarked_rgb_img(:,:,1));
original_img_green_channel_dct = dct2(original_watermarked_rgb_img(:,:,2));
original_img_blue_channel = dct2(original_watermarked_rgb_img(:,:,3));
disp('Ok..but what is the meaning of life...');
%substracting masking element frm channels
original_img_red_channel_dct(1:rm,1:cm) = original_img_red_channel_dct(1:rm,1:cm) - watermarking_cooefficient * binary_watermarker_img;
original_img_green_channel_dct(1:rm,1:cm) = original_img_green_channel_dct(1:rm,1:cm) - watermarking_cooefficient * binary_watermarker_img;
original_img_blue_channel(1:rm,1:cm) = original_img_blue_channel(1:rm,1:cm) - watermarking_cooefficient * binary_watermarker_img;
%perform inverse discrete cosine transform
final_img_red_channel = idct2(original_img_red_channel_dct);
final_img_green_channel = idct2(original_img_green_channel_dct);
final_img_blue_channel = idct2(original_img_blue_channel);
%reconstructing original image
final_img(:,:,1) = final_img_red_channel;
final_img(:,:,2) = final_img_green_channel;
final_img(:,:,3) = final_img_blue_channel;

if(menu == 1)
    disp('Please provide a name for your output file in the format imgname.imgformat');
    disp('Do not forget the quotes');
    filename = input('::');
    imwrite((original_watermarked_rgb_img/255),filename);
    disp('DONE'); 
    subplot(2,2,3);
    imshow(final_img/255);
    title('Dewatermarked Image');
end

if(menu == 2)
    disp('Hit enter to select original non watermarked image');
    WT = input(':::'); 
    filename = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'Water Marker');
     original_img_without_watermark = double(imread(filename));
     diff = ((final_img-original_img_without_watermark));
     val = find(diff > 0);
     
     if(isempty(val))
        str = 'Image is original';
     else
         str = 'Image is not original';
     end
     
    subplot(2,2,3);
    imshow((original_img_without_watermark/255));
    title('Original Image');
    
    subplot(2,2,4);
    hold on;
    axis off;
    text(0.2,0.80,str);
end


subplot(2,2,1);
imshow(original_watermarked_rgb_img/255);
title('Watermarked image');
subplot(2,2,2);
imshow(watermarker_img);
title('Watermarker provided');

%comparision shud return a completely black image for no difference btw
%original and image provided for test
%imshow(abs(yy-x)*10000);