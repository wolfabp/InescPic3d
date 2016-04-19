clc;
clear;
close all;
tic
%% Options
plotOption=0;
writeOutput=0;
plotFlag=false;
%% Get Depth Image File
[filename, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Pick an image file',...
                'D:\INESC\DadosTese\');
            

if(writeOutput==1)
    prompt = 'Patient ID? ';
    str = input(prompt,'s');
end

ficheiro=strcat(pathname,filename);
img1= imread(ficheiro);
[M,N]=size(img1);
imagens=zeros(M,N,3);
imagens(1:M,1:N,1)=img1;

%% Get Projections
imgS=uint8(imagens(:,:,1)./8);   
imgnovo=im2bw(imgS,graythresh(imgS));
img4=uint8(times(double(imgS),~imgnovo)+(imgnovo*255));
img5=uint8((-1*double(img4))+255);
%     imgInv=~imgnovo;
%     I=double(img4);
%     [IDX, C] = kmeans(I(:),5);
%     J=reshape(IDX,size(img4));
%     f=uint8(round(C(J(:,:))));

%% Histogram Adjustment
%     minimo=min(img14(:));
%     img15=img14-minimo;
%     maximo=max(img15(:));
%     In= img15 == maximo;
%     img15(In)=NaN;
%     maximo=max(img15(:));
%     fator=255.0/maximo;
%     imgf=img15.*fator;
%% Kmeans 4 class
%     I=double(imgf);
%     [IDX2, C2] = kmeans(I(:),4);
%     J2=reshape(IDX2,size(imgf));
%     f2=uint8(round(C2(J2(:,:))));


%% Mean Shift
%     novo=reshape(img14,1,numel(img14));
%     xx=1:M;
%     xx=repmat(xx,N,1);
%     xx=reshape(xx,1,numel(xx));
%     xx=double(xx)/480;
%     yy=1:M;
%     yy=repmat(yy,1,N);
%     yy=reshape(yy,1,numel(yy));
%     yy=double(yy)/640;
%     novo=double(novo)/255;
%     A=[yy;xx;novo];
%     idx=find(novo~=1);
%     B=A(:,idx);
%     B=B./repmat(max(B,[],2),1,size(B,2));
%     [clustCent,data2cluster,cluster2dataCell] = myMeanShiftCluster(B,0.01, plotFlag,[0.8 0.8 1],[]);
%     novo1=clustCent(data2cluster(:));
%     novo=zeros(1,numel(img14));
%     novo(idx)=novo1;
%     novo=reshape(novo,size(img14));
%     figure()
%     imshow(uint8(novo*255));

%%   

if(plotOption==1)
    figure();
    imshow(imgS);
    figure();
    imshow(imgnovo);
    figure();
    imshow(img4);
    figure();
    imshow(img5);
%     figure();
%     imshow(imgInv);
%     figure()
%     imshow(J,[]);
%     figure();
%     imshow(f);
%     title(' K mean results');
%     figure();
%     stem(imhist(f));
%     title(' K mean f results Histogram');
%     figure();
%     imshow(imgf);
%     title('8bit version of the Depth image with intensity values adjustment');
%     figure();
%     imshow(f2);
%     title('K-mean Clustering result');
%     figure();
%     stem(imhist(f2));
%     title(' K mean f2 results Histogram');
    hold on
end;
%% Calculate projections for the rows
cont=double(zeros(M,1));
img6=~imgnovo;
for i=1:M
    for j=1:N
            if(img6(i,j)==1)
                cont(i)=cont(i)+1;
            end;
    end
end
w=1;
if(w==1)
    pose='_frontal';
else
    if(w==2)
        pose='_left';
    else
        pose='_right';
    end
end
h=fspecial('gaussian',[1 100],10);
cont2=imfilter(cont,h');
a=max(cont2);
b=a/640;
cont1=cont2./b;

figure(1);
h1=imshow(img4);
titulo=strcat('Projection of depth image:\',pose);
title(titulo);
hold on
plot(cont1,1:1:M);
hold off
if(writeOutput==1)
    pose1=strcat(pose,'.png');
    saveas(h1,strcat('Results\',strcat(str,pose1)));
end;


%% Analyze projection
figure(2);
plot(cont1);
tamanho=size(cont1,1);

mode1='peaks';
mode2='troughs';
dim=1;
npts=round(tamanho*0.15);
[Vo1,Io1] = pickpeaks(cont1,npts,dim,mode1);
if(size(Io1,1)>3)
    [Vo1,Io1] = pickpeaks(cont1(1:240),npts,dim,mode1);
end
[Vo2,Io2] = pickpeaks(cont1(Io1(1):Io1(2)),npts,dim,mode2);
[Vo3,Io3] = pickpeaks(cont1(Io1(2):end),npts,dim,mode2);

lineB=Io2(1)+Io1(1);
imgf=img1;
lineB=round(lineB*1.15);

for i=lineB:M
    for j=1:N
        imgf(i,j)=65535;
    end;
end;
for i=1:lineB
    for j=1:N
        if(imgnovo(i,j)==1)
            imgf(i,j)=65535;
        end
    end;
end;

%%
cont=double(zeros(N,1));
for j=1:N
    for i=1:lineB
       cont(j)=cont(j)+double(img5(i,j));
    end
end
h=fspecial('gaussian',[1 100],10);
cont2=imfilter(cont,h');
a=max(cont2);
b=a/640;
cont1=cont2./b;
figure(4)
plot(1:1:N,cont1);


[Vo2,Io2] = pickpeaks(cont1,npts,dim,mode2);
pontoC=min(Io2());
pontoD=max(Io2());

imgf1=imgf;
for i=1:lineB
    for j=1:pontoC
        imgf(i,j)=65535;
    end;
end;
for i=1:lineB
    for j=pontoD:N
        imgf(i,j)=65535;
    end;
end;
figure(5);
imshow(imgf);

%% Get Canny Edges + Dilate
BW1 = edge(imgf1,'Canny',[0.0 0.05],'vertical');
BW2 = imdilate(BW1,strel('disk',3));
[M,N]=size(BW1);

if(plotOption==1)
    figure(13)
    imshow(BW1);
    figure(14)
    imshow(BW2);
end;
img10=img1;

%% Analyze Right Side, get 2nd edge
cnt1=zeros(M,1);
pos=N;
for i=1:M
    for j=N:-1:1
       if(BW2(i,j)==1)
           pos=j;
           break;
       end
    end
    for j=pos:-1:1
       if(BW2(i,j)==0)
           pos=j;
           break;
       end
    end
    for j=pos:-1:1
       if(BW2(i,j)==1)
           pos=j;
           break;
       end
    end
    for j=pos:-1:1
       if(BW2(i,j)==0)
           pos=j;
           break;
       end
    end
    cnt1(i)=pos;
end

%% Analyze Left Side, get 2nd edge
cnt2=zeros(M,1);
for i=1:M
    for j=1:N
       if(BW2(i,j)==1)
           pos=j;
           break;
       end
    end
    for j=pos:N
       if(BW2(i,j)==0)
           pos=j;
           break;
       end
    end
    for j=pos:N
       if(BW2(i,j)==1)
           pos=j;
           break;
       end
    end
    for j=pos:N
       if(BW2(i,j)==0)
           pos=j;
           break;
       end
    end
    cnt2(i)=pos;
end

%% Erase Right Side
for i=1:M
    for j=N:-1:cnt1(i)
        img10(i,j)=65535;
    end
end

%% Erase Left Side
for i=1:M
    for j=1:cnt2(i)
        img10(i,j)=65535;
    end
end


%% Get region of insterest
img2=uint8(img10./8);
imgnovo=im2bw(img2,graythresh(img2));
img14=uint8(times(double(img2),~imgnovo)+(imgnovo*255));
img3=nonUniform(img14,8,7);

for i=1:M
    for j=1:N
        if(img4(i,j)==255)
            img3(i,j)=255;
        end
    end
end
if(plotOption==1)
    figure(15);
    imshow(img10); %result
    figure(16)
    imshow(img2);   
    figure(17);
    imshow(img3);
end;
[img7] = getBestRegion(img3);
%Fix top values
cont=0;
for u=1:M
    cont=0;
    for v=1:N
        if(img7(u,v)==255)
            cont=cont+1;
        end
    end
    if(cont<50)
        for v=1:N
            img7(u,v)=0;
        end
    else
        break;
    end
end

% Segmentating the region of interest and put any other value invalid
img11=img10;
for u=1:M
    for v=1:N
        if(img7(u,v)==255)
            img11(u,v)=img10(u,v);
        else
            img11(u,v)=65535;
        end
    end
end

if(plotOption==1)
    figure(18);
    imshow(img4);
    figure(19);
    imshow(img11);
end;

%% Get top right and left points of segmented region
posX1=0;
posY1=0;
flag=0;
for u=1:M
    for v=1:N
        if(img11(u,v)~=65535)
            posX1=u;
            posY1=v;
            flag=1;
            break;
        end;
    end;
    if(flag==1) 
        break;
    end;
end;
posX2=0;
posY2=0;
flag=0;
for i=1:M
    for j=N:-1:1
        if(img11(i,j)~=65535)
            posX2=i;
            posY2=j;
            flag=1;
            break;
        end;
    end;
    if(flag==1) 
        break;
    end;
end;

%% Get segment above breast's area
segment=img1(1:posX1,posY1:posY2);
media=mean(segment);
for i=1:posX1
    for j=posY1:posY2
        if(~(img1(i,j)>(media+500)))
            img11(i,j)=img1(i,j);
        end
    end
end
%% Remove Lines of pixels from top until full line of close pixels
tamlinha=(posY2-posY1)+1;
for i=1:posX1
    counter=0;
    for j=posY1:posY2
        if(~(img11(i,j)==65535))
            counter=counter+1;
        end
    end
    if(counter==tamlinha)
        break;
    end
end
for u=1:i
    for v=posY1:posY2
        img11(u,v)=65535;
    end
end

lineA=i;

figure(20);
imshow(img11);

se = strel('disk',3);
img11=imdilate(img11,se);

imwrite(img11,[pathname,'dfrontal_Seg_Reg.png']);


%% %%
%% Get bottom right and left points of segmented region
posX1=0;
posY1=0;
flag=0;
for u=M:-1:1
    for v=1:N
        if(img11(u,v)~=65535)
            posX1=u;
            posY1=v;
            flag=1;
            break;
        end
    end
    if(flag==1) 
        break;
    end
end
posX2=0;
posY2=0;
flag=0;
for i=M:-1:1
    for j=N:-1:1
        if(img11(i,j)~=65535)
            posX2=i;
            posY2=j;
            flag=1;
            break;
        end
    end
    if(flag==1) 
        break;
    end
end

lineB=posX1;

%% Get Lat ESQUERDA Depth Image File 
[filename, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Pick an image file',...
                'D:\INESC\DadosTese\');
            
ficheiro=strcat(pathname,filename);
img1= imread(ficheiro);

imgS=uint8(img1./8);   
imgnovo=im2bw(imgS,graythresh(imgS));
img4=uint8(times(double(imgS),~imgnovo)+(imgnovo*255));
img5=uint8((-1*double(img4))+255);

%%
figure(1);
imshow(img4);
figure(2)
imshow(img5);
figure(3)
imshow(imgnovo);
img2=img1;
img2(imgnovo(:,:)==1)=65535;
figure(4);
imshow(img2);

img2(round(lineB*1.2):end,:)=65535;
img2(1:round(lineA*1.5),:)=65535;

img3=img2;
img3(img3(:,:)==65535)=nan;
figure(5);
imshow(img2);

cont=double(zeros(N,1));
for j=1:N
    for i=1:M
       cont(j)=cont(j)+double(img3(i,j));
    end
end


h=fspecial('gaussian',[1 100],10);
cont2=imfilter(cont,h');

figure();
plot(cont2);

dim=1;
npts=round(tamanho*0.15);
[Vo1,Io1] = pickpeaks(cont2,npts,dim,'troughs');

img2(:,round(Io1(1)*0.97):end)=65535;

figure();
imshow(img2);

se = strel('disk',3);
img2=imdilate(img2,se);

imwrite(img2,[pathname,'dleft_Seg_Reg.png']);

%% Get Lat DIREITA Depth Image File 
[filename, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Pick an image file',...
                'D:\INESC\DadosTese\');
            
ficheiro=strcat(pathname,filename);
img1= imread(ficheiro);

imgS=uint8(img1./8);   
imgnovo=im2bw(imgS,graythresh(imgS));
img4=uint8(times(double(imgS),~imgnovo)+(imgnovo*255));
img5=uint8((-1*double(img4))+255);

%% Segment
figure(1);
imshow(img4);
figure(2)
imshow(img5);
figure(3)
imshow(imgnovo);
img2=img1;
img2(imgnovo(:,:)==1)=65535;
figure(4);
imshow(img2);

img2(round(lineB*1.2):end,:)=65535;
img2(1:round(lineA*1.5),:)=65535;

img3=img2;
img3(img3(:,:)==65535)=nan;
figure(5);
imshow(img2);

cont=double(zeros(N,1));
for j=1:N
    for i=1:M
       cont(j)=cont(j)+double(img3(i,j));
    end
end


h=fspecial('gaussian',[1 100],10);
cont2=imfilter(cont,h');

figure();
plot(cont2);

dim=1;
npts=round(tamanho*0.15);
[Vo1,Io1] = pickpeaks(cont2,npts,dim,'troughs');

img2(:,1:round(Io1(1)*1.03))=65535;

figure();
imshow(img2);
se = strel('disk',3);
img2=imdilate(img2,se);

imwrite(img2,[pathname,'dright_Seg_Reg.png']);




toc
