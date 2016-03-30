function [img4] = getBestRegion(img3)

    [counts,r] = imhist(img3);
%     figure(3);
%     stem(r,counts);

    %% get closest region
    a=1;
    for posi=1:256
        if(counts(posi)>0)
            a=posi-1;
            break;
        end
    end
    [M,N]=size(img3);
    img4=zeros(M,N);
    for u=1:M
        for v=1:N
            if(img3(u,v)==a)
                img4(u,v)=255;
            end
        end
    end
    %% label regions
    conn=4;
    [L, num] = bwlabel(img4, conn);
    %% get biggest area in img4
    area=zeros(num);
    for r=1:num
        area(r) = bwarea(L==r);
    end
    area=area(:,1);
    [maxi,I] = max(area);
    img4=zeros(M,N);
    for u=1:M
        for v=1:N
            if(L(u,v)==I)
                img4(u,v)=255;
            end
        end
    end
end