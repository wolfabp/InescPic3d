function [result] = filtrarRuido(pathname,filename,finalname,original)
    %% options
     plotOption=1;
    %%
    img1=imread([pathname,filename]);
    img2=uint8(img1./8);
    imgnovo=im2bw(img2,graythresh(img2));    
   
    
    imgOrig=imread([pathname,original]);
    imgOrig(imgOrig(:)==65535)=nan;
    a=double(max(imgOrig(:)));
    b=double(imgOrig);
    zzi=b./a;
    level=graythresh(zzi);
    levelOrig = level*a;
    
    [M,N]=size(img1);
    
    
    if(plotOption==1)
        figure(1);
        imshow(img1,[]);
        figure(2);
        imshow(imgnovo);
        a = double (img1);
        a(a==a(1))= nan;
        amx = max(a(:));
        a = a/amx;
        figure(3);
        imshow(a,[]);
    end;
    
    imgOut=img1;
    imgOut(imgOut(:)>levelOrig)=65535;
    %% Average Filter
    h = fspecial('average', [3 3]);
    k = imfilter(imgOut, h);
    imgOut=k;
    %% Mask
    imgOut(imgnovo(:,:)==1)=65535;
    %% Median Filter
    
    figure(10);
    a = double (imgOut);
    a(a==a(1))= nan;
    amx = max(a(:));
    a = a/amx;
    imshow(a,[]);
    
    k = medfilt2(imgOut);
    %% Mask
    
    imgOut=k;
    imgOut(imgnovo(:,:)==1)=65535;
    
    %% Remove Outliers
    
%     a=double(max(imgOut(imgOut~=65535)));
%     b=double(imgOut);
%     zzi=b./a;
%     level = graythresh(zzi);
%     level = level*a;
%     imgOut(imgOut>level)=65535;
%     a=double(max(imgOut(imgOut~=65535)));
%     b=double(imgOut);
%     zzi=b./a;
%     level = graythresh(zzi);
%     level = level*a;
%     imgOut(imgOut>level)=65535;
%     a=double(max(imgOut(imgOut~=65535)));
%     b=double(imgOut);
%     zzi=b./a;
%     level = graythresh(zzi);
%     level = level*a;
%     imgOut(imgOut>level)=65535;
%     s = struct('Scheme','I');
%     
%     
%     
%     imgOut=CoherenceFilter(imgOut,s);
%     imgOut=round(imgOut);
% %     [idxnegh,idxnegv]=(imgOut(:,:)<0);
% %     tamanho=size(idxneg);
% %     for i=1:tamanho
% %         mtx=imgOut(idxnegh(i)-1:idxnegh(i)+1,idxnegv(i)-1:idxnegv(i)+1);
% %         b = ordfilt2(mtx,1,ones(3,3));
% %         imgOut(idxnegh(i),idxnegv(i))=b(2,2);
% %     end
%     
% %     a=double(max(img1(:)));
% %     b=double(img1);
% %     zzi=b./a;
% %     level=graythresh(zzi);
% %     level = level*a
%     
%     imgOut(imgOut(:)<0)=65535;
    imgOut(imgOut(:)>levelOrig)=65535;
%     imgOut = ordfilt2(imgOut,1,ones(3,3));
% % %     imgOut = ordfilt2(imgOut,1,ones(3,3));
% % %     imgOut = ordfilt2(imgOut,1,ones(3,3));
% %     imgOut = medfilt2(imgOut);
% %     imgOut = medfilt2(imgOut);
% %     imgOut = medfilt2(imgOut);
%     imgOut(1:3,:)=65535;
%     imgOut(:,1:3)=65535;
%     imgOut(M-2:M,:)=65535;
%     imgOut(:,N-2:N)=65535;
    
    se = strel('disk',4);
    imgOut=imclose(imgOut,se);
%     
%     dilatedImage = imdilate(imgOut,strel('disk',10));
%     figure(6);
%     imshow(dilatedImage);
%     imgOut = bwmorph(dilatedImage,'thin',inf);
    figure(5);
    imshow(imgOut,[]);
    a = double (imgOut);
    a(a==a(1))= nan;
    amx = max(a(:));
    a = a/amx;
    figure(6);
    imshow(a,[]);
    
    
    
    
    
    
    
%% Print Out
    imwrite(imgOut,[pathname,finalname]);
    
    result=1;
end