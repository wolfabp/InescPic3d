clc;
clear;
close all;
%% Select folder and pair images with depth
s1 = strcat(uigetdir('D:\INESC\DadosTese\','Select Patient'),'\Kinect1\');
tic
%%
localresults=strcat(s1,'Results\');
mkdir(localresults);
pause(0.2);
rmdir(localresults,'s') 
pause(0.1);
mkdir(localresults);
%% Find poses
[posL1,posF1,posR1,posL2,posF2,posR2]= SelectViews(s1,0);
toc