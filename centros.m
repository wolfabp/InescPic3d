 

% centros=zeros(tamanho,3);


    if(method==0)
        measurements(i,4)=s(1).ConvexArea;
        measurements(i,3)=abs(measurements(i,4)-measurements(i,2));
    end;
%     [x,lvle,y,lvld,l,h]=getPos2((~img4)*255);
%     [x2,lvle2,y2,lvld2,l2,h2]=getPos2(img3);
%     
%     centros(i,1)=x+floor((y-x)/2);
%     centros(i,2)=x2+floor((y2-x2)/2);
%     centros(i,3)=abs(centros(i,2)-centros(i,1));




else
    area3=smooth(measurements(:,3),0.1,'moving');
    plot(1:1:tamanho,area3,'bo-');
    hold;
    plot(1:1:tamanho,measurements(:,4),'g');
    plot(1:1:tamanho,area2,'r');
    valormedio2=mean(area3);
    arraymedio2=zeros(tamanho);
    arraymedio2(:)=valormedio2;
    plot(1:1:tamanho,arraymedio2);
end;




%%
    % Get data for 2nd method
%         figure(33);
%     plot(1:1:tamanho,centros(:,3));
%     hold
%     area4=smooth(centros(:,3),0.1,'moving');
%     plot(1:1:tamanho,area4,'r');
% 
%     [maxtab, mintab]=peakdet(area4, 10);
    [maxtab2, mintab2]=peakdet(area3, 500);

    %p1
    for u=1: max(size(maxtab2))
        if(maxtab2(u,2)>=valormedio2)
            p1=maxtab2(u,1);
            break;
        end
    end
    %pm1
    y=0;
    if(mintab2(1,1)>p1 && mintab2(1,2)<valormedio2)
        pm1=mintab2(1,1);
        y=1;
    end
    v=1;
    if(y==0)
        for v=1: max(size(mintab2))
            if(mintab2(v,1)>p1)
                pm1=mintab2(v,1);
                break;
            end
        end
    end
    x=u+1;
    %p2
    for u=x: max(size(maxtab2))
        if(mintab2(v,1)< maxtab2(u,1) && maxtab2(u,2)>=valormedio2)
            p2=maxtab2(u,1);
            break;
        end
    end
    x=v+1;
    %pm2
    y=0;
    for v=x: max(size(mintab2))
        if(mintab2(v,1)>maxtab2(u,1) && mintab2(v,2)<valormedio2)
            pm2=mintab2(v,1);
            y=1;
            break;
        end
    end
    if(y==0)
        for v=x: max(size(mintab2))
            if(mintab2(v,1)>maxtab2(u,1))
                pm2=mintab2(v,1);
                break;
            end
        end
    end
    x=u+1;
    %p3
    for u=x: max(size(maxtab2))
        if(mintab2(v,1)< maxtab2(u,1) && maxtab2(u,2)>=valormedio2)
            p3=maxtab2(u,1);
            break;
        end
    end
    x=v+1;
    %pm3
    y=0;
    for v=x: max(size(mintab2))
        if(mintab2(v,1)>maxtab2(u,1) && mintab2(v,2)<valormedio2)
            pm3=mintab2(v,1);
            y=1;
            break;
        end
    end
    if(y==0)
        for v=x: max(size(mintab2))
            if(mintab2(v,1)>maxtab2(u,1))
                pm3=mintab2(v,1);
                break;
            end
        end
    end


    %2nd Method - 1st turn
    imagemesquerda1=round((1+pm1)/2);
    imagemdireita1=round((pm2+pm1)/2);
    imagemfrontal1=pm1;
        figure(40);
    str=names{1,1}{imagemesquerda1,1};
    imshow(imread(strcat(s1,str)));
        figure(41);
    str=names{1,1}{imagemdireita1,1};
    imshow(imread(strcat(s1,str)));
        figure(42);
    str=names{1,1}{imagemfrontal1,1};
    imshow(imread(strcat(s1,str)));


    %2nd Method - 2nd turn
    imagemdireita2=round((pm2+pm3)/2);
    imagemesquerda2=round((pm3+tamanho)/2);
    imagemfrontal2=pm3;
        figure(43);
    str=names{1,1}{imagemdireita2,1};
    imshow(imread(strcat(s1,str)));
        figure(44);
    str=names{1,1}{imagemesquerda2,1};
    imshow(imread(strcat(s1,str)));
        figure(45);
    str=names{1,1}{imagemfrontal2,1};
    imshow(imread(strcat(s1,str)));