clc;
clear;
close all;
tic
img=imread('D:\INESC\DadosTese\PX_044_002_Z\Kinect1\Patient3_2_Depth0000162_2014_03_20_14_09_25_156.png');
figure(1);
imshow(img);

[X, Y]=size(img);
maximo=max(max(img));
for j=1 : Y
    for i=1 : X
        if(maximo==img(i,j))
            img(i,j)=2047;
        end
    end
end
flag1=0;
img2=uint8(img./8);
figure(2);
imshow(img2);

figure(3);
[counts,x] = imhist(img2);
stem(x,counts);
K=4;
img3 = nonUniform(img2,8,8-4);

figure(4);
[counts,x] = imhist(img3);
stem(x,counts);


figure(5);
imshow(img3);


toc