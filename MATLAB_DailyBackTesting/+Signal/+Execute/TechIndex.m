function TechIndex = TechIndex(Contract, ModelParams)
    
    %% 1.��ʼ��   
    % ȡֵ
    TIName = ModelParams.TIName;
    TIParams = ModelParams.TIParams;
    ss = length(TIName);
    %
    ind = regexp(Contract,'\D');
    Commodity = Contract(ind);
    % ����·��
    DataPath = ['..\00_DataBase\MarketData\DayData\',Commodity,'\byContract\'];

    % ���ɾ��
    fhandle = str2func(['Signal.TI.cal_', TIName]);    
    
    %% 2    
    if exist([DataPath, Contract,'.mat'])
        load([DataPath, Contract]);
    else
        TechIndex = [];
        return;
    end
    TechIndex = fhandle(DayData, TIParams);

end