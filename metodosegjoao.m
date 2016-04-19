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

nkernel = zeros(21,1);
nkernel(1)=-1;
nkernel(21)=1;
C = conv2(img3,nkernel);
candidates2d = (C.*(C<-20).*(C>-100))<0;
candidates = sum(candidates2d,2);
Bcandidates=candidates(1:240);
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

lineB=maxI(1);
% lineB=lineB+20;

figure(2)
subplot(2,3,1);
img4 = zeros(m,n);
img4(1:lineB,:)=img3(1:lineB,:);

img10=img1;
img10(lineB:end,:)=65535;

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
[filename, pathname2] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Pick an Left pose image file',...
                pathname);
                      
img1=imread([pathname2,filename]);
figure()
imshow(img1);

imgS=uint8(img1./8);   
imgnovo=im2bw(imgS,graythresh(imgS));
img4=uint8(times(double(imgS),~imgnovo)+(imgnovo*255));
img5=uint8((-1*double(img4))+255);
img2=img1;
img2(imgnovo(:,:)==1)=65535;
figure()
imshow(img2);
img2(1:lineA+10,:)=65535;
img2(lineB+10:end,:)=65535;
figure();
imshow(img2);
imgnovo=~imgnovo;
imgnovo(1:lineA+10,:)=0;
imgnovo(lineB+10:end,:)=0;

figure();
imshow(imgnovo);

cnt=zeros(N,1);

for j=1:N
    for i=M:-1:1
       if(imgnovo(i,j)==1)
           cnt(j)=i;
           break;
       end
    end
end

figure()
plot(cnt);
hold on;
maximo=max(cnt);

h=fspecial('gaussian',[1 100],1);
cont2=imfilter(cnt,h');
plot(cont2,'r');
hold off;

[Vo1,Io1] = pickpeaks(cont2,npts,dim,'troughs');
if(size(Io1,1)>0)
    if(Vo1(1)/maximo<0.8 && Vo1(1)/maximo>0.4)
        img2(:,floor(Io1(1)):N)=65535;
    else
        if(size(Io1,1)>1 && (Vo1(2)/maximo<0.8) && (Vo1(2)/maximo>0.4))
            img2(:,floor(Io1(2)):N)=65535;
        end
    end
end
figure()
imshow(img2);

a = double (img2);
a(a==a(1))= nan;
amx = max(a(:));
a = a/amx;
figure(29);
imshow(a,[]);

img2=imdilate(img2,se);

imwrite(img2,[pathname,'dleft_Seg_Reg.png']);
%% Get Depth Image File
[filename, pathname2] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Pick an Right pose image file',...
                pathname);
                      
img1=imread([pathname2,filename]);

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

cnt=zeros(N,1);
for j=1:N
    for i=M:-1:1
       if(imgnovo(i,j)==1)
           cnt(j)=i;
           break;
       end
    end
end

% figure(1)
% plot(cnt)
maximo=max(cnt);
h=fspecial('gaussian',[1 100],1);
cont2=imfilter(cnt,h');
% figure(2)
% plot(cont2);
[Vo1,Io1] = pickpeaks(cont2,npts,dim,'troughs');
if(size(Io1(:))>0)
    if(Vo1(1)/maximo<0.8)
        img2(:,1:floor(Io1(1)))=65535;
    end
end

a = double (img2);
a(a==a(1))= nan;
amx = max(a(:));
a = a/amx;
figure(30);
imshow(a,[]);

img2=imdilate(img2,se);

imwrite(img2,[pathname,'dright_Seg_Reg.png']);


