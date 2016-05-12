%%
s1 = strcat(uigetdir('D:\INESC\DadosTese\','Select Patient'),'\Kinect1\Results\');
%%
system(['teste1.exe ','_F ',s1,'cfrontal1.png ',s1,'novo.PNG ']);
%%
% [result] = removeBackground(s1,'afterSegF.ply','afterSegF')    