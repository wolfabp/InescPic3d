clc;
clear;
close all;
tic
%% Options
plotOption=1;
%% Get Depth Image File
% [filename, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
%                 '*.*',                   'All Files (*.*)'}, ...
%                 'Pick an image file',...
%                 'C:\Users\António Pintor\Desktop\');
            
% ficheiro=strcat(pathname,filename);   
ficheiro='C:\Users\António Pintor\Documents\MATLAB\INESC\InescPic3d\Results\dright1.png';
pathname='C:\Users\António Pintor\Documents\MATLAB\INESC\InescPic3d\Results\';
img1= imread(ficheiro);
if(plotOption==1)
    figure(01);
    imshow(img1);
end
%% Get 8bit version and segment from the background
img2=uint8(img1./8);   
imgnovo=im2bw(img2,graythresh(img2));
img14=uint8(times(double(img2),~imgnovo)+(imgnovo*255));

minimo=min(img14(:));
img15=img14-minimo;
maximo=max(img15(:));
In=find(img15 == maximo);
img15(In)=NaN;
maximo=max(img15(:));
fator=255.0/maximo;
imgf=img15.*fator;

img3=nonUniform(img14,8,4);
[counts,r] = imhist(img3);
v=0;
regions=zeros(4,1);
for i=256:-1:1
    if(counts(i)~=0)
        if(v<5)
            regions(v+1)=i-1;
        end;
        v=v+1;
    end
end
v
[M,N]=size(img3);
for i=1:M
    for j=N:-1:1
        if(img3(i,j)==regions(1) || img3(i,j)==regions(2) || img3(i,j)==regions(3))
            img14(i,j)=255;
        else if(img3(i,j)==255)
        else
             break; 
            end
        end
    end
end


if(plotOption==1)
    figure(10);
    imshow(img2);
    figure(11);
    imshow(img14);
    figure(12)
    imshow(img3);
    figure(73);
    stem(r,counts);
    
%     figure(70);
%     [counts,r] = imhist(img14);
%     stem(r,counts);
%     figure(71);
%     [counts,r] = imhist(img15);
%     stem(r,counts);
    figure(72);
    imshow(imgf);
    figure(74);
    imgt=nonUniform(imgf,8,5);
    imshow(imgt);
    
    
    for i=1:M
        for j=1:N
            if(img14(i,j)==255)
                imgt(i,j)=255;
            end
        end
    end
    figure(75);
    imshow(imgt);
    
    
%     [counts,r] = imhist(imgf);
%     stem(r,counts);
    
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
img10=img14;
% cnt=zeros(M,1);
% for i=1:M
%     for j=1:N
%        if(BW1(i,j)==1)
%            cnt(i)=cnt(i)+1;
%        end
%     end
% end

%% Analyze Right Side, get 2nd edge
% cnt1=zeros(M,1);
% pos=N;
% for i=1:M
%     for j=N:-1:1
%        if(BW2(i,j)==1)
%            pos=j;
%            break;
%        end
%     end
%     for j=pos:-1:1
%        if(BW2(i,j)==0)
%            pos=j;
%            break;
%        end
%     end
%     for j=pos:-1:1
%        if(BW2(i,j)==1)
%            pos=j;
%            break;
%        end
%     end
%     for j=pos:-1:1
%        if(BW2(i,j)==0)
%            pos=j;
%            break;
%        end
%     end
%     cnt1(i)=pos;
% end

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
% for i=1:M
%     for j=N:-1:cnt1(i)
%         img10(i,j)=65535;
%     end
% end

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
% posX1=0;
% posY1=0;
% flag=0;
% for u=1:M
%     for v=1:N
%         if(img11(u,v)~=65535)
%             posX1=u;
%             posY1=v;
%             flag=1;
%             break;
%         end
%     end
%     if(flag==1) 
%         break;
%     end
% end
% posX2=0;
% posY2=0;
% flag=0;
% for i=1:M
%     for j=N:-1:1
%         if(img11(i,j)~=65535)
%             posX2=i;
%             posY2=j;
%             flag=1;
%             break;
%         end
%     end
%     if(flag==1) 
%         break;
%     end
% end

%% Get segment above breast's area
% segment=img1(1:posX1,posY1:posY2);
% media=mean(segment);
% for i=1:posX1
%     for j=posY1:posY2
%         if(~(img1(i,j)>(media+500)))
%             img11(i,j)=img1(i,j);
%         end
%     end
% end
% ficheiro=strcat(pathname,'seg2.png');  
% imwrite(img11,ficheiro);
% figure(20);
% imshow(img11);

%% Remove Lines of pixels from top until full line of close pixels
% tamlinha=(posY2-posY1)+1;
% for i=1:posX1
%     counter=0;
%     for j=posY1:posY2
%         if(~(img11(i,j)==65535))
%             counter=counter+1;
%         end
%     end
%     if(counter==tamlinha)
%         break;
%     end
% end
% for u=1:i
%     for v=posY1:posY2
%         img11(u,v)=65535;
%     end
% end
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

if(plotOption==1)
    img18=img1;
    figure(62);
    imshow(img18);
    figure(63);
    imshow(img11);
end;
for u=1:M
    for v=1:N
        if(img11(u,v)==255)
            img18(u,v)=65535;
        end
    end
end

%% Save to new depth png image file
ficheiro=strcat(pathname,'segRegionRight.png');  
imwrite(img18,ficheiro);
if(plotOption==1)
    figure(22);
    imshow(img18);
end;
% %% Get bottom right and left points of segmented region AGAIN
% posX1=0;
% posY1=0;
% flag=0;
% for u=M:-1:1
%     for v=1:N
%         if(img11(u,v)~=65535)
%             posX1=u;
%             posY1=v;
%             flag=1;
%             break;
%         end
%     end
%     if(flag==1) 
%         break;
%     end
% end
% posX2=0;
% posY2=0;
% flag=0;
% for i=M:-1:1
%     for j=N:-1:1
%         if(img11(i,j)~=65535)
%             posX2=i;
%             posY2=j;
%             flag=1;
%             break;
%         end
%     end
%     if(flag==1) 
%         break;
%     end
% end

% %% Segment Bottom Region 1º method
% 
% img12=img11;
% segment=img1(posX1:M,posY1:posY2);
% media=mean(segment);
% for i=posX1:M
%     for j=posY1:posY2
%         if(~(img1(i,j)>(media+500)))
%             img12(i,j)=img1(i,j);
%         end
%     end
% end
% 
% %% Segment Bottom Region 2º method
% 
% img13=img11;
% segment=img1(posX1:M,posY1:posY2);
% media=mean(segment);
% for i=posX1:M
%     for j=1:N
%         if(~(img1(i,j)>(media+500)))
%             img13(i,j)=img1(i,j);
%         end
%     end
% end


%% Save to new depth png image file
% ficheiro=strcat(pathname,'segmentLeft.png');  
% imwrite(img12,ficheiro);
% if(plotOption==1)
%     figure(24);
%     imshow(img12);
% end;

toc