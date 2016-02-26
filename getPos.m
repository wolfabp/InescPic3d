function [posEsq,lvlEsq,posDir,lvlDir, w, h] = getPos(str)

img=imread(str);
[X, Y]=size(img);
w=X;
h=Y;
maximo=max(max(img));
for j=1 : Y
    for i=1 : X
        if(maximo==img(i,j))
            img(i,j)=2047;
        end
    end
end
level=graythresh(img);
img3=im2bw(img,level);
img3=logical(((1+double(img3))*-1)+2);
proj=zeros(Y);
for j=1 : Y
    total=0;
    for i=1 : X
        total=double(double(total)+double(img3(i,j)));
    end
    proj(j)=total;
end
posEsq=0;
for i=1 : Y
    if(proj(i)>0)
        posEsq=i;
        break;
    end
end
posDir=0;
for i=Y: -1 :1
    if(proj(i)>0)
        posDir=i;
        break;
    end
end

lvlEsq=min(img(:,posEsq));
lvlDir=min(img(:,posDir));


end