clc;
clear;
close all;
%% Select Options
code=1;
method=1;
plotOption=0;
%mkdir('Results');
%% Select folder and pair images with depth
s1 = strcat(uigetdir('D:\INESC\DadosTese\','Select Patient'),'\Kinect1\');
tic
getPairs(s1);
fileID = fopen('DataMatchNames.txt');
names =textscan(fileID,'%s %s');
tamanho=max(size(names{1,1}));
measurements=zeros(tamanho,5);
% centros=zeros(tamanho,3);
%% Scan images and get features
for i=1:tamanho
    
    %get name & read depth image
    str=names{1,2}{i,1};
    img=imread(strcat(s1,str));
    
    %change scale & seperate the body from 
    img2=uint8(img./8);
%     figure(10)
%     imshow(img2);   
    imgnovo=im2bw(img2,graythresh(img2));    
    img14=uint8(times(double(img2),~imgnovo)+imgnovo*255);
        
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

    [img4] = getBestRegion(img3);
%     img6=uint8((img4*(3/4))+(img5*(1/4)));
%%%     figure(14);
%%%     imshow(img4);
     
%     [x,lvle,y,lvld,l,h]=getPos2((~img4)*255);
%     [x2,lvle2,y2,lvld2,l2,h2]=getPos2(img3);
%     
%     centros(i,1)=x+floor((y-x)/2);
%     centros(i,2)=x2+floor((y2-x2)/2);
%     centros(i,3)=abs(centros(i,2)-centros(i,1));
    
    img4=im2bw(img4);
%     img5=im2bw(img5);
    s=regionprops(img4,'Area','ConvexArea');
   % measurements(i,1)=s(1).Orientation;
    measurements(i,2)=s(1).Area;
    if(method==0)
        measurements(i,4)=s(1).ConvexArea;
        measurements(i,3)=abs(measurements(i,4)-measurements(i,2));
    end;
end

%% Select Final frontal view depth and color image
if(method==1)
%     area2=measurements(:,2);
    measurements(:,2)=smooth(measurements(:,2),0.05,'moving');
%         figure(20);
%     plot(1:1:tamanho,measurements(:,2),'o-');
%     hold;
    valormedio=mean(measurements(:,2));
%     arraymedio=zeros(tamanho);
%     arraymedio(:)=valormedio;
%     plot(1:1:tamanho,arraymedio);
%         figure(21);
else
    area3=smooth(measurements(:,3),0.1,'moving');
    plot(1:1:tamanho,area3,'bo-');
    hold;
    plot(1:1:tamanho,measurements(:,4),'g');
    plot(1:1:tamanho,area2,'r');
    valormedio2=mean(area3);
    arraymedio2=zeros(tamanho);
    arraymedio2(:)=valormedio2;
    plot(1:1:tamanho,arraymedio2);
end;
if(method==1)
    %1st method - 1st turn
    poslatesq=1;
    for i=1: tamanho
       if(measurements(i,2)>valormedio)
           poslatesq=i;
           break;
       end
    end
    str=names{1,1}{poslatesq,1};
    letfResult=imread(strcat(s1,str));
    imwrite(letfResult,'Results\cleft1.png');
    if(code==2)
        imwrite(imread(strcat(s1,names{1,2}{poslatesq,1})),'Results\dright1.png');
    else
        imwrite(imread(strcat(s1,names{1,2}{poslatesq,1})),'Results\dleft1.png');
    end
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
           poslatdir=i-3;
           break;
       end
    end
    str=names{1,1}{poslatdir,1};
    rightResult=imread(strcat(s1,str));
    imwrite(rightResult,'Results\cright1.png');
    if(code==2)
        imwrite(imread(strcat(s1,names{1,2}{poslatdir,1})),'Results\dleft1.png');
    else
        imwrite(imread(strcat(s1,names{1,2}{poslatdir,1})),'Results\dright1.png');
    end
    %     str=names{1,2}{poslatdir,1};
    %     img=imread(strcat(s1,str));
    %     img2=uint8(img./8);
    %     img3 = nonUniform(img2,8,4);
    %     figure(25);
    %     imshow(img3);
    %     figure(55);
    %     stem(imhist(img3));
    posfrontal=floor(((poslatdir)+(poslatesq))/2);
    str=names{1,1}{posfrontal,1};
        frontalResult=imread(strcat(s1,str));
    imwrite(frontalResult,'Results\cfrontal1.png');
    imwrite(imread(strcat(s1,names{1,2}{posfrontal,1})),'Results\dfrontal1.png');
    %     str=names{1,2}{posfrontal,1};
    %     img=imread(strcat(s1,str));
    %     img2=uint8(img./8);
    %     img3 = nonUniform(img2,8,4);
    %     figure(27);
    %     imshow(img3);
    %     figure(57);
    %     stem(imhist(img3));
    if(plotOption==1)
            figure(22);
        imshow(letfResult);
            figure(24);
        imshow(rightResult);
            figure(26);
        imshow(frontalResult);
    end;
    if(code==1)
        %1st method - 2nd turn
        poslatesq=1;
        for i=tamanho:-1:1
           if(measurements(i,2)>valormedio)
               poslatesq=i;
               break;
           end
        end
        str=names{1,1}{poslatesq,1};
        letfResult=imread(strcat(s1,str));
        imwrite(letfResult,'Results\cleft2.png');
        imwrite(imread(strcat(s1,names{1,2}{poslatesq,1})),'Results\dleft2.png');
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
        rightResult=imread(strcat(s1,str));
        imwrite(rightResult,'Results\cright2.png');
        imwrite(imread(strcat(s1,names{1,2}{poslatdir,1})),'Results\dright2.png');
        posfrontal=floor(((poslatdir)+(poslatesq))/2);
        str=names{1,1}{posfrontal,1};
        frontalResult=imread(strcat(s1,str));
        imwrite(frontalResult,'Results\cfrontal2.png');
        imwrite(imread(strcat(s1,names{1,2}{posfrontal,1})),'Results\dfrontal2.png');
        if(plotOption==1)
                figure(30);
            imshow(letfResult);
                figure(31);
            imshow(rightResult);
                figure(32);
            imshow(frontalResult);
        end;
    end;
else
    %%
    % Get data for 2nd method
%         figure(33);
%     plot(1:1:tamanho,centros(:,3));
%     hold
%     area4=smooth(centros(:,3),0.1,'moving');
%     plot(1:1:tamanho,area4,'r');
% 
%     [maxtab, mintab]=peakdet(area4, 10);
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
end;
toc