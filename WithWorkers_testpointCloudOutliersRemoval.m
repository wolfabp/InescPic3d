close all;
clc;
clear;
%%
filename='L.ply';
finalname='L3DFilterWithWorkersAfterBFilter&Open&Segmented.ply';
%% get file
pathname = strcat(uigetdir('D:\INESC\pictureDemo\data\','Select Patient'),'\Kinect1\Results\cPointClouds\');
%% Get point cloud
tic
pcF=plyToMatSO(pathname,filename);
toc
tic
%% set parameters
stdev = std(pcF(:,1:3), 1, 1);
stdD = sqrt(sum(stdev.^2));
qua1=pcF(pcF(:,1)>0 & pcF(:,2)>=0,:);
qua2=pcF(pcF(:,1)<=0 & pcF(:,2)>0,:);
qua3=pcF(pcF(:,1)<0 & pcF(:,2)<=0,:);
qua4=pcF(pcF(:,1)>=0 & pcF(:,2)<0,:);
qua={qua1,qua2,qua3,qua4};
%% start filtering
outs= cell(4);
a=0;
parfor i= 1:4
    [out,idx]=mypcdenoise3(qua{i}(:,1:3),100,0.05,stdD);
    a=a+1;
    fprintf(2,'Finished worker %d',i);
    outs{i}=qua{i}(idx,:);
end
outi=[outs{1,1};outs{2,1};outs{3,1};outs{4,1}];
%% get output
toc
tic
pcOut=outi;
tamanho=size(pcOut,1);
%% write to new file
writePly(pathname,finalname,pcOut,tamanho);
toc
fprintf(2,'Finished\n');