function [result] = getTime(str)
    if(strfind(str,'Patient')>0)
        k = strfind(str, 'Color');
        if(size(k)>0)
            str=str(k(1):max(size(str)));
        else
            k = strfind(str, 'Depth');
            str=str(k(1):max(size(str)));
        end
        k = strfind(str, '_');
        h = str2double(str((k(4)+1): (k(4)+2)));
        m = str2double(str((k(5)+1): (k(5)+2)));
        s = str2double(str((k(6)+1): (k(6)+2)));
        ms =str2double(str((k(7)+1): (k(7)+3)));
        result =(h*60*60*1000)+(m*60*1000)+(s*1000)+ms;
    else
        result=-1;
    end
end