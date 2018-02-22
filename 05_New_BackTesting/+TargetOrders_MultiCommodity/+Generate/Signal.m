function MultiSignal = Signal( TechIndex_List, ModelParams )
%   根据所有指标值, 计算综合MultiSignal
%   MultiSignal{1}:  1: Date 2: Time 3-end: 各品种Close
%   MultiSignal{2}:  1: Date 2: Time 3-end: 各品种最终信号值
    
    % 技术指标数/商品数
    Commodity_Num = length(TechIndex_List);
    
    % 初始化
    MultiSignal{1} = TechIndex_List{1}{1}(:,1:2); MultiSignal{2} = MultiSignal{1};

    %% 1. 针对每个品种, 将多技术指标生成该品种最终信号, 例子: 信号汇总以各指标取符号加总
    
    % 多技术指标生成信号的计算方法
    TI2Signal = ModelParams(1).TI2Signal;
    
    for iCommodity = 1:Commodity_Num
        % 生成句柄
        fhandle = str2func(['TargetOrders_MultiCommodity.Cal.Signal.cal_', TI2Signal]);  
        MultiSignal_Commodity = fhandle(TechIndex_List{iCommodity});
        MultiSignal{2} = [MultiSignal{2},MultiSignal_Commodity(:,4)];
        MultiSignal{1} = [MultiSignal{1},TechIndex_List{iCommodity}{1}(:,3)];
    end

    %% 2. 针对各个品种的指标值, 筛选出进行操作的品种, 例子: 筛选选出信号最大的做多, 信号最小的做空, 其余不动
    
    Signal2Commodity = ModelParams(1).Signal2Commodity;
    
    % 生成句柄
    fhandle = str2func(['TargetOrders_MultiCommodity.Cal.Commodity.cal_', Signal2Commodity]); 
    MultiSignal{2} = fhandle(MultiSignal{2});
    
end

