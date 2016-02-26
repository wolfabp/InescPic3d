function [result] = getTime(str)
% str
if(strfind(str,'Patient')>0)
    %str
    k = strfind(str, '_');
    h = str2double(str((k(6)+1): (k(6)+2)));
    m = str2double(str((k(7)+1): (k(7)+2)));
    s = str2double(str((k(8)+1): (k(8)+2)));
    ms =str2double(str((k(9)+1): (k(9)+3)));
    result =(h*60*60*1000)+(m*60*1000)+(s*1000)+ms;
    %pause()
else
    result=-1;
end
end