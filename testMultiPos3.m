clc;
clear;
close all;
tic
%% Select folder and pair images with depth
s1 = strcat(uigetdir('D:\INESC\DadosTese\','Select Patient'),'\Kinect1\');
getPairs(s1);
fileID = fopen('DataMatchNames.txt');
names =textscan(fileID,'%s %s');

tamanho=max(size(names{1,1}));
measurements=zeros(tamanho,5);
centros=zeros(tamanho,3);

%% Scan images and get features
for i=1:tamanho
    
    %get name & read depth image
    str=names{1,2}{i,1};
    img=imread(strcat(s1,str));
    
    %change scale & seperate the body from 
    img2=uint8(img./8);
%     figure(10)
%     imshow(img2);   
    level=graythresh(img2);
    imgnovo=im2bw(img2,level);
    imgnovo2=imgnovo*255;
    imgnovo=~imgnovo;
    
    [M,N]=size(imgnovo);
    img14=uint8(times(double(img2),imgnovo)+imgnovo2);
        
%%%     figure(11)
%%%     imshow(img14);
%      figure(73);
%     stem(imhist(img14));
    
    img3=nonUniform(img14,8,4);
%         figure(12)
%     imshow(img3);
%     
%         figure(13);
%     stem(imhist(img3));
%     pause();

    [img4,img5] = getBest2region(img3);
    img6=uint8((img4*(3/4))+(img5*(1/4)));
%%%     figure(14);
%%%     imshow(img4);
%%%     figure(15);
%%%     imshow(img4);
     
    [x,lvle,y,lvld,l,h]=getPos2((~img4)*255);
    [x2,lvle2,y2,lvld2,l2,h2]=getPos2(img3);
%     pause();
    
    centros(i,1)=x+floor((y-x)/2);
    centros(i,2)=x2+floor((y2-x2)/2);
    centros(i,3)=abs(centros(i,2)-centros(i,1));
    
    img4=im2bw(img4);
    img5=im2bw(img5);
    s=regionprops(img4,'Orientation','Area','ConvexArea');
    measurements(i,1)=s(1).Orientation;
    measurements(i,2)=s(1).Area;
    measurements(i,4)=s(1).ConvexArea;
    measurements(i,3)=abs(measurements(i,4)-measurements(i,2));
end


%% Select Final frontal view depth and color image
area2=measurements(:,2);
measurements(:,2)=smooth(measurements(:,2),0.05,'moving');
    figure(20);
plot(1:1:tamanho,measurements(:,2),'o-');
hold;
valormedio=mean(measurements(:,2));
arraymedio=zeros(tamanho);
arraymedio(:)=valormedio;
plot(1:1:tamanho,arraymedio);
    figure(21);
area3=smooth(measurements(:,3),0.1,'moving');
plot(1:1:tamanho,area3,'bo-');
hold;
plot(1:1:tamanho,measurements(:,4),'g');
plot(1:1:tamanho,area2,'r');
valormedio2=mean(area3);
arraymedio2=zeros(tamanho);
arraymedio2(:)=valormedio2;
plot(1:1:tamanho,arraymedio2);

%1st method - 1st turn
poslatesq=1;
for i=1: tamanho
   if(measurements(i,2)>valormedio)
       poslatesq=i
       break;
   end
end
str=names{1,1}{poslatesq,1};
    figure(22);
imshow(imread(strcat(s1,str)));
%     str=names{1,2}{poslatesq,1};
%     img=imread(strcat(s1,str));
%     img2=uint8(img./8);
%     img3 = nonUniform(img2,8,4);
%     figure(23);
%     imshow(img3);
%     figure(53);
%     stem(imhist(img3));
poslatdir=1;
for i=poslatesq: tamanho
    flag1=((measurements(i+1,2)<valormedio));
    flag2=((measurements(i+2,2)<valormedio));
    flag3=((measurements(i+3,2)<valormedio));
    flag4=((measurements(i+4,2)<valormedio));
    flag5=((measurements(i+5,2)<valormedio));
    flagTotal=flag1+flag2+flag3+flag4+flag5;
   if((measurements(i-2,2)<valormedio) && flagTotal>4)
       poslatdir=i-3
       break;
   end
end
str=names{1,1}{poslatdir,1};
    figure(24);
imshow(imread(strcat(s1,str)));
%     str=names{1,2}{poslatdir,1};
%     img=imread(strcat(s1,str));
%     img2=uint8(img./8);
%     img3 = nonUniform(img2,8,4);
%     figure(25);
%     imshow(img3);
%     figure(55);
%     stem(imhist(img3));
posfrontal=floor(((poslatdir)+(poslatesq))/2)
str=names{1,1}{posfrontal,1};
    figure(26);
imshow(imread(strcat(s1,str)));
%     str=names{1,2}{posfrontal,1};
%     img=imread(strcat(s1,str));
%     img2=uint8(img./8);
%     img3 = nonUniform(img2,8,4);
%     figure(27);
%     imshow(img3);
%     figure(57);
%     stem(imhist(img3));

%%%point cloud stuff
%%% ptCloud = pcfromkinect(imread(strcat(s1,names{1,2}{posfrontal,1})),imaq.VideoDevice('kinect',2),imread(strcat(s1,str)));
%%% player = pcplayer(ptCloud.XLimits,ptCloud.YLimits,ptCloud.ZLimits,...
%%% 	'VerticalAxis','y','VerticalAxisDir','down');
%%% xlabel(player.Axes,'X (m)');
%%% ylabel(player.Axes,'Y (m)');
%%% zlabel(player.Axes,'Z (m)');

%1st method - 2nd turn
poslatesq=1;
for i=tamanho:-1:1
   if(measurements(i,2)>valormedio)
       poslatesq=i;
       break;
   end
end
str=names{1,1}{poslatesq,1};
    figure(30);
imshow(imread(strcat(s1,str)));
poslatdir=1;
for i=poslatesq:-1:1
    flag1=((measurements(i-1,2)<valormedio));
    flag2=((measurements(i-2,2)<valormedio));
    flag3=((measurements(i-3,2)<valormedio));
    flag4=((measurements(i-4,2)<valormedio));
    flag5=((measurements(i-5,2)<valormedio));
    flagTotal=flag1+flag2+flag3+flag4+flag5;
   if((measurements(i+2,2)<valormedio) && flagTotal>4)
       poslatdir=i+3;
       break;
   end
end
str=names{1,1}{poslatdir,1};
    figure(31);
imshow(imread(strcat(s1,str)));
posfrontal=floor(((poslatdir)+(poslatesq))/2);
str=names{1,1}{posfrontal,1};
    figure(32);
imshow(imread(strcat(s1,str)));
    figure(33);
plot(1:1:tamanho,centros(:,3));
hold
area4=smooth(centros(:,3),0.1,'moving');
plot(1:1:tamanho,area4,'r');

[maxtab, mintab]=peakdet(area4, 10);
[maxtab2, mintab2]=peakdet(area3, 500);

%p1
for u=1: max(size(maxtab2))
    if(maxtab2(u,2)>=valormedio2)
        p1=maxtab2(u,1);
        break;
    end
end
%pm1
y=0;
if(mintab2(1,1)>p1 && mintab2(1,2)<valormedio2)
    pm1=mintab2(1,1);
    y=1;
end
v=1;
if(y==0)
    for v=1: max(size(mintab2))
        if(mintab2(v,1)>p1)
            pm1=mintab2(v,1);
            break;
        end
    end
end
x=u+1;
%p2
for u=x: max(size(maxtab2))
    if(mintab2(v,1)< maxtab2(u,1) && maxtab2(u,2)>=valormedio2)
        p2=maxtab2(u,1);
        break;
    end
end
x=v+1;
%pm2
y=0;
for v=x: max(size(mintab2))
    if(mintab2(v,1)>maxtab2(u,1) && mintab2(v,2)<valormedio2)
        pm2=mintab2(v,1);
        y=1;
        break;
    end
end
if(y==0)
    for v=x: max(size(mintab2))
        if(mintab2(v,1)>maxtab2(u,1))
            pm2=mintab2(v,1);
            break;
        end
    end
end
x=u+1;
%p3
for u=x: max(size(maxtab2))
    if(mintab2(v,1)< maxtab2(u,1) && maxtab2(u,2)>=valormedio2)
        p3=maxtab2(u,1);
        break;
    end
end
x=v+1;
%pm3
y=0;
for v=x: max(size(mintab2))
    if(mintab2(v,1)>maxtab2(u,1) && mintab2(v,2)<valormedio2)
        pm3=mintab2(v,1);
        y=1;
        break;
    end
end
if(y==0)
    for v=x: max(size(mintab2))
        if(mintab2(v,1)>maxtab2(u,1))
            pm3=mintab2(v,1);
            break;
        end
    end
end


%2nd Method - 1st turn
imagemesquerda1=round((1+pm1)/2);
imagemdireita1=round((pm2+pm1)/2);
imagemfrontal1=pm1;
    figure(40);
str=names{1,1}{imagemesquerda1,1};
imshow(imread(strcat(s1,str)));
    figure(41);
str=names{1,1}{imagemdireita1,1};
imshow(imread(strcat(s1,str)));
    figure(42);
str=names{1,1}{imagemfrontal1,1};
imshow(imread(strcat(s1,str)));


%2nd Method - 2nd turn
imagemdireita2=round((pm2+pm3)/2);
imagemesquerda2=round((pm3+tamanho)/2);
imagemfrontal2=pm3;
    figure(43);
str=names{1,1}{imagemdireita2,1};
imshow(imread(strcat(s1,str)));
    figure(44);
str=names{1,1}{imagemesquerda2,1};
imshow(imread(strcat(s1,str)));
    figure(45);
str=names{1,1}{imagemfrontal2,1};
imshow(imread(strcat(s1,str)));

toc