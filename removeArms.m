function [imgOut]= removeArms(img1,img3,imgnovo,lineB,lineA)


[M,N]=size(img1);
img4=img3(1:lineB,:);
%% Remove Arms
img4 = medfilt2(img4);
img5=img4;
img5(img5 == 0) = inf;
[minC,minI] = min(img5(:));
maskmin = img4.*(img4==minC);
[xxm,yym]=find(maskmin);
% imshow(maskmin,[])

xxd=min(xxm(:));
yyd=min(yym(:));

nkernel = zeros(1,7);
nkernel(1)=-1;
nkernel(7)=1;
dd = conv2(img3,nkernel);
[m,n] = size(dd);
left = zeros(m,n);
left(:,1:yym(1)) = dd(:,1:yym(1));
right = zeros(m,n);
right(:,yym(1):n) = dd(:,yym(1):n);

[m,n] = size(right);

leftmask_1 = (left.*(left<0)*(-1))>80;
leftmask_3 = (left.*(left>0).*(left<400))>40;
lefthand=(leftmask_1 + leftmask_3)>0;
lefthand(1:lineB,:)=0;
leftmask_3(lineB:end,:)=0;
leftmask = (leftmask_1 + leftmask_3)>0;
% leftmask = leftmask(:,:)>0;
figure(1)
imshow(dd,[]);
figure(2)
imshow(leftmask_3,[]);
figure(3)
imshow(lefthand,[]);

rightmask = (right.*(right>0))>80;
rightmask_3 = (right.*(right<0).*(right>-400))<-40;
lefthand=(leftmask_1 + leftmask_3)>0;
lefthand(1:lineB,:)=0;
rightmask_3(lineB:end,:)=0;
rightmask = (rightmask + rightmask_3);
rightmask = rightmask(:,:)>0;

se = strel('disk',4);
rightmask=imdilate(rightmask,se);
leftmask =imdilate(leftmask ,se);
%% Find Best Edges
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

%% Delete Arms pixels
img10=img1;
img10(1:lineA,:)=65535;

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
%% Remove Corners
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
imgOut=img10;

end