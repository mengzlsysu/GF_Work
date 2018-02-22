function display2_Commodity(dirPath)
    if ~exist([dirPath, '\Kpi.mat'], 'file') || ~exist([dirPath, 'Nav.mat'], 'file')
        disp(['Ŀ¼:', dirPath, '����Kpi & Nav�ļ�.']);
        return;
    end
    load([dirPath, '\Kpi.mat']);    %��ȡ���� Kpi
    load([dirPath, '\Nav.mat']);   %��ȡ���� Nav
    Stats.display_Commodity(Kpi, Nav);
end