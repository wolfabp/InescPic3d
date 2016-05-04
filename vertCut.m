function [result] = vertCut(pathname,filename,finalName,cm1)
    %% Get point Cloud
    pc=plyToMatSO(pathname, filename);
    %% See what pose it is
    if(finalName(1)=='R')
        flag=1;
    else
        flag=2;
    end
    %% Cut
    tamanho=size(pc,1);
    novo=zeros(size(pc));
    cnt1=0;
    for i=1:tamanho
        if(pc(i,1)>=cm1 && flag==1)
            novo(cnt1+1,:)=pc(i,:);
            cnt1=cnt1+1; 
        else
            if(pc(i,1)<cm1 && flag==2)
                novo(cnt1+1,:)=pc(i,:);
                cnt1=cnt1+1; 
            end;
        end;
    end;
    pc1=novo;
    %% Remove Background
    zz=pc1(:,3);
    [~,idx]=min(zz);
    a=max(zz);
    zzi=zz(1:idx)/a;
    level = graythresh(zzi);
    level = level*a;
    novo=zeros(size(pc));
    cnt2=0;
    for i=1:cnt1
        if(pc1(i,3)<level)
            novo(cnt2+1,:)=pc1(i,:);
            cnt2=cnt2+1; 
        end;
    end;
    pc1=novo;

    %% Create Files
    result=writePly(pathname,[finalName,'old.ply'],pc,tamanho);
    result=writePly(pathname,[finalName,'.ply'],pc1,cnt2);
end