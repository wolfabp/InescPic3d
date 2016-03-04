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

valuesPosMetodo1=zeros(tamanho,2);
valuesPosMetodo2=zeros(tamanho,2);
valuesPosMetodo3=zeros(tamanho,4);
largura=zeros(tamanho,2);
measurements=zeros(tamanho,5);
centroid=zeros(tamanho,2);
%% Scan images and get features
for i=1:tamanho
    %disp(i);
    str=names{1,2}{i,1};
    img=imread(strcat(s1,str));
    img2=uint8(img./8);
%     img3 = nonUniform(img2,8,4);
    
%     figure(10)
%     imshow(img2);
    level=graythresh(img2);
    
    imgnovo=im2bw(img2,level);
    
    imgnovo2=imgnovo*255;
    imgnovo=logical(((1+double(imgnovo))*-1)+2);
    
    [M,N]=size(imgnovo);
    img14=uint8(times(double(img2),imgnovo)+imgnovo2);
        
%     figure(11)
%     imshow(img14);
%     figure(12)
    img3=nonUniform(img14,8,4);
%     imshow(img3);
%     pause();
%     figure(13);
%     imshow(img3);
       
    [img4,img5] = getBest2region(img3);
%     figure(14);
%     img6=uint8((img4*(3/4))+(img5*(1/4)));
%     imshow(img6);
    img4=im2bw(img4);
    img5=im2bw(img5);
    s=regionprops(img4,'Orientation','Area','Centroid','ConvexArea','EulerNumber','Perimeter');
    measurements(i,1)=s(1).Orientation;
    measurements(i,2)=s(1).Area;
    cent=s(1).Centroid;
    centroid(i,1)=cent(1);
    centroid(i,2)=cent(2);
    measurements(i,4)=s(1).ConvexArea;
    measurements(i,3)=abs(measurements(i,4)-measurements(i,2));
    measurements(i,5)=s(1).Perimeter;
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
area3=smooth(measurements(:,3),0.05,'moving');
plot(1:1:tamanho,area3,'bo-');
hold;
plot(1:1:tamanho,measurements(:,4),'g');
plot(1:1:tamanho,area2,'r');
valormedio2=mean(area3);
arraymedio2=zeros(tamanho);
arraymedio2(:)=valormedio2;
plot(1:1:tamanho,arraymedio2);

poslatesq=1;
for i=1: tamanho
   if(measurements(i,2)>valormedio)
       poslatesq=i;
       break;
   end
end
str=names{1,1}{poslatesq,1};
figure(22);
imshow(imread(strcat(s1,str)));
% img2=uint8(img./8);
% img3 = nonUniform(img2,8,4);
% figure(23);
% imshow(img3);
poslatdir=1;
for i=poslatesq: tamanho
    flag1=((measurements(i+1,2)<valormedio));
    flag2=((measurements(i+2,2)<valormedio));
    flag3=((measurements(i+3,2)<valormedio));
    flag4=((measurements(i+4,2)<valormedio));
    flag5=((measurements(i+5,2)<valormedio));
    flagTotal=flag1+flag2+flag3+flag4+flag5;
   if((measurements(i-2,2)<valormedio) && flagTotal>4)
       poslatdir=i-3;
       break;
   end
end
str=names{1,1}{poslatdir,1};
figure(24);
imshow(imread(strcat(s1,str)));
% img2=uint8(img./8);
% img3 = nonUniform(img2,8,4);
% figure(25);
% imshow(img3);
posfrontal=floor(((poslatdir)+(poslatesq))/2);
str=names{1,1}{posfrontal,1};
figure(26);
imshow(imread(strcat(s1,str)));
% img2=uint8(img./8);
% img3 = nonUniform(img2,8,4);
% figure(27);
% imshow(img3);



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

toc