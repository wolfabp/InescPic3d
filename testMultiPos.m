clc;
clear;
close all;
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
    [x,lvle,y,lvld,l,h]=getPos(strcat(s1,str{2}));
    
    img=imread(strcat(s1,str{2}));
    img2=uint8(img./8);
    img3 = nonUniform(img2,8,4);
    figure(2);
    imshow(img3);
       
    [img4,img5] = getBest2region(img3);
    figure(6);
    img6=uint8((img4*(3/4))+(img5*(1/4)));
    imshow(img6);
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
    %%
    x1=x;
    x2=l-y;
    w=y-x;
    CM=floor(w/2);
    CG=floor(l/2);
    largura(i,1)=w;
    valuesPosMetodo1(i,1)=abs(x1-x2);
    valuesPosMetodo2(i,1)=abs(CM-CG);
    lvle=int16(lvle);
    lvld=int16(lvld);
    valuesPosMetodo3(i,1)=abs(lvle-lvld);
    valuesPosMetodo3(i,2)=lvle;
    valuesPosMetodo3(i,3)=lvld;
end

%% Select candidates from width
pos1=1;
pos2=1;
posf1=1;
posf2=1;
flag1=0;
oldcmp=0;
thrs=0.1;
maximo=max(largura(:,1));
for i=1 :tamanho
    if(thrs>((maximo-largura(i,1))/maximo))
        largura(i,2)=1;
        if(flag1==0)
            flag1=1;
            pos1=i;
        end
    else
        if(flag1==1)
            pos2=i;
            cmp=(pos2-pos1);
            if(cmp>oldcmp)
                oldcmp=cmp;
                posf1=pos1;
                posf2=pos2;
            end
        end
        flag1=0;
    end

end
% for i=posf1 : posf2-1
%     largura(i,2)=1;
% end

%% Select candidates from method 2

pos1=1;
pos2=1;
posf1=1;
posf2=1;
flag1=0;
oldcmp=0;
thrs=0.75;
maximo=max(valuesPosMetodo2(:,1));
for i=1 :tamanho
    if(thrs<((maximo-valuesPosMetodo2(i,1))/maximo))
        valuesPosMetodo2(i,2)=1;
        if(flag1==0)
            flag1=1;
            pos1=i;
        end
    else
        if(flag1==1)
            pos2=i;
            cmp=(pos2-pos1);
            if(cmp>oldcmp)
                oldcmp=cmp;
                posf1=pos1;
                posf2=pos2;
            end
        end
        flag1=0;
    end

end
% for i=posf1 : posf2-1
%     valuesPosMetodo2(i,2)=1;
% end

%% Select candidates from method 1

pos1=1;
pos2=1;
posf1=1;
posf2=1;
flag1=0;
oldcmp=0;
thrs=0.90;
maximo=max(valuesPosMetodo1(:,1));
for i=1 :tamanho
    if(thrs<((maximo-valuesPosMetodo1(i,1))/maximo))
        valuesPosMetodo1(i,2)=1;
        if(flag1==0)
            flag1=1;
            pos1=i;
        end
    else
        if(flag1==1)
            pos2=i;
            cmp=(pos2-pos1);
            if(cmp>oldcmp)
                oldcmp=cmp;
                posf1=pos1;
                posf2=pos2;
            end
        end
        flag1=0;
    end

end
for i=posf1 : posf2-1
    valuesPosMetodo1(i,2)=1;
end
% for i=1 : tamanho
%     if(valuesPosMetodo1(i,1)<90)
%         valuesPosMetodo1(i,2)=1;
%     end
% end

%% Select candidates from method 3 
for i=1 :tamanho
    if(valuesPosMetodo3(i,1)<90)
        valuesPosMetodo3(i,4)=1;
    end
end

%% Select Final frontal view depth and color image
final=valuesPosMetodo3(:,4)+valuesPosMetodo1(:,2)+valuesPosMetodo1(:,2)+largura(:,2);
[M,I] = max(final) ;
c=textscan(names{I},'%s');
str=c{1};
figure(1);
imshow(imread(strcat(s1,str{1})));
img=imread(strcat(s1,str{2}));
img2=uint8(img./8);
img3 = nonUniform(img2,8,4);
figure(2);
imshow(img3);
toc

figure(10);
plot(1:1:tamanho,orient(:,1));
axis([1 tamanho -90 90])
figure(11);
plot(1:1:tamanho,orient(:,2),'o-');
hold;
valormedio=mean(orient(:,2));
arraymedio=zeros(tamanho);
arraymedio(:)=valormedio;

plot(1:1:tamanho,arraymedio);
axis([1 tamanho 0 inf])
% figure(11);
% plotyy(1:1:tamanho,orient(:,5),1:1:tamanho,orient(:,4));
figure(12);
plot(1:1:tamanho,centroid(:,1));
axis([1 tamanho 0 inf])
figure(13);
plot(1:1:tamanho,orient(:,4));
axis([1 tamanho 0 inf])
% figure(14);
% plot(1:1:tamanho,centroid(:,2));
% axis([1 tamanho 0 inf])
figure(15);
plot(1:1:tamanho,orient(:,5));
axis([1 tamanho 0 inf])
