function [imgOut] = myBfilter(pathname, filename, finalname, plotOption)
%% [ptCloudOut,inlierIndices,outlierIndices] = MYPCDENOISE(xyz, nNeigh, Thresh)
%
%   INPUTS:
%   pathname 	-   Path of the input and output files.
%   filename    -   Name of the input image.
%   finalname   -   Final name of the image to ouput.
%   plotOption  -   Option to plot between process's steps.
%
%   OUTPUTS:
%   imgOut   -   mxn, Output image.
%
% by António Pintor (abpintor@hotmail.com) 
% May 2016

img1 = double(imread([pathname,filename]))/65535;
%% Set bilateral filter parameters.
w     = 5;       % bilateral filter half-width
sigma = [3 0.1]; % bilateral filter standard deviations
%% Filter
bflt_img1 = bfilter2(img1,w,sigma);
%%
imgOut =uint16(bflt_img1*65535);
se = strel('disk',5);  
imgOut=uint16(imopen(double(imgOut),se));
if(plotOption==1)
    figure(1);
    imshow(img1);
    figure(2);
    imshow(bflt_img1);
    figure(3);
    imshow(imgOut);
end
%%
imwrite(imgOut,[pathname,finalname]);
end