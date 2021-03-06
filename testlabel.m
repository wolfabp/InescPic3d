clc
clear
close all;
s1='D:\INESC\DadosTese\PX_044_003_E\Kinect1\';
img=imread(strcat(s1,'Patient4_3_Depth0000001_2014_03_20_14_29_12_189.png'));
img2=uint8(img./8);
img3 = nonUniform(img2,8,4);
[M,N]=size(img3);
img4=zeros(M,N);


[counts,r] = imhist(img3);
for posi=1:256
    if(counts(posi)>10)
        a=posi-1;
        break;
    end
end
for u=1:M
    for v=1:N
        if(img3(u,v)==a)
            img4(u,v)=255;
        end
    end
end
[L,num] = bwlabel(img4);
area=zeros(num);
for r=1:num
    area(r) = bwarea(L==r);
end
max(area);