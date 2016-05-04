%% Vertical Cut Segmention for Right and Left Pose
% Get file
close all;
clc;
clear;

pathname = strcat(uigetdir('D:\INESC\pictureDemo\data\','Select Patient'),'\Kinect1\selected\cPointClouds\');

pc=plyToMatSO(pathname, 'F.ply');

cm=mean(pc(:,1));
% cm=(min(pc(:,1))+max(pc(:,1)))/2;

vertCut(pathname,'L_reg.ply','L_reg',cm);
vertCut(pathname,'R_reg.ply','R_reg',cm);