clc
clear
close all

se = strel('disk',2);
%% Get Depth Image File
[filename, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Pick an image file',...
                'D:\INESC\DadosTese\');
                      
img1=imread([pathname,filename]);
%% Remove Bottom
[M,N]=size(img1);
img2=uint8(img1./8);   
imgnovo=im2bw(img2,graythresh(img2));
img4=uint8(times(double(img2),~imgnovo)+(imgnovo*255));

img3=img1;
img3(img4(:,:)==255)=0;

cont=double(zeros(M,1));
img6=~imgnovo;
for i=1:M
    for j=1:N
        if(img6(i,j)==1)
            cont(i)=cont(i)+1;
        end;
    end
end
mode1='peaks';
dim=1;
npts=round(640*0.15);
[Vo1,Io1] = pickpeaks(cont,npts,dim,mode1);
for i=1:M
    if(cont(i)>0.5*Vo1(1))
        lineA=i;
        break;
    end
end

linhaimgA=img3(lineA,1:N);
for i=1:N
    if(linhaimgA(i)~=0)
        pos1=i;
        break;
    end
end
for i=N:-1:1
    if(linhaimgA(i)~=0)
        pos2=i;
        break;
    end
end
CMi=round((pos1+pos2)/2);
m=mean(img3(lineA,(CMi-10):(CMi+10)));


nkernel = zeros(21,1);
nkernel(1)=-1;
nkernel(21)=1;
C = conv2(img3,nkernel);
candidates2d = (C.*(C<-20).*(C>-100))<0;

candidates2d(img3(:,:)>m)=0;

candidates = sum(candidates2d,2);
Bcandidates=candidates(lineA:240);
[maxC,maxI] = max(Bcandidates);

figure(1)
subplot(1,3,1);
imshow(img3,[])
hold on
[m,n] = size(img3);
yy = [maxI maxI];
xx = [1 n-1];
plot(xx,yy)
subplot(1,3,2);
imshow(candidates2d,[])
subplot(1,3,3);
tempcandidates = repmat(candidates,1,n);
imshow(tempcandidates,[])

lineB=maxI(1)+lineA;
% lineB=lineB+20;

figure(2)
subplot(2,3,1);
img4 = zeros(m,n);
img4(1:lineB,:)=img3(1:lineB,:);

img10=img1;
img10(lineB:end,:)=65535;



img7=img3;
img10=removeArms(img10,img4,imgnovo,lineB,lineA,img7);
figure(3)
imshow(img10);
imwrite(img10,[pathname,'dfrontal_Seg_Reg.png']);

%% Full frontal
img4=uint8(times(double(img2),~imgnovo)+(imgnovo*255));
img3=img1;
img3(img4(:,:)==255)=0;

img10=removeArms(img1,double(img3),imgnovo,lineB,lineA,img7);
figure(4)
imshow(img10);
imwrite(img10,[pathname,'dfrontal_Seg_Full.png']);
lineA=lineA+10;
%% Get Depth Image File
close all;
[filename, pathname2] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Pick an Left pose image file',...
                pathname);
                      
img1=imread([pathname2,filename]);
figure(1)
imshow(img1);
%% Segment with lineA + lineB
imgS=uint8(img1./8);   
imgnovo=im2bw(imgS,graythresh(imgS));
img4=uint8(times(double(imgS),~imgnovo)+(imgnovo*255));
img5=uint8((-1*double(img4))+255);
img2=img1;
img2(imgnovo(:,:)==1)=65535;
figure(2)
imshow(img2,[]);
img2(1:lineA+10,:)=65535;
img2(lineB+10:end,:)=65535;
figure(3);
imshow(img2,[]);
imgnovo=~imgnovo;
imgnovo(1:lineA+10,:)=0;
imgnovo(lineB+10:end,:)=0;
figure(70)
imshow(imgnovo);
CM=regionprops(imdilate(imgnovo,se),'Centroid');

%% remove arm

imgS=uint8(img2./8);   
imgnovo=im2bw(imgS,graythresh(imgS));
img4=uint8(times(double(imgS),~imgnovo)+(imgnovo*255));
img3=double(img2);
img3(img4(:,:)==255)=0;


% img4=img3(1:lineB,:);
% 
% img4 = medfilt2(img4);
% figure(7);
% imshow(img4,[]);
% img5=img4;
% img5(img5 == 0) = inf;
% [minC,minI] = min(img5(:));
% maskmin = img4.*(img4==minC);
% [xxm,yym]=find(maskmin);
% figure(8);
% imshow(maskmin,[]);
% 
% xxd=min(xxm(:));
% yyd=min(yym(:));
a=floor(CM(1).Centroid);
xxd=a(2);
yyd=a(1);

nkernel = zeros(1,7);
nkernel(1)=1;
nkernel(7)=-1;
dd = conv2(img3,nkernel);
[m,n] = size(dd);
right = zeros(m,n);
% right(:,1:yym(1)) = dd(:,1:yym(1));
right(:,yyd:n) = dd(:,yyd:n);
figure(90);
imshow(right,[]);
% rightmask = (right.*(right>0))>80;
rightmask = ((right.*(right>-200))-((right.*(right>-40)).*(right<40)))~=0;
figure(91);
imshow(rightmask,[]);
%%
se = strel('disk',3);
rightmask=imdilate(rightmask,se);
figure(10);
imshow(rightmask,[]);
for i=yyd:n
    if(rightmask(lineB-10,i)==1)
        pontod1=i;
        break;
    end
