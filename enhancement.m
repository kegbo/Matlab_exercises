clear all;
close all;
clc;

filename = 'img.jpg';
RGBimg = imread(filename);
RGBimg = rot90(RGBimg);
L = rgb2gray(RGBimg);
figure('name','Enhancement');

%---------------A----------------
subplot(2,5,1);
Lmax = max(max(L));
Lmin = min(min(L));
Ldiff = Lmax - Lmin;
hist_stretch = imadjust(L);
imshow(hist_stretch);
title('(A)');

%---------------B----------------
subplot(2,5,2);
%plot(imhist(L),'--r');
plot(imhist(hist_stretch),'--m');
xlabel('Luminance', 'FontSize', 14);
ylabel('Count','FontSize',14);
xlim([0 255]);ylim([0 max(imhist(hist_stretch))]);
title('(B)');

%---------------C----------------
subplot(2,5,3);
hist_equalized = histeq(L);
imshow(hist_equalized);
title('(C)');

%---------------D----------------
subplot(2,5,4);
%plot(imhist(L),'--r');
plot(imhist(hist_equalized),'--m');
xlabel('Luminance', 'FontSize', 14);
ylabel('Count','FontSize',14);
xlim([0 255]);ylim([0 max(imhist(hist_equalized))]);
title('(D)');
%---------------E----------------
subplot(2,5,5);
filename = 'morpcls.jpg';
img2f = imread(filename);
img2f = rgb2gray(img2f);
hist_stretch_img2f = imadjust(img2f);
imshow(hist_stretch_img2f);
title('(E)');

%---------------F----------------
subplot(2,5,6);
hist_equalized_img2f = histeq(img2f);
imshow(hist_equalized_img2f);
title('(F)');

%---------------G----------------
subplot(2,5,7);
grey_img_type_double = double(L);
M = size(grey_img_type_double, 1); N = size(grey_img_type_double, 2);
convolution_masked_grey_img = zeros(M, N);
maskW = 3;
uSharp = fspecial('unsharp', 0.2);
for row=floor(maskW/2)+1:M-floor(maskW/2)
    for col=floor(maskW/2)+1:N-floor(maskW/2)
        convolution_masked_grey_img(row,col) = sum(sum(grey_img_type_double(row-floor(maskW/2):row+floor(maskW/2), col-floor(maskW/2):col+floor(maskW/2)).*uSharp));
    end
end
convolution_masked_grey_img = uint8(convolution_masked_grey_img);
imshow(convolution_masked_grey_img);
title('(G)');

%---------------H----------------
subplot(2,5,8);
F = fspecial('disk');
filtered_img = imfilter(L,F);
imshow(filtered_img);
title('(H)');

%---------------I----------------
subplot(2,5,9);
noised_img = imnoise(L,'salt & pepper',0.1);
imshow(noised_img);
title('(I)');

%---------------J----------------
subplot(2,5,10);
noiseless_img =  medfilt2(noised_img, [3 3]);
imshow(noiseless_img);
title('(J)');

