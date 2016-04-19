function [imgOut]= removeArms(img1,img3,imgnovo,lineB,lineA,img7)


[M,N]=size(img1);
img6=img3;
img4=img6(1:lineB,:);
%% Remove Arms
img4 = medfilt2(img4);
% imshow(img4,[])
img5=img4;
img5(img5 == 0) = inf;
[minC,minI] = min(img5(:));
% subplot(2,3,2);
maskmin = img4.*(img4==minC);
[xxm,yym]=find(maskmin);
% imshow(maskmin,[])

xxd=min(xxm(:));
yyd=min(yym(:));

nkernel = zeros(1,7);
nkernel(1)=-1;
nkernel(7)=1;
dd = conv2(img6,nkernel);
ddi = conv2(img7,(nkernel')*-1);
[m,n] = size(dd);
% subplot(2,3,4);
% imshow(ddi,[])

ddi=((ddi.*(ddi>100)).*(ddi<400));
maska=ddi>0;
maska=maska(1:480,:);
% subplot(2,3,5);
% imshow(ddi,[])

left = zeros(m,n);
left(:,1:yym(1)) = dd(:,1:yym(1));
right = zeros(m,n);
right(:,yym(1):n) = dd(:,yym(1):n);

% left=left(:,1:640);
% right=right(:,1:640);
[m,n] = size(right);

% subplot(2,3,3);
leftmask_1 = (left.*(left<0)*(-1))>80;
leftmask_2 = (left.*(left>0).*(left<400))>80;
% leftmask = or((leftmask_1 + leftmask_2),maska);
leftmask = (leftmask_1 + leftmask_2);
% imshow(leftmask,[])
% subplot(2,3,6);
% rightmask = or((right.*(right>0))>80,maska);
rightmask = (right.*(right>0))>80;
% imshow(rightmask,[])

se = strel('disk',4);
rightmask=imdilate(rightmask,se);
leftmask= imdilate(leftmask ,se);

for i=yyd:n
    if(rightmask(xxd,i)==1)
        pontod1=i;
        break;
    end
end

for i=yyd:-1:1
    if(leftmask(xxd,i)==1)
        pontod2=i;
        break;
    end
end

J1=regiongrowing(leftmask,xxd,pontod2);
J2=regiongrowing(rightmask,xxd,pontod1);
stats1=regionprops(J1,'Extrema');
stats2=regionprops(J2,'Extrema');
cantosuperiorEsquerdo=[stats1.Extrema(1,1),stats1.Extrema(1,2)];
cantosuperiorDireito=[stats2.Extrema(1,1),stats2.Extrema(1,2)];
cnt1=zeros(M,1);
for i=1:m
    for j=1:n
       pos=j;
       if(J1(i,j)==1)
           break;
       end
    end
    cnt1(i)=pos-1;
end

cnt2=zeros(M,1);
for i=1:m
    for j=n:-1:1
       pos=j;
       if(J2(i,j)==1)
           break;
       end
    end
    cnt2(i)=pos-1;
end

img10=img1;
img10(1:lineA,:)=65535;
% figure(5)
% imshow(img10);

for i=1:m
    if(cnt1(i)~=645)
        img10(i,1:cnt1(i))=65535;
    end
end


for i=1:m
    if(cnt2(i)~=0)
        img10(i,cnt2(i)-1:end)=65535;
    end
end

% img10(1:cantosuperiorEsquerdo(2),1:cantosuperiorEsquerdo(1))=65535;
inicio1=round(cantosuperiorEsquerdo(2));
inicio2=round(cantosuperiorEsquerdo(1));
for j=inicio2:-1:1
    for i=inicio1:round(cantosuperiorEsquerdo(2))
        img10(i,j)=65535;
    end
    if(inicio1>lineA)
        inicio1=inicio1-1;
    end
end
% img10(1:cantosuperiorDireito(2),cantosuperiorDireito(1):end)=65535;
inicio1=round(cantosuperiorDireito(2));
inicio2=round(cantosuperiorDireito(1));
for j=inicio2:N
    for i=inicio1:round(cantosuperiorDireito(2))
        img10(i,j)=65535;
    end
    if(inicio1>lineA)
        inicio1=inicio1-1;
    end
end
img10(imgnovo()==1)=65535;

% figure(6)
% imshow(img10);

imgOut=img10;

end