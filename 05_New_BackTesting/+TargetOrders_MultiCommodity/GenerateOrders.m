function Orders = GenerateOrders(CommodityList, ModelParams)
%%  多个商品回测
% 1.CommodityList 多个商品名称的元胞数组
% 2.ModelParams 详见initial_ModelParams

    %% 1. 初始化
    % 初始化变量
    GV = TargetOrders_MultiCommodity.Object.GlobalVar(CommodityList); 
    % 确定交易日期
    TrdDate = GV.TrdDate;
    StartDate = ModelParams(1).StartDate; EndDate = ModelParams(1).EndDate;
    DateList = TrdDate((TrdDate(:,1)>= StartDate & TrdDate(:,1)<= EndDate),1);
    % 提取日期与主力合约对应的map文件    
    MCContainerList = GV.MCContainerList;
    load('MultiplierMap.mat')
    
    %% 2. 按日期计算/载入指标、生成订单    
    % 指标值存储在 DataBase 的技术指标库中
    DataPath = ['..\00_DataBase\TechIndex\',ModelParams(1).TrsType,'\'];
    
    for iDate = 1:length(DateList)
        if iDate == 6
            disp(num2str(iDate));
        end
        Date = DateList(iDate);
        % 计算所有指标 
        TechIndex_List = TargetOrders_MultiCommodity.Generate.DailyTIs( Date, CommodityList, ModelParams, DataPath, MCContainerList );
        if isempty(TechIndex_List)
            continue;
        end        
        % 指标汇总成信号
        MultiSignal = TargetOrders_MultiCommodity.Generate.Signal(TechIndex_List, ModelParams);  
        % 生成该日期订单
        DailyOrders = TargetOrders_MultiCommodity.Generate.DailyOrders(MultiSignal, Date, MCContainerList, MultiplierMap, ModelParams);
        % 合并订单
        Orders_Raw{iDate} = DailyOrders;        
    end
       
    %% 3. 生成最终订单
    Orders = TargetOrders_MultiCommodity.Generate.Orders(Orders_Raw, DateList, ModelParams);
    % 储存订单
    SavePath = ['..\05_New_BackTesting\Evaluation\',ModelParams(1).ModelName,'\',ModelParams(1).TrsType,'\'];
    for itemp = 1:length(ModelParams)
       SavePath = [SavePath,ModelParams(itemp).FileName]; 
    end
    SavePath = [SavePath,'\'];
    for itemp = 1:length(CommodityList)
       Commodity = CommodityList{itemp}; 
       SavePath = [SavePath,Commodity]; 
    end    
    
    if ~isdir(SavePath)
        mkdir(SavePath);
    end
    save( [SavePath,'\Orders.mat'], 'Orders' );

end