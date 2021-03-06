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
        tamanho=max(size(k));
        h = str2double(str(  (k(tamanho-3)+1): (k(tamanho-3)+2)  ));
        m = str2double(str(  (k(tamanho-2)+1): (k(tamanho-2)+2)  ));
        s = str2double(str(  (k(tamanho-1)+1): (k(tamanho-1)+2)  ));
        ms =str2double(str(  (k(tamanho  )+1): (k(tamanho  )+3)  ));
        result =(h*60*60*1000)+(m*60*1000)+(s*1000)+ms;
    else
        result=-1;
    end
end