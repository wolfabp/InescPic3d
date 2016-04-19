clc
clear
close all
%% Get Depth Image File
[filename, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Pick an image file',...
                'D:\INESC\DadosTese\');
                      
img1=imread([pathname,filename]);
%% 

se = strel('disk',1);
[M,N]=size(img1);
img2=uint8(img1./8);   
imgnovo=im2bw(img2,graythresh(img2));
img4=uint8(times(double(img2),~imgnovo)+(imgnovo*255));
% 
% figure(4);
% imshow(img4);
img3=img1;
img3(img4(:,:)==255)=0;
% for u=1:M
%     for v=1:N
%         if(img4(u,v)~=255)
%             img3(u,v)=img1(u,v);
%         else
%             img3(u,v)=0;
%         end
%     end
% end

% figure(1);
% imshow(img1);
% figure(2);
% imshow(uint16(img3));


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

%%
linhaimgA=img3(1,1:N);
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
CM=round((pos1+pos2)/2);
m=mean(img3(lineA,(CM-10):(CM+10)));

%%
maxima=0;
trans=0;
melhora=0;
ponto=0;
candidatos=zeros(240,1);

for i=1:N
    x=img3(1:480,i);
    i
    figure(3);
    plot(x,'b');
    xlim([1 480])
    ylim([600 1300])
    pause(0.05);
    
    for j=lineA+10:240
        if(x(j)<m)
            b=(x(j+10)-x(j-10));
            if(b>20 && b<100)            
               candidatos(j)=1+candidatos(j);            
               if(j>maxima)
                   if(b>trans)
                      melhora=i; 
                      ponto=j;
                   end
               end
            end
        end
    end

end
pause;
[valor,melhor]=max(candidatos);

lineB=melhor+25;
% x=img3(1:480,60);
%     figure(3);
%     plot(x,'b');
%     xlim([1 480])
%     ylim([600 1300])
img3=img1;
img3(1:lineA,:)=65535;
img3(lineB:end,:)=65535;
% figure(5)
% imshow(img4);

% a = double ( img3);
% a(a==a(1))= nan;
% amx = max(a(:));
% a = a/amx;
% figure(26);
% imshow(a,[]);
% 
% 
% a = double ( img1);
% a(a==a(1))= nan;
% amx = max(a(:));
% a = a/amx;
% figure(27);
% imshow(a,[]);

%%
img10=img3;
maxima=100000;
ideal=lineA;

for i=lineA:lineB-1
    x=img3(i,1:640);
%     i
%     figure(3);
%     plot(x,'b');
%     xlim([1 N])
%     ylim([600 1300])
%     pause();

    if(maxima>min(x(:)))
        [maxima, ponto]=min(x(:));
        ideal=i;
    end

end

%%
% figure(11)
% imshow(img3);
x=img1(ideal,1:N);
for i=3:N-3
    if(img1(ideal,i)==65535)
        A=img1(ideal-1:ideal+1,i-1:i+1);
        B = medfilt2(A);
        x(i)=B(2,2);
    end
end

for i=ponto:N
    b=(x(i+1)-x(i-1));
    if(b>100)  
        pos1=i;
        break;
    end;
end;
%%
for i=ponto:-1:1
    b=(x(i-1)-x(i+1));
    if(b>100)  
        pos2=i;
        break;
    end;
end;

img10(:,1:pos2)=65535;
img10(:,pos1:N)=65535;

imgnovo2=~imgnovo;
imgnovo2(:,1:pos2)=0;
imgnovo2(:,pos1:N)=0;
imgnovo2(1:lineA,:)=0;
imgnovo2(lineB:end,:)=0;

cont=double(zeros(N,1));
for j=1:N
    for i=1:M
        if(imgnovo2(i,j)==1)
            cont(j)=cont(j)+1;
        end;
    end;
end;


[Vo1,Io1] = pickpeaks(cont,npts,dim,'troughs');
stateL=0;
stateR=0;
maximo=max(cont);

if(size(Io1)>0)
    if(Vo1(1)/maximo<0.85)
        if(abs(Io1(1)-pos1)>abs(Io1(1)-pos2))
            img10(:,1:Io1(1))=65535;
            stateL=1;
        else
            img10(:,Io1(1):N)=65535;
            stateR=1;
        end
    end
end
if(size(Io1)>1)
    if(Vo1(2)/maximo<0.85)
        if(abs(Io1(2)-pos1)>abs(Io1(2)-pos2))
            if(stateL==0)
                img10(:,1:Io1(2))=65535;
            end
        else
            if(stateR==0)
                img10(:,Io1(2):N)=65535;
            end
        end
    end
end
% 
% figure(10)
% plot(cont);
% imshow(imgnovo2);

a = double (img10);
a(a==a(1))= nan;
amx = max(a(:));
a = a/amx;
figure(28);
imshow(a,[]);

img10(imgnovo(:,:)==1)=65535;
img10=imdilate(img10,se);
imwrite(img10,[pathname,'dfrontal_Seg_Reg.png']);

%% Get Depth Image File
[filename, pathname2] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Pick an Left pose image file',...
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

maximo=max(cnt);

h=fspecial('gaussian',[1 100],1);
cont2=imfilter(cnt,h');

[Vo1,Io1] = pickpeaks(cont2,npts,dim,'troughs');
if(size(Io1(:))>0)
    if(Vo1(1)/maximo<0.8)
        img2(:,floor(Io1(1)):N)=65535;
    end
end

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
