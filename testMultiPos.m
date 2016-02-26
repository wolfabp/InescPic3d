clc;
clear;
%close all;
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
%% Scan images and get features
for i=1:tamanho
    %disp(i);
    c=textscan(names{i},'%s');
    str=c{1};
    [x,lvle,y,lvld,l,a]=getPos(strcat(s1,str{2}));
    
    img=imread(strcat(s1,str{2}));
    img2=uint8(img./8);
    img3 = nonUniform(img2,8,4);
    figure(2);
    imshow(img3);
    
%     pause(0.066);
    figure(3);
    [counts,r] = imhist(img3);
    stem(r,counts);
    pause(0.066);
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



