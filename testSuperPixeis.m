clc;
clear;
close all;
regionSize = 35;
regularizer = 10 ;
ratio = 0.9;
kernelsize = 5;
maxdist=30;

data=imread('Results\cright2.png');
% Iseg = vl_quickseg(data, ratio, kernelsize, maxdist);
% figure()
% imshow(Iseg);
imlab = single( vl_xyz2lab(vl_rgb2xyz(data)) );
segments = vl_slic(imlab, regionSize, regularizer) ;
figure()
imshow(uint8(segments));

data=imread('Results\cleft2.png');
% Iseg = vl_quickseg(data, ratio, kernelsize, maxdist);
% figure()
% imshow(Iseg);
imlab = single( vl_xyz2lab(vl_rgb2xyz(data)) );
segments = vl_slic(imlab, regionSize,regularizer) ;
figure()
imshow(uint8(segments));

data=imread('Results\cfrontal2.png');
% Iseg = vl_quickseg(data, ratio, kernelsize, maxdist);
% figure()
% imshow(Iseg);
imlab = single( vl_xyz2lab(vl_rgb2xyz(data)) );
segments = vl_slic(imlab, regionSize, regularizer) ;
figure()
imshow(uint8(segments));








