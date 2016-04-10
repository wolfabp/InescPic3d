clc;
clear;
close all;
tic
%% Options
plotOption=0;
%% Get Depth Image File
% [filename, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
%                 '*.*',                   'All Files (*.*)'}, ...
%                 'Pick an image file',...
%                 'C:\Users\António Pintor\Desktop\');
            
% ficheiro=strcat(pathname,filename);   
ficheiro='C:\Users\António Pintor\Documents\MATLAB\INESC\InescPic3d\Results\dfrontal1.png';
pathname='C:\Users\António Pintor\Documents\MATLAB\INESC\InescPic3d\Results\';
img1= imread(ficheiro);
if(plotOption==1)
    figure(01);
    imshow(img1);
end
%% Get 8bit version
img2=uint8(img1./8);   
imgnovo=im2bw(img2,graythresh(img2));
img14=uint8(times(double(img2),~imgnovo)+(imgnovo*255));
if(plotOption==1)
    figure(10);
    imshow(img2);
    figure(11);
    imshow(img14);
    % img3=nonUniform(img14,8,4);
    % figure(12)
    % imshow(img3);
end;

%% Get Canny Edges + Dilate
BW1 = edge(img14,'Canny',[0.0 0.05],'vertical');
BW2 = imdilate(BW1,strel('disk',3));
[M,N]=size(BW1);
if(plotOption==1)
    figure(13)
    imshow(BW1);
    figure(14)
    imshow(BW2);
end;
img10=img1;
% cnt=zeros(M,1);
% for i=1:M
%     for j=1:N
%        if(BW1(i,j)==1)
%            cnt(i)=cnt(i)+1;
%        end
%     end
% end

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
if(plotOption==1)
    figure(15);
    imshow(img10); %result
    figure(16)
    imshow(img2);   
    figure(17);
    imshow(img3);
end;
[img4] = getBestRegion(img3);
%Fix top values
cont=0;
for u=1:M
    cont=0;
    for v=1:N
        if(img4(u,v)==255)
            cont=cont+1;
        end
    end
    if(cont<50)
        for v=1:N
            img4(u,v)=0;
        end
    else
        break;
    end
end



% Segmentating the region of interest and put any other value invalid
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
% ficheiro=strcat(pathname,'seg.png');  
% imwrite(img11,ficheiro);
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
% ficheiro=strcat(pathname,'seg2.png');  
% imwrite(img11,ficheiro);
% figure(20);
% imshow(img11);

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
% ficheiro=strcat(pathname,'seg3.png');  
% imwrite(img11,ficheiro);
% figure(21);
% imshow(img11);


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

%% Remove Bottom 15 lines with detected points
for u=posX2-15:posX2
    for v=1:N
        img11(u,v)=65535;
    end
end

%% Save to new depth png image file
ficheiro=strcat(pathname,'segRegionFront.png');  
imwrite(img11,ficheiro);
if(plotOption==1)
    figure(22);
    imshow(img11);
end;
%% Get bottom right and left points of segmented region AGAIN
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

%% Segment Bottom Region 1º method

img12=img11;
segment=img1(posX1:M,posY1:posY2);
media=mean(segment);
for i=posX1:M
    for j=posY1:posY2
        if(~(img1(i,j)>(media+500)))
            img12(i,j)=img1(i,j);
        end
    end
end

%% Segment Bottom Region 2º method

img13=img11;
segment=img1(posX1:M,posY1:posY2);
media=mean(segment);
for i=posX1:M
    for j=1:N
        if(~(img1(i,j)>(media+500)))
            img13(i,j)=img1(i,j);
        end
    end
end

% botseg(1:M,1:N)=65535;
% botseg(posX1:M,1:N)=img13(posX1:M,1:N);


%% Find hands
botseg=img13;
botseg(1:posX1,1:N)=65535;
figure(25);
imshow(botseg);
img2=uint8(botseg./8);   
imgnovo=im2bw(img2,graythresh(img2));
img14=uint8(times(double(img2),~imgnovo)+(imgnovo*255));
BW1 = edge(img14,'Canny',[0.0 0.01],0.03);
BW2 = imdilate(BW1,strel('disk',3));
figure(26)
imshow(BW1);
% figure(27)
% imshow(BW2);
% if(plotOption==1)
% end;


%% Save to new depth png image file
ficheiro=strcat(pathname,'segFront.png');  
imwrite(img13,ficheiro);
if(plotOption==1)
    figure(24);
    imshow(img13);
end;

toc