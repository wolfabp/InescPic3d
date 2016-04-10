function [id]=getID(name)
    k1=strfind(name,'_');
    id=str2num(name(k1(size(k1,2)-6)-4:k1(size(k1,2)-6)-1));
end