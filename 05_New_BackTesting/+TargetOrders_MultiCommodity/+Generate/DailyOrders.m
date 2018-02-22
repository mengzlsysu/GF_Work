function DailyOrders = DailyOrders(MultiSignal, Date, MCContainerList, MultiplierMap, ModelParams)
%   生成该日的订单Orders
%   MultiSignal{1}:  1: Date 2: Time 3-end: 各品种Close
%   MultiSignal{2}:  1: Date 2: Time 3-end: 各品种最终信号值
%   DailyOrders: 1. 时刻 2. 合约 3. 买/卖 4. 0/1 5. 手数

    %% 1.初始化, 预先分配内存提高运算速度
    Capital = 1e8;
    Str = ['买','卖'];
    ss = size(MultiSignal{1}, 1);
    Commodity_Num = size(MultiSignal{1}, 2)-2;
    DailyOrders = cell(2*Commodity_Num*ss,5);
    % 赋值下标
    index = 1;
    
    %% 2. 提取指标
    Signal = MultiSignal{2}(:,3:end);
    
    %% 3. 生成订单
    for iS = 2:size(Signal,1)  
        for iCommodity = 1:Commodity_Num
            Contract = MCContainerList{iCommodity}(Date);
            Multiplier = MultiplierMap(Contract);
            if Signal(iS,iCommodity)-Signal(iS-1,iCommodity) ~= 0
                % 开仓
                if Signal(iS-1,iCommodity) == 0
                    DailyOrders{index, 1} = MultiSignal{1}(iS,1)*1e6 + MultiSignal{1}(iS,2);
                    DailyOrders{index, 2} = Contract;
                    DailyOrders{index, 3} = Str((-sign(Signal(iS,iCommodity))+3)/2);
                    DailyOrders{index, 4} = 1;
                    DailyOrders{index, 5} = round(Capital*abs(Signal(iS,iCommodity))/MultiSignal{1}(iS,3)/Multiplier);    
                    % 更新下标
                    index = index + 1;                    
                % 平仓    
                elseif Signal(iS,iCommodity) == 0 && index>1
                    DailyOrders{index, 1} = MultiSignal{1}(iS,1)*1e6 + MultiSignal{1}(iS,2);
                    DailyOrders{index, 2} = Contract;
                    DailyOrders{index, 3} = Str((sign(Signal(iS-1,iCommodity))+3)/2);
                    DailyOrders{index, 4} = 0;
                    DailyOrders{index, 5} = DailyOrders{index-1, 5};   
                    % 更新下标
                    index = index + 1;               
                % 先平仓后开仓    
                elseif index>1
                    % 先平
                    DailyOrders{index, 1} = MultiSignal{1}(iS,1)*1e6 + MultiSignal{1}(iS,2);
                    DailyOrders{index, 2} = Contract;
                    DailyOrders{index, 3} = Str((sign(Signal(iS,iCommodity))+3)/2);
                    DailyOrders{index, 4} = 0;
                    DailyOrders{index, 5} = DailyOrders{index-1, 5};  
                    % 更新下标
                    index = index + 1;                   
                    % 后开
                    DailyOrders{index, 1} = MultiSignal{1}(iS,1)*1e6 + MultiSignal{1}(iS,2);
                    DailyOrders{index, 2} = Contract;
                    DailyOrders{index, 3} = Str((-sign(Signal(iS,iCommodity))+3)/2);
                    DailyOrders{index, 4} = 1;
                    DailyOrders{index, 5} = round(Capital*abs(Signal(iS,iCommodity))/MultiSignal{1}(iS,3)/Multiplier);   
                    % 更新下标
                    index = index + 1;                    
                end
            end
        end          
    end
    
    % 剔除未用到的空数组
    DailyOrders = DailyOrders(1:index-1,:);    

end

