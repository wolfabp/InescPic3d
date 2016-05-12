function [result]=myRemoveBackgroundImg(pathname,filename,finalname)
    imgOrig=imread([pathname,filename]);
    imgOrig(imgOrig(:)==65535)=nan;
    a=double(max(imgOrig(:)));
    b=double(imgOrig);
    zzi=b./a;
    level=graythresh(zzi);
    levelOrig = level*a;
    imgOut=imgOrig;
    imgOut(imgOut(:)>levelOrig)=65535;
    imwrite(imgOut,[pathname,finalname]);
    result=1;
end