clear all;
close all;
clc;


filename = 'img.jpg';
img = imread(filename);
img = rot90(img);
figure('name','Basic Analysis - 1439692');

%---------------A----------------
%Loading image from directory
subplot(2,5,1);
%display original image
imshow(img);
title('(A)');
print('-clipboard','-dbitmap')

%---------------B----------------
subplot(2,5,2);
%split red channels
red = img(:,:,1);
%split red channels
green = img(:,:,2);
%split red channels
blue = img(:,:,3);
%combine to grayscale using given threshold values
greyimg = (red * 0.2126) + (green * 0.7152) + (blue * 0.0722);
%display greyscale image
imshow(greyimg);
title('(B)');

%----------------C------------------------
subplot(2,5,3);
axis off;
[M, N] = size(greyimg);
%size of colored image
RGB_img_size = M * N * 3;
%size of grayscale image
grayscale_img_size = M * N;
%size of binary image
binary_img_size = double((M * N)/8);
%display text on panel
str = sprintf('M and N = %d, %d',M,N);
text(0.2,0.80,str);
str = sprintf('RGB Size(bytes) = %d',RGB_img_size);
text(0.2,0.6,str);
str = sprintf('L Size(bytes) = %d',grayscale_img_size);
text(0.2,0.4,str);
str = sprintf('B Size(bytes) = %d',binary_img_size);
text(0.2,0.2,str);
title('(C)');
%----------------D------------------------
subplot(2,5,4);
axis off;

Lmax = max(max(greyimg));
Lmin = min(min(greyimg));
[rmax,cmax] = find(greyimg == Lmax,1);
[rmin,cmin] = find(greyimg == Lmin,1);
%pdist and pdist2 functions not working on here
city_block_dist = pdist([rmax,cmax;rmin,cmin],'cityblock');
euclid_dist = pdist([rmax,cmax;rmin,cmin],'euclidean');
Lmean = double(mean2(greyimg));
str = sprintf('Lmin and Lmax = %d, %d',Lmin,Lmax);
text(0.2,0.80,str);
str = sprintf('Cblock dist Lmin-Lmax = %d',city_block_dist);
text(0.2,0.6,str);
str = sprintf('Euclid dist Lmin-Lmax = %d',euclid_dist);
text(0.2,0.4,str);
str = sprintf('Lmean = %d',Lmean);
text(0.2,0.2,str);
title('(D)');
%--------------E---------------------
subplot(2,5,5);
bin_image= greyimg  > 128;
imshow(bin_image);
hold on;
plot(cmax,rmax,'go','LineWidth',5);
plot(cmin,rmin,'ro','LineWidth',5);
title('(E)');

%--------------F---------------------
subplot(2,5,6);
axis off;
Crange = (Lmax + 1) - (Lmin + 1);
Normrange = (double(Crange)/256);
Cmich = double(Lmax-Lmin)/double(Lmax+Lmin);
[m,n] = size(greyimg);
temp = zeros(m,n);
for a = 1:m
    for b = 1:n
        temp(a,b) = (greyimg(a,b)- Lmean)*(greyimg(a,b)- Lmean) ;
    end
end
tempsum =  sum(sum(temp));
Crms = sqrt(1/(m*n) * double(tempsum));
str = sprintf('Crange of L =  %d',Crange);
text(0.2,0.80,str);
str = sprintf('Norm range of L = %.2f',Normrange);
text(0.2,0.6,str);
str = sprintf('Cmich of L = %.2f',Cmich);
text(0.2,0.4,str);
str = sprintf('Cmean of L = %.2f',Crms);
text(0.2,0.2,str);
title('(F)');

%------------------G-----------------------
subplot(2,5,7);
H_count = imhist(greyimg);
bar([0:255], H_count, 'r');
xlabel('Luminance', 'FontSize', 14);
ylabel('Count','FontSize',14);
title('(G)');

%------------------H-----------------------
subplot(2,5,8);
H_normCount = H_count./(m*n);
bar([0:255], H_normCount, 'r');
xlabel('Luminance', 'FontSize', 14);
ylabel('Count','FontSize',14);
xlim([0 255]);ylim([0 max(H_normCount)]);
title('(H)');

%------------------I-----------------------
subplot(2,5,9); 
for currentLum = 1:256
    H_cumul(currentLum) = sum(H_count(1:currentLum));
end
bar([0:255], H_cumul, 'r');
xlabel('Luminance', 'FontSize', 14);
ylabel('Cumulative Count','FontSize',14);
xlim([0 255]);ylim([0 max(H_cumul)]);
title('(I)');

%------------------J-----------------------
subplot(2,5,10); 
H_normCumul = H_cumul./(m*n);
bar([0:255], H_normCumul, 'r');
xlabel('Luminance', 'FontSize', 14);
ylabel('Cumulative Count','FontSize',14);
xlim([0 255]);ylim([0 max(H_normCumul)]);
title('(J)');
