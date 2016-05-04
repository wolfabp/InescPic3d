function [result] = writePly(pathname,filename,pc,tamanho)
    fileID = fopen([pathname,filename],'w');
    fprintf(fileID,'%s\r\n','ply');
    fprintf(fileID,'%s\r\n','format ascii 1.0');
    fprintf(fileID,'%s\r\n','comment INESC');
    fprintf(fileID,'%s\r\n',['element vertex ',num2str(tamanho)]);
    fprintf(fileID,'%s\r\n','property float x');
    fprintf(fileID,'%s\r\n','property float y');
    fprintf(fileID,'%s\r\n','property float z');
    fprintf(fileID,'%s\r\n','property uchar red');
    fprintf(fileID,'%s\r\n','property uchar green');
    fprintf(fileID,'%s\r\n','property uchar blue');
    fprintf(fileID,'%s\r\n','end_header');
    for i=1:tamanho-1
        fprintf(fileID,'%1.9f %1.9f %1.9f %d %d %d \r\n',pc(i,1),pc(i,2),pc(i,3),pc(i,4),pc(i,5),pc(i,6));
    end    
    fprintf(fileID,'%1.9f %1.9f %1.9f %d %d %d',pc(i,1),pc(i,2),pc(i,3),pc(i,4),pc(i,5),pc(i,6));
    fclose(fileID);
    result=1;
end