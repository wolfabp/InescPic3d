clc;
clear;
% close all;
tic
%% Select folder and pair images with depth
s1 = strcat(uigetdir('D:\INESC\DadosTese\','Select Patient'),'\Kinect1\');
getPairs(s1);

names =textread('DataMatchNames.txt', '%s', 'whitespace', '%s','endofline', '\r\n');

tamanho=max(size(names));

valuesPosMetodo1=zeros(tamanho,2);
valuesPosMetodo2=zeros(tamanho,2);
valuesPosMetodo3=zeros(tamanho,4);
largura=zeros(tamanho,2);
orient=zeros(tamanho,5);
centroid=zeros(tamanho,2);
%% Scan images and get features
for i=1:tamanho
    %disp(i);
    c=textscan(names{i},'%s');
    str=c{1};
%     [x,lvle,y,lvld,l,h]=getPos(strcat(s1,str{2}));
    
    img=imread(strcat(s1,str{2}));
    img2=uint8(img./8);
    img3 = nonUniform(img2,8,4);
%     figure(2);
%     imshow(img3);
       
    [img4,img5] = getBest2region(img3);
%     figure(6);
%     img6=uint8((img4*(3/4))+(img5*(1/4)));
%     imshow(img6);
    img4=im2bw(img4);
    img5=im2bw(img5);
    s=regionprops(img4,'Orientation','Area','Centroid','ConvexArea','EulerNumber','Perimeter');
    orient(i,1)=s(1).Orientation;
    orient(i,2)=s(1).Area;
    cent=s(1).Centroid;
    centroid(i,1)=cent(1);
    centroid(i,2)=cent(2);
    orient(i,4)=s(1).ConvexArea;
    orient(i,5)=s(1).Perimeter;
%     pause();
end


%% Select Final frontal view depth and color image

orient(:,2)=smooth(orient(:,2),0.05,'moving');
figure(11);
plot(1:1:tamanho,orient(:,2),'o-');
hold;
valormedio=mean(orient(:,2));
arraymedio=zeros(tamanho);
arraymedio(:)=valormedio;

% plot(1:1:tamanho,arraymedio);
% axis([1 tamanho 0 inf])

poslatesq=1;
for i=1: tamanho
   if(orient(i,2)>valormedio)
       poslatesq=i;
       break;
   end
end
c=textscan(names{poslatesq},'%s');
str=c{1};
figure(20);
imshow(imread(strcat(s1,str{1})));
% img=imread(strcat(s1,str{2}));
% img2=uint8(img./8);
% img3 = nonUniform(img2,8,4);
% figure(21);
% imshow(img3);
poslatdir=1;
for i=poslatesq: tamanho
    flag1=((orient(i+1,2)<valormedio));
    flag2=((orient(i+2,2)<valormedio));
    flag3=((orient(i+3,2)<valormedio));
    flag4=((orient(i+4,2)<valormedio));
    flag5=((orient(i+5,2)<valormedio));
    flagTotal=flag1+flag2+flag3+flag4+flag5;
   if((orient(i-2,2)<valormedio) && flagTotal>4)
       poslatdir=i;
       break;
   end
end
c=textscan(names{poslatdir},'%s');
str=c{1};
figure(22);
imshow(imread(strcat(s1,str{1})));
% img=imread(strcat(s1,str{2}));
% img2=uint8(img./8);
% img3 = nonUniform(img2,8,4);
% figure(23);
% imshow(img3);


posfrontal=floor(((poslatdir)+(poslatesq))/2);

c=textscan(names{posfrontal},'%s');
str=c{1};
figure(24);
imshow(imread(strcat(s1,str{1})));
% img=imread(strcat(s1,str{2}));
% img2=uint8(img./8);
% img3 = nonUniform(img2,8,4);
% figure(25);
% imshow(img3);

poslatesq=1;
for i=tamanho:-1:1
   if(orient(i,2)>valormedio)
       poslatesq=i;
       break;
   end
end
c=textscan(names{poslatesq},'%s');
str=c{1};
figure(25);
imshow(imread(strcat(s1,str{1})));

poslatdir=1;
for i=poslatesq:-1:1
    flag1=((orient(i-1,2)<valormedio));
    flag2=((orient(i-2,2)<valormedio));
    flag3=((orient(i-3,2)<valormedio));
    flag4=((orient(i-4,2)<valormedio));
    flag5=((orient(i-5,2)<valormedio));
    flagTotal=flag1+flag2+flag3+flag4+flag5;
   if((orient(i+2,2)<valormedio) && flagTotal>4)
       poslatdir=i+3;
       break;
   end
end
c=textscan(names{poslatdir},'%s');
str=c{1};
figure(26);
imshow(imread(strcat(s1,str{1})));

posfrontal=floor(((poslatdir)+(poslatesq))/2);
c=textscan(names{posfrontal},'%s');
str=c{1};
figure(27);
imshow(imread(strcat(s1,str{1})));

toc