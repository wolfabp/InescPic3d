%% Convert All segments and originals to point clouds
s1 = strcat(uigetdir('D:\INESC\DadosTese\','Select Patient'),'\Kinect1\Results\');
tic
%%
filtrarRuido(s1,'dfrontal_Seg_Full.PNG','dfrontal_Seg_Full_filt.png','dfrontal1.PNG');
system(['teste1.exe ','F ',s1,'cfrontal1_sim.png ',s1,'dfrontal_Seg_Full_filt.PNG ']);
system(['teste1.exe ','OF ',s1,'cfrontal1_sim.png ',s1,'dfrontal_Seg_Full.PNG ']);

% filtrarRuido(s1,'dfrontal_Seg_Reg.PNG','dfrontal_Seg_Reg_filt.png','dfrontal1.PNG');
% system(['teste1.exe ','seg_F ',s1,'cfrontal1_sim.PNG ',s1,'dfrontal_Seg_Reg_filt.PNG ']);
system(['teste1.exe ','seg_F ',s1,'cfrontal1_sim.PNG ',s1,'dfrontal_Seg_Reg.PNG ']);

% filtrarRuido(s1,'dright_Seg_Reg.PNG','dright_Seg_Reg_filt.png','dright1.PNG');
% system(['teste1.exe ','seg_L ',s1,'cright1.PNG ',s1,'dright_Seg_Reg_filt.PNG ']);
system(['teste1.exe ','seg_L ',s1,'cright1.PNG ',s1,'dright_Seg_Reg.PNG ']);

% filtrarRuido(s1,'dleft_Seg_Reg.PNG','dleft_Seg_Reg_filt.png','dleft1.PNG');
% system(['teste1.exe ','seg_R ',s1,'cleft1.PNG ',s1,'dleft_Seg_Reg_filt.PNG ']);
system(['teste1.exe ','seg_R ',s1,'cleft1.PNG ',s1,'dleft_Seg_Reg.PNG ']);

%%
filtrarRuido(s1,'dright1.PNG','dright1_.png','dright1.PNG');
system(['teste1.exe ','L ',s1,'cright1.PNG ',s1,'dright1_.PNG ']);
system(['teste1.exe ','OL ',s1,'cright1.PNG ',s1,'dright1.PNG ']);

%%
filtrarRuido(s1,'dleft1.PNG','dleft1_.png','dleft1.PNG');
system(['teste1.exe ','R ',s1,'cleft1.PNG ',s1,'dleft1_.PNG ']);
system(['teste1.exe ','OR ',s1,'cleft1.PNG ',s1,'dleft1.PNG ']);

toc