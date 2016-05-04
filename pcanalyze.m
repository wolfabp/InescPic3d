

[filename, pathname] = uigetfile({            'All Files (*.*)'}, ...
                'Pick an point cloud file',...
                'D:\INESC\DadosTese\');
            
            
            
ptCloud = pcread([pathname,filename]);
pcshow(ptCloud);