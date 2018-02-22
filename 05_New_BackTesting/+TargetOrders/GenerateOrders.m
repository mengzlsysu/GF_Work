function Orders = GenerateOrders(Commodity, ModelParams)
%%  单个商品回测
% 1.Commodity 商品名称
% 2.ModelParams 详见initial_ModelParams

    %% 1. 初始化
    % 初始化变量
    GV = TargetOrders.Object.GlobalVar(Commodity); 
    load('MultiplierMap.mat')
    % 提取主力合约列表和存续期
    [MainContractList, MCDuration] = TargetOrders.Cal.MCDetail(GV.MainContract);

    %% 2. 按合约计算/载入指标、生成订单    
    % 指标值存储在 DataBase 的技术指标库中
    DataPath = ['..\00_DataBase\TechIndex\',ModelParams(1).TrsType,'\',Commodity, '\']; 

    for iMC = 1:length(MainContractList)
        Contract = MainContractList{iMC};
        % 调取合约乘数
        Mltp = MultiplierMap(Contract);        
        % 计算所有指标
        TechIndex_List = TargetOrders.Generate.TIs( Contract, ModelParams, DataPath );
        if isempty(TechIndex_List)
            continue;
        end        
        % 指标汇总成信号
        MultiSignal = TargetOrders.Generate.Signal(TechIndex_List, ModelParams);
        % 生成该合约订单
        ContractOrders = TargetOrders.Generate.ContractOrders(MultiSignal, MCDuration(iMC,:), Contract, Mltp, ModelParams);
        % 合并订单
        Orders_Raw{iMC} = ContractOrders;
    end
    
    %% 3. 生成最终订单
    Orders = TargetOrders.Generate.Orders(Orders_Raw, MCDuration, ModelParams);
    % 储存订单
    SavePath = ['..\05_New_BackTesting\Evaluation\',ModelParams(1).ModelName,'\',ModelParams(1).TrsType,'\'];
    for itemp = 1:length(ModelParams)
       SavePath = [SavePath,ModelParams(itemp).FileName]; 
    end
    SavePath = [SavePath,'\',Commodity];
    if ~isdir(SavePath)
        mkdir(SavePath);
    end
    save( [SavePath,'\Orders.mat'], 'Orders' );

end