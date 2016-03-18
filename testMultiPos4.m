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
simetria=zeros(tamanho,1);

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
    
    img14=uint8(times(double(img2),imgnovo)+imgnovo2);
        
%%%     figure(11)
%%%     imshow(img14);
%     figure(73);
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
%     figure(14);
%     imshow(img4);
%     figure(15);
%     imshow(img5);
%     figure(16);
%     imshow(img6);
     
%     [x,lvle,y,lvld,l,h]=getPos2((~img4)*255);
    
    img4=im2bw(img4);
%     img5=im2bw(img5);
    s=regionprops(img4,'BoundingBox','Area');
    measurements(i,1)=s(1).Area;
    bbox=s(1).BoundingBox;
%     rectangle('Position', [bbox(1),bbox(2),bbox(3),bbox(4)],...
%         'EdgeColor','r','LineWidth',2 )
%     pause(0.3);
    bbox=floor(bbox);
    w=round(bbox(3)/2.0);
    x=bbox(2);
    if(bbox(2)==0)
        bbox(2)=bbox(2)+1;
        x=0;
    end;
    y=bbox(1);
    if(bbox(1)==0)
        bbox(1)=bbox(1)+1;
        y=0;
    end;
    crop1=img4(bbox(2):(x+bbox(4)),bbox(1):(y+w));
    crop2=img4(bbox(2):(x+bbox(4)),(bbox(1)+w):y+bbox(3));
%     figure(21);
%     imshow(crop1);
%     figure(22);
%     imshow(crop2);
%     
    invCrop2=flip(crop2 ,2);
%     figure(23);
%     imshow(invCrop2);
    
    count1=0;
    count2=0;
    
    for v=1:w
        for u=1:bbox(4)
            if(crop1(u,v)==1 || invCrop2(u,v)==1 )
                count1=count1+1;
            end
            if(crop1(u,v)==1 && invCrop2(u,v)==1 )
                count2=count2+1;
            end
        end
    end
    
    simetria(i)=count2*100.0/count1;
%     pause();
    
end


figure(50);
plot(1:1:tamanho,simetria);
hold
plot(mean(simetria));
plot(smooth(simetria(:),0.05,'moving'),'r');
toc