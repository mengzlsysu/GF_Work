function MultiSignal = cal_MaxMin( MultiSignal_Raw )
%   筛选选出信号最大的品种做多, 信号最小的做空, 其余不操作
%   MultiSignal: 1. Date 2. Time 3-end: 各品种对应的最终信号
%   做多&做空的N个品种, 做多信号值为1/N, 做空信号值为-1/N

    % 商品数
    Commodity_Num = size(MultiSignal_Raw,2)-2;
    
    % 初始化
    MultiSignal = zeros(size(MultiSignal_Raw,1),Commodity_Num);  
    
    [~,MaxID] = max(MultiSignal_Raw(:,3:end),[],2);
    [~,MinID] = min(MultiSignal_Raw(:,3:end),[],2);
    
    for itemp = 1:length(MaxID)
       % 指标最大值与最小值相等, 跳过 
       if MaxID(itemp) == MinID(itemp)
           continue
       end
       MultiSignal(itemp,MaxID(itemp)) = 1/2;
       MultiSignal(itemp,MinID(itemp)) = -1/2;
    end
    
    MultiSignal = [MultiSignal_Raw(:,1:2),MultiSignal];
end

