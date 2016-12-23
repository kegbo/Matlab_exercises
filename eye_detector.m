clear all;
close all;
clc;

filename = 'eyes.jpg';
img = imread(filename);
Eyes = vision.CascadeObjectDetector('EyePairBig');
Eye_area = step(Eyes,img);
figure;
imshow(img);
rectangle('Position',[Eye_area(2,1),Eye_area(2,2),Eye_area(2,3),Eye_area(2,4)],'LineWidth',4,'LineStyle','-','EdgeColor','b');
title('name','Eye Detection');