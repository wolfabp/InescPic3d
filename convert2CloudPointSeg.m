% 
% barra='\';
% 
s1 = strcat(uigetdir('D:\INESC\DadosTese\','Select Patient'),'\Kinect1\Results\');


system(['teste1.exe ','F ',s1,'cfrontal1_sim.png ',s1,'dfrontal_Seg_Full.PNG ']);

 pause;
system(['teste1.exe ','F ',s1,'cfrontal1_sim.PNG ',s1,'dfrontal_Seg_Reg.PNG ']);


% pause;
system(['teste1.exe ','R ',s1,'cright1.PNG ',s1,'dright_Seg_Reg.PNG ']);

% pause;
system(['teste1.exe ','L ',s1,'cleft1.PNG ',s1,'dleft_Seg_Reg.PNG ']);