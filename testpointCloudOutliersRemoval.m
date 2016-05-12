close all;
clc;
clear;
filename='F.ply';
finalname='newF.ply';
%%
pathname = strcat(uigetdir('D:\INESC\pictureDemo\data\','Select Patient'),'\Kinect1\Results\cPointClouds\');
%%
tic
pcF=plyToMatSO(pathname,filename);
toc
%%
stdev = std(pcF(:,1:3), 1, 1);
stdD = sqrt(sum(stdev.^2));
[out,idx]=mypcdenoise3(pcF(:,1:3),50,0.05,stdD);
toc


pcOut=pcF(idx,:);


tamanho=size(pcOut,1);
%%
writePly(pathname,finalname,pcOut,tamanho);
toc
fprintf(2,'Finished\n');