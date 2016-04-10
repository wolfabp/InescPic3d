clc;
clear;
close all;
tic
%% Options
plotOption=1;
writeOutput=0;
plotFlag=false;
%% Get Depth Image File
% [filename, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
%                 '*.*',                   'All Files (*.*)'}, ...
%                 'Pick an image file',...
%                 'D:\INESC\DadosTese\');
%             
% ficheiro=strcat(pathname,filename);
if(writeOutput==1)
    prompt = 'Patient ID? ';
    str = input(prompt,'s');
end
pathname='C:\Users\António Pintor\Documents\MATLAB\INESC\InescPic3d\Results\';
filename='dfrontal1.png';
img1= imread(strcat(pathname,filename));
[M,N]=size(img1);
imagens=zeros(M,N,3);
imagens(1:M,1:N,1)=img1;
% filename='dleft1.png';
% imagens(1:M,1:N,2)= imread(strcat(pathname,filename));
% filename='dright1.png';
% imagens(1:M,1:N,3)= imread(strcat(pathname,filename));

%% Get Projections
for w=1:1
    imgS=uint8(imagens(:,:,w)./8);   
    imgnovo=im2bw(imgS,graythresh(imgS));
    imgInv=~imgnovo;
    img14=uint8(times(double(imgS),~imgnovo)+(imgnovo*255));
    I=double(img14);
    [IDX, C] = kmeans(I(:),5);
    J=reshape(IDX,size(img14));
    f=uint8(round(C(J(:,:))));
    
    
    
    minimo=min(img14(:));
    img15=img14-minimo;
    maximo=max(img15(:));
    In= img15 == maximo;
    img15(In)=NaN;
    maximo=max(img15(:));
    fator=255.0/maximo;
    imgf=img15.*fator;
    
    I=double(imgf);
    [IDX2, C2] = kmeans(I(:),4);
    J2=reshape(IDX2,size(imgf));
    f2=uint8(round(C2(J2(:,:))));
    
    
    %% Mean Shift
    novo=reshape(img14,1,numel(img14));
    xx=1:M;
    xx=repmat(xx,N,1);
    xx=reshape(xx,1,numel(xx));
    xx=double(xx)/480;
    yy=1:M;
    yy=repmat(yy,1,N);
    yy=reshape(yy,1,numel(yy));
    yy=double(yy)/640;
    novo=double(novo)/255;
    A=[yy;xx;novo];
    idx=find(novo~=1);
    B=A(:,idx);
    B=B./repmat(max(B,[],2),1,size(B,2));
    
    [clustCent,data2cluster,cluster2dataCell] = myMeanShiftCluster(B,0.01, plotFlag,[0.8 0.8 1],[]);
    
    novo1=clustCent(data2cluster(:));
    novo=zeros(1,numel(img14));
    novo(idx)=novo1;
    novo=reshape(novo,size(img14));
    figure()
    imshow(uint8(novo*255));
    
 %%   
    
    if(plotOption==1)
%         figure();
%         imshow(imgS);
%         figure();
%         imshow(imgnovo);
%         figure();
%         imshow(img14);
%         figure();
%         imshow(imgInv);
%         figure()
%         imshow(J,[]);
        figure();
        imshow(f);
        title(' K mean results');
        figure();
        stem(imhist(f));
        title(' K mean f results Histogram');
%         figure();
%         imshow(imgf);
%         title('8bit version of the Depth image with intensity values adjustment');
        figure();
        imshow(f2);
        title('K-mean Clustering result');
        figure();
        stem(imhist(f2));
        title(' K mean f2 results Histogram');
        hold on
    end;
%     cont=zeros(N,1);
%     for j=1:N
%         for i=1:M
%             if(imgInv(i,j)==1)
%                 cont(j)=cont(j)+1;
%             end;
%         end
%     end
%     figure();
%     if(w==1)
%         pose='_frontal';
%     else
%         if(w==2)
%             pose='_left';
%         else
%             pose='_right';
%         end
%     end
%     titulo=strcat('Projection of depth image:\',pose);
%     title(titulo);
%     imshow(imgS);
%     hold on
%     h1=plot(1:1:N,cont);
%     cont1=smooth(cont,0.05,'moving');
%     hold off
%     figure();
%     titulo=strcat('Smooth projection of depth image:',pose);
%     title(titulo);
%     h2=plot(N:-1:1,cont1);
    
    if(writeOutput==1)
        pose1=strcat(pose,'.png');
        saveas(h1,strcat('Results\',strcat(str,pose1)));
        pose2=strcat(pose,'_smooth.png');
        saveas(h2,strcat('Results\',strcat(str,pose2)));
    end;
end


