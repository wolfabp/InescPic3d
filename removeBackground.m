function [result] = removeBackground(pathname,filename,finalName)
    pc=plyToMatSO(pathname, filename);
    pc1=pc;
    %% Remove Background
    zz=pc1(:,3);
    [~,idx]=min(zz);
    a=max(zz);
    zzi=zz(1:idx)/a;
    level = graythresh(zzi);
    level = level*a;
    tamanho=size(pc,1);
    novo=zeros(size(pc));
    cnt2=0;
    for i=1:tamanho
        if(pc1(i,3)<level)
            novo(cnt2+1,:)=pc1(i,:);
            cnt2=cnt2+1; 
        end;
    end;
    pc1=novo;

    %% Create Files
    %result=writePly(pathname,[finalName,'old.ply'],pc,tamanho);
    result=writePly(pathname,[finalName,'.ply'],pc1,cnt2);


end