function [imOut1,imOut2] = getLatSeg(nome,plotOption,writeOut)
tic
%% Options
code=1;
%% Get Depth Image File
% [filename, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
%                 '*.*',                   'All Files (*.*)'}, ...
%                 'Pick an image file',...
%                 'C:\Users\António Pintor\Desktop\');
% ficheiro=strcat(pathname,filename);   

pathname='C:\Users\António Pintor\Documents\MATLAB\INESC\InescPic3d\Results\';
ficheiro=strcat(pathname,nome);
original= imread(ficheiro);
[M,N]=size(original);

if(strfind(nome,'left')>0)
    original = flip(original ,2);  
    code=2;
end
if(plotOption==1)
    figure();
    imshow(original);
    title('Original Depth image');
end
%% Get 8bit version and segment from the background
img2=uint8(original./8);   
imgnovo=im2bw(img2,graythresh(img2));
img4=uint8(times(double(img2),~imgnovo)+(imgnovo*255));

%% Get Regions of interest

%intensity values adjustment
minimo=min(img4(:));
img15=img4-minimo;
maximo=max(img15(:));
In= img15 == maximo;
img15(In)=NaN;
maximo=max(img15(:));
fator=255.0/maximo;
imgf=img15.*fator;

img3=nonUniform(img4,8,4);
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
% v;
    I=double(img4);
    [IDX, C] = kmeans(I(:),7);
    J=reshape(IDX,[M,N]);
    f=uint8(round(C(J(:,:))));
    
    figure(123);
    imshow(f);
    
nreg = input('How many regions you wish to keep? ');
close 123;
regs=round(sort(C));
img5=img4;
for i=1:M
    for j=N:-1:1
        
        a=f(i,j)==regs(1:nreg);
        
        if(find(a(:)>0))
            break;
        else
            img5(i,j)=255;
        end

    end
end


if(plotOption==1)
    figure();
    imshow(img2);
    title('8bit version of the Depth image');
    figure()
    imshow(img3);
    title('K-mean Clustering result after background removal');
    figure();
    stem(r,counts);
    title('Histogram of the K-mean Clustering result');
    figure();
    imshow(img4);
    title('Regions of interest');
    figure();
    imshow(img5);
    title('Half body of interest');
%     figure();
%     [counts,r] = imhist(img4);
%     stem(r,counts);
%     figure();
%     [counts,r] = imhist(img15);
%     stem(r,counts);
    figure();
    imshow(imgf);
    title('8bit version of the Depth image with intensity values adjustment');
    figure();
    imgt=nonUniform(imgf,8,5);
    imshow(imgt);
    title('K-mean Clustering result');
    for i=1:M
        for j=1:N
            if(img4(i,j)==255)
                imgt(i,j)=255;
            end
        end
    end
    figure();
    imshow(imgt);
    title('Regions of interest with background removal');
%     [counts,r] = imhist(imgf);
%     stem(r,counts);
end

%% Get Canny Edges + Dilate
BW1 = edge(img4,'Canny',[0.0 0.05],'vertical');
BW2 = imdilate(BW1,strel('disk',3));
if(plotOption==1)
    figure()
    imshow(BW1);
    title('Canny Method for edge detection Results');
    figure()
    imshow(BW2);
    title('Dilation after Canny Method Results');
end;
img10=img4;


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

%% Erase Left Side
for i=1:M
    for j=1:cnt2(i)
        img10(i,j)=65535;
    end
end


%% Get region of insterest
img3=nonUniform(img10,8,7);
if(plotOption==1)
    figure();
    imshow(img10); %result
    title('Left side removed until 2nd edge detected');
    figure();
    imshow(img3);
    title('K-mean Clustering');
end;
[regiao] = getBestRegion(img3);
%Fix top values
for u=1:M
    cont=0;
    for v=1:N
        if(regiao(u,v)==255)
            cont=cont+1;
        end
    end
    if(cont<50)
        for v=1:N
            regiao(u,v)=0;
        end
    else
        break;
    end
end

% Segmentating the region of interest and put any other value invalid
img11=img10;
% for u=1:M
%     for v=1:N
%         if(~(regiao(u,v)==255))
%             img11(u,v)=255;
%         end
%     end
% end
img11(regiao(:,:)~=255)=255;
if(plotOption==1)
    figure();
    imshow(regiao);
    title('Best Region result binary image');
    figure();
    imshow(img11);
    title('Best Region result 8bit depth image');
end;


%% Get bottom right and left points of segmented region 
% posX1=0;
% posY1=0;
flag=0;
for u=M:-1:1
    for v=1:N
        if(img11(u,v)~=255)
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
% posY2=0;
flag=0;
for i=M:-1:1
    for j=N:-1:1
        if(img11(i,j)~=255)
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

%% Get final depth image to write and return region and half
imOut1=original;
imOut2=original;
if(plotOption==1)
    figure();
    imshow(img11);
    title('Best Region 8bit depth image after bottom lines removal');
    figure();
    imshow(img12);
    title('Best Half body Region 8bit depth image');
end;
for u=1:M
    for v=1:N
        if(img11(u,v)==255)
            imOut1(u,v)=65535;
        end
        if(img5(u,v)==255)
            imOut2(u,v)=65535;
        end
    end
end

%% Save to new depth png image file
if(code==1)
    ficheiro =strcat(pathname,'segRegionRight.png');  
    ficheiro2=strcat(pathname,'segHalfRight.png'  );  
else
    ficheiro =strcat(pathname,'segRegionLeft.png' );  
    ficheiro2=strcat(pathname,'segHalfLeft.png'   ); 
    imOut1 = flip(imOut1 ,2);  
    imOut2 = flip(imOut2 ,2);  
    img11  = flip(img11  ,2);  
    img5   = flip(img5   ,2);  
end
if(writeOut==1)
    imwrite(imOut1,ficheiro);
    imwrite(imOut2,ficheiro2);
end
if(plotOption==1)
    figure();
    imshow(imOut1);
    figure();
    imshow(imOut2);
end;

imOut1=img11;
imOut2=img5;
toc
end