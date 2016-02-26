str='D:\INESC\DadosTese\PX_044_002_Z\Kinect1\Patient3_2_Depth0000162_2014_03_20_14_09_25_156.png';
[x,y,l,a]=getPos(str);

x1=x;
x2=l-y;
w=y-x;
CM=floor(w/2);
CG=floor(l/2);

abs(x1-x2)
abs(CM-CG)