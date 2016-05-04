close all;
clear;
clc;
%%
s1 = strcat(uigetdir('D:\INESC\DadosTese\','Select Patient'),'\Kinect1\Results\');
%%
filtrarRuido(s1,'dfrontal_Seg_Reg.PNG','novo.png','dfrontal1.PNG');
%%
system(['teste1.exe ','seg_F ',s1,'cfrontal1.PNG ',s1,'novo.png']);