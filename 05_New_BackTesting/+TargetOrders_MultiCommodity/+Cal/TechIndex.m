function [TechIndex,MinData] = TechIndex(Contract, ModelParams)
    
    %% 1.初始化   
    % 取值
    TrsType = ModelParams.TrsType;
    TIName = ModelParams.TIName;
    TIParams = ModelParams.TIParams;
    ss = length(TIName);
    %
    ind = regexp(Contract,'\D');
    Commodity = Contract(ind);
    % 设置路径
    DataPath = ['..\00_DataBase\MarketData\MinData\ByContract\',Commodity,'\',TrsType,'\'];

    % 生成句柄
    fhandle = str2func(['TargetOrders_MultiCommodity.Cal.TI.cal_', TIName]);    
    
    %% 2    
    if exist([DataPath, Contract,'.mat'])
        load([DataPath, Contract]);
    else
        TechIndex = []; MinData = [];
        return;
    end
    TechIndex = fhandle(MinData, TIParams);

end