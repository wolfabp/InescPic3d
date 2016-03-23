clc;
clear;
close all;
tic
%%
[filename, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Pick an image file',...
                'D:\INESC\DadosTese\');
            
ficheiro=strcat(pathname,filename);            
img1= imread(ficheiro);
figure(01);
imshow(img1);

img2=uint8(img1./8);
figure(10)
imshow(img2);   
level=graythresh(img2);
imgnovo=im2bw(img2,level);
imgnovo2=imgnovo*255;
imgnovo=~imgnovo;
img14=uint8(times(double(img2),imgnovo)+imgnovo2);

figure(11)
imshow(img14);

img3=nonUniform(img14,8,4);
figure(12)
imshow(img3);


BW1 = edge(img14,'Canny',[0.1 0.2],'vertical',3);
BW2 = imdilate(BW1,strel('disk',3));

[M,N]=size(BW1);
cnt=zeros(M,1);

figure(13)
imshow(BW1);
figure(14)
imshow(BW2);

img10=img1;

for i=1:M
    for j=1:N
        
       if(BW1(i,j)==1)
           cnt(i)=cnt(i)+1;
       end
       
    end
end

%%
%Analyze Right Side
cnt1=zeros(M,1);
pos=N;
for i=1:M
    for j=N:-1:1
       if(BW1(i,j)==1)
           pos=j;
           break;
       end
    end
    for j=pos:-1:1
       if(BW1(i,j)==0)
           pos=j;
           break;
       end
    end
    for j=pos:-1:1
       if(BW1(i,j)==1)
           pos=j;
           break;
       end
    end
    cnt1(i)=pos;
end

%%
%Analyze Left Side
cnt2=zeros(M,1);
for i=1:M
    for j=1:N
       if(BW1(i,j)==1)
           pos=j;
           break;
       end
    end
    for j=pos:N
       if(BW1(i,j)==0)
           pos=j;
           break;
       end
    end
    for j=pos:N
       if(BW1(i,j)==1)
           pos=j;
           break;
       end
    end
    cnt2(i)=pos;
end

%%
%Erase Right Side
for i=1:M
    for j=N:-1:cnt1(i)
        img10(i,j)=65535;
    end
end

%%
%Erase Left Side
for i=1:M
    for j=1:cnt2(i)
        img10(i,j)=65535;
    end
end

figure(15);
imshow(img10);
%%
%FIM
filename=strcat('seg',filename);  
ficheiro=strcat(pathname,filename);  
imwrite(img10,ficheiro);

img2=uint8(img10./8);
figure(16)
imshow(img2);   
level=graythresh(img2);
imgnovo=im2bw(img2,level);
imgnovo2=imgnovo*255;
imgnovo=~imgnovo;
img14=uint8(times(double(img2),imgnovo)+imgnovo2);
img3=nonUniform(img14,8,7);

figure(17);
imshow(img3);
[img4,img5] = getBest2region(img3);

img11=img10;
for u=1:M
    for v=1:N
        if(img4(u,v)==255)
            img11(u,v)=img10(u,v);
        else
            img11(u,v)=65535;
        end
    end
end



% filename=strcat('seg2',filename);  
ficheiro=strcat(pathname,'seg');  
imwrite(img11,ficheiro);

figure(18);
imshow(img4);
figure(19);
imshow(img11);


toc