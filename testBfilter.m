clc;
clear;
close all;
%%
s1 = strcat(uigetdir('D:\INESC\DadosTese\','Select Patient'),'\Kinect1\Results\');
%%
filename='dfrontal_Seg_Full.png';
% filename='novo.png';
finalname=['bfiltered',filename];
img1 = double(imread([s1,filename]))/65535;
figure(1);
imshow(img1);
% Set bilateral filter parameters.
w     = 5;       % bilateral filter half-width
sigma = [3 0.1]; % bilateral filter standard deviations
%%
bflt_img1 = bfilter2(img1,w,sigma);
figure(2);
imshow(bflt_img1);
%%

imgOut =uint16(bflt_img1*65535);
se = strel('disk',5);  
imgOut=uint16(imopen(double(imgOut),se));
% se = strel('disk',3);  
% imgOut=uint16(imdilate(double(imgOut),se));

figure(3);
imshow(imgOut);
%%
imwrite(imgOut,[s1,finalname]);
system(['testSEG_PCcreator.exe ','BfilteredFwithColorSegment ',s1,'cfrontal1.png ',s1,finalname]);
system(['teste3.exe ','BfilteredF ',s1,'cfrontal1.png ',s1,finalname]);