function DataMap = get_DataMap(obj, CommodityList)
%%  提取指标值

    % 指标存储位置
    SignalPath = obj.SignalPath;
    
    ModelParams = obj.ModelParams;    
    EndDate = ModelParams(1).EndDate;
    % 初始化列表, 提取RB.mat以获得矩阵大小
    load([SignalPath,'RB.mat']) 
    DataMap = zeros(size(MultiSignal,1),length(CommodityList)+1);
    DataMap(:,end) =  MultiSignal(:,1);
        
    % 遍历所有品种CommodityList   
    for iCommodityList = 1:length(CommodityList)
        Commodity = CommodityList{iCommodityList};
        % 如果未生成该品种指标值, 跳过默认为0
        if ~exist([SignalPath,Commodity,'.mat'])
            continue
        end
        load([SignalPath,Commodity,'.mat'])
        % 有些品种缺某些时间的值
        DeltaSize = size(DataMap,1)-size(MultiSignal,1);
        if ~DeltaSize 
            DataMap(:,iCommodityList) = MultiSignal(:,end);
        % 缺省值处理
        else
            if MultiSignal(end,1) >= EndDate 
                MultiSignal_temp = MultiSignal(:,end);
                DataMap(:,iCommodityList) = [zeros(DeltaSize,1);MultiSignal_temp];
            else
                MultiSignal_temp = MultiSignal(:,end);             
                DataMap(:,iCommodityList) = [MultiSignal_temp;zeros(DeltaSize,1)];
            end
        end
    end

    
end