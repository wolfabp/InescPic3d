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
    
%%
    figure(3);
    [counts,r] = imhist(img3);
    stem(r,counts);
    a=1;
    for posi=1:256
        if(counts(posi)>0)
            a=posi-1;
            break;
        end
    end
    
    
    [M,N]=size(img3);
    img4=zeros(M,N);
    for u=1:M
        for v=1:N
            if(img3(u,v)==a)
                img4(u,v)=255;
            end
        end
    end
    
    b=1;
    for posi2=a+2:256
        if(counts(posi2)>0)
            b=posi2-1;
            break;
        end
    end
    img5=zeros(M,N);
    for u=1:M
        for v=1:N
            if(img3(u,v)==b)
                img5(u,v)=255;
            end
        end
    end
    conn=8;
    [L, num] = bwlabel(img4, conn);
    [L2, num2] = bwlabel(img5, conn);
    
    %figure(6);
    %[counts,r] = imhist(L);
%     subplot(2,3,1),imshow(img4);
    %stem(r,counts);
    %figure(7);
    %[counts,r] = imhist(L);
%     subplot(2,3,2),imshow(img5);
    %stem(r,counts);
%     subplot(2,3,3),
    
    area=zeros(num);
    for r=1:num
        area(r) = bwarea(L==r);
    end
    area=area(:,1);
    [maxi,I] = max(area);
    img4=zeros(M,N);
    for u=1:M
        for v=1:N
            if(L(u,v)==I)
                img4(u,v)=255;
            end
        end
    end
    area2=zeros(num2);
    for r=1:num2
        area2(r) = bwarea(L2==r);
    end
    area2=area2(:,1);
    [maxi2,I2] = max(area2);
    img5=zeros(M,N);
    for u=1:M
        for v=1:N
            if(L2(u,v)==I2)
                img5(u,v)=255;
            end
        end
    end
%     figure(4);
% %     subplot(2,3,4),
%     imshow(img4);
%     figure(5);
% %     subplot(2,3,5),
%     imshow(img5);
%     
%     figure(9);
%     imshow(L);
%     figure(10);
%     imshow(L2);

    figure(6);
    imshow(uint8((img4*(3/4))+(img5*(1/4))));
    pause(0.066);

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



