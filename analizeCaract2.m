clc;
clear;
close all;
tic
img=imread('D:\INESC\DadosTese\PX_044_002_Z\Kinect1\Patient3_2_Depth0000162_2014_03_20_14_09_25_156.png');
figure(1);
imshow(img);

[X, Y]=size(img);
flag1=0;
img2=uint8(img./8);
figure(2);
imshow(img2);
maximo=max(max(img));
for j=1 : Y
    for i=1 : X
        if(maximo==img(i,j))
            img(i,j)=2047;
        end
    end
end

level=graythresh(img);
img3=im2bw(img,level);
img3=logical(((1+double(img3))*-1)+2);
% figure(3);
% imshow(img3);

proj=zeros(Y);
for j=1 : Y
    total=0;
    for i=1 : X
        total=double(double(total)+double(img3(i,j)));
    end
    proj(j)=total;
end

posesq=0;
for i=1 : Y
    if(proj(i)>0)
        posesq=i;
        break;
    end
end

posdir=0;
for i=Y: -1 :1
    if(proj(i)>0)
        posdir=i;
        break;
    end
end
posdir
posesq
toc