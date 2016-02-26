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

total=0;
n=1;
for j=1 : Y
    flag2=0;
    for i=1 : X
        if(img(i,j)< 2048)
            total=double(double(total)+double(img(i,j)));
            media=total/n;
            if(0.3<((media-img(i,j))/media))
                flag2=1;
                posRightX=j;
                posRightY=i;
                break;
            end
            n=n+1;
        end
    end
    if(flag2==1)
        break;
    end
end


total=0;
n=1;
for j= Y: -1: 1
    flag2=0;
    for i= X: -1: 1
        if(img(i,j)< 2048)
            total=double(double(total)+double(img(i,j)));
            media=total/n;
            if(0.3<((media-double(img(i,j)))/media))
                flag2=1;
                posLeftX=j;
                posLeftY=i;
                break;
            end
            n=n+1;
        end
    end
    if(flag2==1)
        break;
    end
end

posLeftX
posRightX
toc
