function GenerateSignals( CommodityList, SignalPath, ModelParams )
%   生成所有品种在相应时间内的最终指标值, 并存储在相应位置

%   对每个品种生成相应的最终指标值
    for iCommodity = 1:length(CommodityList)
        Commodity = CommodityList{iCommodity};    
        if exist([SignalPath,Commodity,'.mat'])
            continue
        end
        GenerateCommoditySignal( Commodity, SignalPath, ModelParams )
    end

end

function GenerateCommoditySignal( Commodity, SignalPath, ModelParams )
%   计算该品种最终指标值, 并储存

    %% 0. 初始化   
    GV = Signal.Object.GlobalVar(Commodity);    
    % 提取主力合约列表和存续期
    [MainContractList, MCDuration] = Signal.Execute.MCDetail(GV.MainContract);
    % 起始日期
    StartDate = ModelParams(1).StartDate; EndDate = ModelParams(1).EndDate;     

    %% 1. 按合约计算指标
    % 合约指标值存储在 DataBase 的技术指标库中
    DataPath = ['..\00_DataBase\TechIndex\',ModelParams(1).TrsType,'\',Commodity, '\']; 
    MultiSignal = [];
    
    for iMC = 1:length(MainContractList)
        % 该合约尚未达到起始日期 
        if MCDuration(iMC,2)<StartDate || MCDuration(iMC,1)>EndDate
            continue;
        end
        Contract = MainContractList{iMC};
        % 计算所有指标
        TechIndex_List = Signal.Execute.TIs( Contract, ModelParams, DataPath );
        if isempty(TechIndex_List)
            continue;
        end        
        % 指标汇总成信号
        MultiSignal_Contract = Signal.Execute.Signal(TechIndex_List, MCDuration(iMC,:), ModelParams);  
        % 按合约拼接成商品的总信号
        MultiSignal(end+1:end+size(MultiSignal_Contract,1),:) = MultiSignal_Contract; 
    end
    
    %% 2. 储存指标
    
    if ~isdir(SignalPath)
        mkdir(SignalPath);
    end
    save([SignalPath,Commodity,'.mat'],'MultiSignal');
    
end