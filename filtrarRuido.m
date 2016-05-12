function [result] = filtrarRuido(pathname,filename,finalname,original)
    %% options
     plotOption=0;
    %% Read image
    img1=imread([pathname,filename]);
    [M,N]=size(img1);
    %% Get binary image
    imgnovo=im2bw(img1,graythresh(img1));       
    %% Get Background limit
    imgOrig=imread([pathname,original]);
    imgOrig(imgOrig(:)==65535)=nan;
    a=double(max(imgOrig(:)));
    b=double(imgOrig);
    zzi=b./a;
    level=graythresh(zzi);
    levelOrig = level*a;
    %% Plot inputs
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
    %% Make sure to remove Background
    imgOut=img1;
    imgOut(imgOut(:)>levelOrig)=65535;
    if(plotOption==1)
        figure(4);
        a = double(imgOut);
        a(a==a(1))= nan;
        amx = max(a(:));
        a = a/amx;
        imshow(a,[]);
    end
    %% Average Filter
    h = fspecial('average', [5 5]);
    k = imfilter(imgOut, h);
    imgOut=k;
    imgOut(M-2:M,:)=img1(M-2:M,:);
    if(plotOption==1)
        figure(5);
        imshow(imgOut,[]);
        figure(51);
        a = double (imgOut);
        a(a==a(1))= nan;
        amx = max(a(:));
        a = a/amx;
        imshow(a,[]);
    end
    %% Mask
    imgOut(imgnovo(:,:)==1)=65535;
    if(plotOption==1)
        figure(6);
        imshow(imgOut,[]);
        figure(61);
        a = double (imgOut);
        a(a==a(1))= nan;
        amx = max(a(:));
        a = a/amx;
        imshow(a,[]);
    end
    %% Median Filter    
%     k = medfilt2(imgOut);
%     imgOut=k;
%     if(plotOption==1)
%         figure(7);
%         imshow(imgOut,[]);
%         figure(71);
%         a = double (imgOut);
%         a(a==a(1))= nan;
%         amx = max(a(:));
%         a = a/amx;
%         imshow(a,[]);
%     end
%     %% Mask
%     imgOut(imgnovo(:,:)==1)=65535;
%     if(plotOption==1)
%         figure(8);
%         imshow(imgOut,[]);
%         figure(81);
%         a = double (imgOut);
%         a(a==a(1))= nan;
%         amx = max(a(:));
%         a = a/amx;
%         imshow(a,[]);
%     end
    %% Remove Background again
    imgOut(imgOut(:)>levelOrig)=65535;
    if(plotOption==1)
        figure(9);
        imshow(imgOut,[]);
        figure(91);
        a = double (imgOut);
        a(a==a(1))= nan;
        amx = max(a(:));
        a = a/amx;
        imshow(a,[]);
    end
    %% Apply Opening
    se = strel('disk',5);  
    imgOut=uint16(imopen(double(imgOut),se));
    if(plotOption==1)
        figure(11);
        imshow(imgOut,[]);
        imshow(imgOut,[]);
        figure(111);
        a = double (imgOut);
        a(a==a(1))= nan;
        amx = max(a(:));
        a = a/amx;
        imshow(a,[]);
    end
%% Print Out
    imwrite(imgOut,[pathname,finalname]);
    result=1;
end