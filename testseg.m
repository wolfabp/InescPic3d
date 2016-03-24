clc;
clear;
close all;
tic
%%
[filename, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Pick an image file',...
                'C:\Users\António Pintor\Desktop\');
            
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


BW1 = edge(img14,'Canny',[0.0 0.05],'vertical',1.4);
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

%%
%Analyze Left Side
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
ficheiro=strcat(pathname,'seg.png');  
imwrite(img11,ficheiro);

figure(18);
imshow(img4);
figure(19);
imshow(img11);


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
        end
    end
    if(flag==1) 
        break;
    end
end
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
        end
    end
    if(flag==1) 
        break;
    end
end


segment=img1(1:posX1,posY1:posY2);
media=mean(segment);

for i=1:posX1
    for j=posY1:posY2
        if(~(img1(i,j)>(media+500)))
            img11(i,j)=img1(i,j);
        end
    end
end
ficheiro=strcat(pathname,'seg2.png');  
imwrite(img11,ficheiro);
figure(20);
imshow(img11);

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
ficheiro=strcat(pathname,'seg3.png');  
imwrite(img11,ficheiro);
figure(21);
imshow(img11);


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


for u=posX2-15:posX2
    for v=1:N
        img11(u,v)=65535;
    end
end

ficheiro=strcat(pathname,'seg4.png');  
imwrite(img11,ficheiro);
figure(22);
imshow(img11);

toc