close all;
clc;
clear;
%% Convert All segments and originals to point clouds
s1 = strcat(uigetdir('D:\INESC\pictureDemo\data\','Select Patient'),'\Kinect1\Results\');
tic
%% Frontal
myBfilter(s1,'dfrontal_Seg_Full.PNG','dfrontal_Seg_Full_filt.png',0);
system(['testSEG_PCcreator.exe ','F ',s1,'cfrontal1_sim.png ',s1,'dfrontal_Seg_Full_filt.PNG ']);
system(['teste1.exe ','OF ',s1,'cfrontal1_sim.png ',s1,'dfrontal_Seg_Full.PNG ']);
myDENOISEfilter(s1,['cPointClouds\','F.ply'],'F.ply');
%% Segmentations
system(['teste1.exe ','seg_F ',s1,'cfrontal1_sim.PNG ',s1,'dfrontal_Seg_Reg.PNG ']);
system(['teste1.exe ','seg_L ',s1,'cright1.PNG ',s1,'dright_Seg_Reg.PNG ']);
system(['teste1.exe ','seg_R ',s1,'cleft1.PNG ',s1,'dleft_Seg_Reg.PNG ']);
toc
%% Left
myRemoveBackgroundImg(s1,'dright1.PNG','dright1_bgrm.PNG');
myBfilter(s1,'dright1_bgrm.PNG','dright1_.png',0);
system(['testSEG_PCcreator.exe ','L ',s1,'cright1.PNG ',s1,'dright1_.PNG ']);
system(['teste1.exe ','OL ',s1,'cright1.PNG ',s1,'dright1_.PNG ']);
myDENOISEfilter(s1,['cPointClouds\','L.ply'],'L.ply');
toc
%% Right
myRemoveBackgroundImg(s1,'dleft1.PNG','dleft1_bgrm.PNG');
myBfilter(s1,'dleft1_bgrm.PNG','dleft1_.png',0);
system(['testSEG_PCcreator.exe ','R ',s1,'cleft1.PNG ',s1,'dleft1_.PNG ']);
system(['teste1.exe ','OR ',s1,'cleft1.PNG ',s1,'dleft1_.PNG ']);
myDENOISEfilter(s1,['cPointClouds\','R.ply'],'R.ply');
toc