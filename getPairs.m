function [result] = getPairs(str)
%% Get Files names
MyDirInfo = dir(str);
fieldname='name';
pos=3;
filenames= cell(max(size(MyDirInfo))-2,1);
maximo=max(size(MyDirInfo));
while(1)
    if(pos>maximo)
        break;
    end;
    filenames{pos-2}=[MyDirInfo(pos).(fieldname)];
    pos=pos+1;
end;

%% Separate Color and Depth files names
pos=1;
ColorFilesNames= cell(max(size(filenames)),1);
DepthFilesNames= cell(max(size(filenames)),1);
posColor=1;
posDepth=1;
maximo=max(size(filenames));
while(1)
    if(pos>maximo)
        break;
    end;
    k = strfind(filenames{pos}, 'Color');
    if(size(k)>0)
        ColorFilesNames{posColor}=filenames{pos};
        posColor=posColor+1;
    end;
    k = strfind(filenames{pos}, 'Depth');
    if(size(k)>0)
        DepthFilesNames{posDepth}=filenames{pos};
        posDepth=posDepth+1;
    end;
    pos=pos+1;
end;

%% Match Color and Depth files names

% tamanho=min(posDepth-1,posColor-1);
flagFound=0;
fileID = fopen(strcat(str,'DataMatchNames.txt'),'w');
oldposdeth=3000;
tamanhoC=max(size(ColorFilesNames));
tamanhoD= max(size(DepthFilesNames));
for posColor=1 : tamanhoC
    tempoColor=getTime(ColorFilesNames{posColor});
    if(tempoColor==-1)
        break;
    end;
    
    minimoDiff=100000;
    minpos=1;
    for posDepth=1 : tamanhoD
        
        tempoDepth=getTime(DepthFilesNames{posDepth});
        if(tempoDepth==-1)
            break;
        end;
        diff=abs(tempoColor-tempoDepth);
        if(diff>70 && tempoColor<tempoDepth)
            break;
        end;
        if(minimoDiff>abs(diff))
            minimoDiff=abs(diff);
            minpos=posDepth;
        end
    end
        
    if(minimoDiff<=60 && oldposdeth~=minpos)
        flagFound=1;
    end
    oldposdeth=minpos;
    posDepth=minpos;
    
    if(flagFound==1)
        fprintf(fileID,'%s %s\r\n',ColorFilesNames{posColor},DepthFilesNames{posDepth});
        flagFound=0;
    end
    
end;

fclose(fileID);
result=1;

end