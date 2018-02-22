function [TechIndex,MinData] = TechIndex(Contract, ModelParams)
    
    %% 1.��ʼ��   
    % ȡֵ
    TrsType = ModelParams.TrsType;
    TIName = ModelParams.TIName;
    TIParams = ModelParams.TIParams;
    ss = length(TIName);
    %
    ind = regexp(Contract,'\D');
    Commodity = Contract(ind);
    % ����·��
    DataPath = ['..\00_DataBase\MarketData\MinData\ByContract\',Commodity,'\',TrsType,'\'];

    % ���ɾ��
    fhandle = str2func(['TargetOrders.Cal.TI.cal_', TIName]);    
    
    %% 2    
    if exist([DataPath, Contract,'.mat'])
        load([DataPath, Contract]);
    else
        TechIndex = []; MinData = [];
        return;
    end
    TechIndex = fhandle(MinData, TIParams);

end