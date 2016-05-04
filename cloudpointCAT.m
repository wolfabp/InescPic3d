%% Concatenate the 3 poses cloudpoints 
% Get file
close all;
clc;
clear;

pathname = strcat(uigetdir('D:\INESC\pictureDemo\data\','Select Patient'),'\Kinect1\selected\cPointClouds\');

pcF=plyToMatSO(pathname, 'F.ply');
pcL=plyToMatSO(pathname, 'L_reg.ply');
pcR=plyToMatSO(pathname, 'R_reg.ply');

pcReg = vertcat(pcF,pcL);
pcReg = vertcat(pcReg,pcR);

writePly(pathname,'registered_new.ply',pcReg,size(pcReg,1));

