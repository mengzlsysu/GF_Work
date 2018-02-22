function display2_Commodity(dirPath)
    if ~exist([dirPath, '\Kpi.mat'], 'file') || ~exist([dirPath, 'Nav.mat'], 'file')
        disp(['目录:', dirPath, '下无Kpi & Nav文件.']);
        return;
    end
    load([dirPath, '\Kpi.mat']);    %读取变量 Kpi
    load([dirPath, '\Nav.mat']);   %读取变量 Nav
    Stats.display_Commodity(Kpi, Nav);
end