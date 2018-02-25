function TechIndex = TechIndex(Contract, ModelParams)
    
    %% 1.初始化   
    % 取值
    TIName = ModelParams.TIName;
    TIParams = ModelParams.TIParams;
    ss = length(TIName);
    %
    ind = regexp(Contract,'\D');
    Commodity = Contract(ind);
    % 设置路径
    DataPath = ['..\00_DataBase\MarketData\DayData\',Commodity,'\byContract\'];

    % 生成句柄
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