end
J2=regiongrowing(rightmask,lineB-10,pontod1);
figure(11);
imshow(J2,[]);
stats2=regionprops(J2,'Extrema');
cantosuperiorDireito=[stats2.Extrema(1,1),stats2.Extrema(1,2)];
cnt2=zeros(M,1);
for i=1:m
    for j=n:-1:1
       pos=j;
       if(J2(i,j)==1)
           break;
       end
    end
    cnt2(i)=pos-1;
end
img10=img1;
for i=1:m
    if(cnt2(i)~=0)
        img10(i,cnt2(i)-10:end)=65535;
    end
end
inicio1=round(cantosuperiorDireito(2));
inicio2=round(cantosuperiorDireito(1));
for j=inicio2:N
    for i=inicio1:round(cantosuperiorDireito(2))
        img10(i,j)=65535;
    end
    if(inicio1>lineA)
        inicio1=inicio1-1;
    end
end
img10(imgnovo()==1)=65535;

img2=img10;
figure()
imshow(img2,[]);

a = double (img2);
a(a==a(1))= nan;
amx = max(a(:));
a = a/amx;
figure(29);
imshow(a,[]);

se = strel('disk',2);
img2=imdilate(img2,se);

imwrite(img2,[pathname,'dleft_Seg_Reg.png']);
%% Get Depth Image File
close all;
[filename, pathname2] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Pick an Right pose image file',...
                pathname);
                      
img1=imread([pathname2,filename]);
%%
imgS=uint8(img1./8);   
imgnovo=im2bw(imgS,graythresh(imgS));
img4=uint8(times(double(imgS),~imgnovo)+(imgnovo*255));
img5=uint8((-1*double(img4))+255);
img2=img1;

img2(imgnovo(:,:)==1)=65535;

img2(1:lineA+10,:)=65535;
img2(lineB+10:end,:)=65535;
figure()
imshow(img2);
imgnovo=~imgnovo;
imgnovo(1:lineA+10,:)=0;
imgnovo(lineB+10:end,:)=0;
CM=regionprops(imdilate(imgnovo,se),'Centroid');

%% remove arm

imgS=uint8(img2./8);   
imgnovo=im2bw(imgS,graythresh(imgS));
img4=uint8(times(double(imgS),~imgnovo)+(imgnovo*255));
img3=double(img2);
img3(img4(:,:)==255)=0;


% img4=img3(1:lineB,:);
% 
% img4 = medfilt2(img4);
% figure(7);
% imshow(img4,[]);
% img5=img4;
% img5(img5 == 0) = inf;
% [minC,minI] = min(img5(:));
% maskmin = img4.*(img4==minC);
% [xxm,yym]=find(maskmin);
% figure(8);
% imshow(maskmin,[]);
% 
% xxd=min(xxm(:));
% yyd=min(yym(:));
a=floor(CM(1).Centroid);
xxd=a(2);
yyd=a(1);

nkernel = zeros(1,7);
nkernel(1)=1;
nkernel(7)=-1;
dd = conv2(img3,nkernel);
[m,n] = size(dd);
right = zeros(m,n);
% right(:,yym(1):n) = dd(:,yym(1):n);
right(:,1:yyd) = dd(:,1:yyd);
figure(90);
imshow(right,[]);
% rightmask = (right.*(right>0))>80;
rightmask = ((right.*(right>-200))-((right.*(right>-40)).*(right<40)))~=0;
figure(91);
imshow(rightmask,[]);
%%
se = strel('disk',3);
rightmask=imdilate(rightmask,se);
figure(10);
imshow(rightmask,[]);

for i=yyd:-1:1
    if(rightmask(lineB-10,i)==1)
        pontod2=i;
        break;
    end
end
J1=regiongrowing(rightmask,lineB-10,pontod2);
figure(11);
imshow(J1,[]);
stats1=regionprops(J1,'Extrema');
cantosuperiorEsquerdo=[stats1.Extrema(1,1),stats1.Extrema(1,2)];
cnt1=zeros(M,1);
for i=1:m
    for j=1:n
       pos=j;
       if(J1(i,j)==1)
           break;
       end
    end
    cnt1(i)=pos-1;
end
img10=img1;
for i=1:m
    if(cnt1(i)~=645)
        img10(i,1:cnt1(i))=65535;
    end
end
inicio1=round(cantosuperiorEsquerdo(2));
inicio2=round(cantosuperiorEsquerdo(1));
for j=inicio2:-1:1
    for i=inicio1:round(cantosuperiorEsquerdo(2))
        img10(i,j)=65535;
    end
    if(inicio1>lineA)
        inicio1=inicio1-1;
    end
end
img10(imgnovo()==1)=65535;

img2=img10;
figure()
imshow(img2,[]);

a = double (img2);
a(a==a(1))= nan;
amx = max(a(:));
a = a/amx;
figure(29);
imshow(a,[]);

se = strel('disk',2);
img2=imdilate(img2,se);

imwrite(img2,[pathname,'dright_Seg_Reg.png']);