%%
s1 = strcat(uigetdir('D:\INESC\DadosTese\','Select Patient'),'\Kinect1\Results\');
tic

system(['teste1.exe ','F ',s1,'cfrontal1.png ',s1,'dfrontal_Seg_Full.PNG ']);

system(['teste1.exe ','seg_F ',s1,'cfrontal1.PNG ',s1,'dfrontal_Seg_Reg.PNG ']);

system(['teste1.exe ','seg_L ',s1,'cright1.PNG ',s1,'dright_Seg_Reg.PNG ']);

system(['teste1.exe ','seg_R ',s1,'cleft1.PNG ',s1,'dleft_Seg_Reg.PNG ']);

system(['teste1.exe ','L ',s1,'cright1.PNG ',s1,'dright1.PNG ']);

system(['teste1.exe ','R ',s1,'cleft1.PNG ',s1,'dleft1_sim.PNG ']);
toc