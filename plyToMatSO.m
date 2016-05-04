function [pc] = plyToMatSO(pathname,filename)
    filename = [pathname,filename] ;
    idx = 1;
    fid = fopen(filename, 'r');
    a=fgets(fid);
    flag=1;
    while isempty(strfind(a, 'end_header'))
        idx = idx + 1;
        a=fgets(fid);
        if(strfind(a, 'INESC'))
            flag=0;
        end
    end
    fclose(fid);
    data = textread(filename, '%s','delimiter', '\n');
    data = data(idx+1:length(data)-flag,1);
    data = (cellfun(@(x) strread(x,'%s','delimiter',' '), data, 'UniformOutput', false));
    if isempty(data{length(data)-flag})
        data(length(data)-flag)=[];
    end
    pc = str2double([data{:}].');
    pc = pc(:,1:6);
end