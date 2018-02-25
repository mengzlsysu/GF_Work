function DailyOrders = DailyOrders(LastDayBalance, MultiSignal, Date, MCContainerList, MultiplierMap)
%   生成该日的订单Orders
%   MultiSignal{1}:  1: Date 2: Time 3-end: 各品种Close
%   MultiSignal{2}:  1: Date 2: Time 3-end: 各品种最终信号值
%   DailyOrders: 1. 时刻 2. 合约 3. 买/卖 4. 0/1 5. 该笔手数 6. 仓位比例(ex. -0.1) 7. 至今持仓总手数
%   DailyBalance 按commodity生成的元胞数组, 每个元素: 1. 时刻 2. 合约 3. 买/卖 4. 0/1 5. 手数 6. 仓位比例(ex. -0.1) 7. 至今持仓总手数

    %% 1.初始化, 预先分配内存提高运算速度
    Capital = 1e8;
    Str = ['买','卖'];
    ss = size(MultiSignal{1}, 1);
    Commodity_Num = size(MultiSignal{1}, 2)-2;
    
    %% 2. 提取指标 & 将昨日持仓情况补在Signal第一行
    Signal = MultiSignal{2}(:,3:end);
    Signal_temp = zeros(1,Commodity_Num);
    for iCommodity = 1:Commodity_Num
        if isempty(LastDayBalance{iCommodity})
            continue
        else
            Signal_temp(iCommodity) = LastDayBalance{iCommodity}{6};
        end
    end
    Signal = [Signal_temp;Signal];
    
    %% 3. 生成订单
    DailyOrders = {};
    for iCommodity = 1:Commodity_Num     
        Contract = MCContainerList{iCommodity}(Date);
        % 该品种当日订单初始化
        if isempty(LastDayBalance{iCommodity})
            DailyOrders_temp = [num2cell(zeros(1,7));cell(2*ss,7)]; 
        else
            DailyOrders_temp = [LastDayBalance{iCommodity};cell(2*ss,7)];             
        end
        % 主力合约换仓
        if ~isempty(LastDayBalance{iCommodity}) && ~strcmp(Contract,LastDayBalance{iCommodity}{2})
            ReplaceOrders = MCReplace(LastDayBalance{iCommodity}, Date, Contract);
        else
            ReplaceOrders = {}; 
        end        
        % 赋值下标
        index = 2;  
        % 合约乘数
        Multiplier = MultiplierMap(Contract);
        
        for iS = 2:size(Signal,1)  
            if Signal(iS,iCommodity)-Signal(iS-1,iCommodity) ~= 0
                % 仅开仓: 仓位绝对值变大 且 信号方向相同
                if abs(Signal(iS,iCommodity)) > abs(Signal(iS-1,iCommodity)) && Signal(iS,iCommodity)*Signal(iS-1,iCommodity) >= 0
                    DailyOrders_temp{index, 1} = MultiSignal{1}(iS-1,1)*1e6 + MultiSignal{1}(iS-1,2);
                    DailyOrders_temp{index, 2} = Contract;
                    DailyOrders_temp{index, 3} = Str((-sign(Signal(iS,iCommodity))+3)/2);
                    DailyOrders_temp{index, 4} = 1;
                    Position = abs(Signal(iS,iCommodity)) - abs(Signal(iS-1,iCommodity));
                    DailyOrders_temp{index, 5} = round(Capital*Position/MultiSignal{1}(iS-1,3)/Multiplier); 
                    DailyOrders_temp{index, 6} = Signal(iS,iCommodity);
                    DailyOrders_temp{index, 7} = sign(Signal(iS,iCommodity))*DailyOrders_temp{index, 5} + DailyOrders_temp{index-1, 7};
                    % 更新下标
                    index = index + 1;                    
                % 仅部分平仓: 仓位绝对值变小 且 信号方向相同    
                elseif abs(Signal(iS,iCommodity)) < abs(Signal(iS-1,iCommodity)) && Signal(iS,iCommodity)*Signal(iS-1,iCommodity) > 0
                    DailyOrders_temp{index, 1} = MultiSignal{1}(iS-1,1)*1e6 + MultiSignal{1}(iS-1,2);
                    DailyOrders_temp{index, 2} = Contract;
                    DailyOrders_temp{index, 3} = Str((sign(Signal(iS-1,iCommodity))+3)/2);
                    DailyOrders_temp{index, 4} = 0;
                    Position = abs(Signal(iS-1,iCommodity)) - abs(Signal(iS,iCommodity));
                    DailyOrders_temp{index, 5} = round(Capital*Position/MultiSignal{1}(iS-1,3)/Multiplier); 
                    DailyOrders_temp{index, 6} = Signal(iS,iCommodity);  
                    DailyOrders_temp{index, 7} = - sign(Signal(iS,iCommodity))*DailyOrders_temp{index, 5} + DailyOrders_temp{index-1, 7};                    
                    % 更新下标
                    index = index + 1;         
                % 全部平仓: 新信号为0, 要求空仓    
                elseif abs(Signal(iS,iCommodity)) == 0
                    DailyOrders_temp{index, 1} = MultiSignal{1}(iS-1,1)*1e6 + MultiSignal{1}(iS-1,2);
                    DailyOrders_temp{index, 2} = Contract;
                    DailyOrders_temp{index, 3} = Str((sign(Signal(iS-1,iCommodity))+3)/2);
                    DailyOrders_temp{index, 4} = 0;
                    DailyOrders_temp{index, 5} = abs(DailyOrders_temp{index-1, 7});
                    DailyOrders_temp{index, 6} = Signal(iS,iCommodity);  
                    DailyOrders_temp{index, 7} = 0;
                    % 更新下标
                    index = index + 1;                                   
                % 先平仓后开仓: 信号方向相反    
                elseif Signal(iS,iCommodity)*Signal(iS-1,iCommodity) < 0
                    % 先完全平仓
                    DailyOrders_temp{index, 1} = MultiSignal{1}(iS-1,1)*1e6 + MultiSignal{1}(iS-1,2);
                    DailyOrders_temp{index, 2} = Contract;
                    DailyOrders_temp{index, 3} = Str((sign(Signal(iS-1,iCommodity))+3)/2);
                    DailyOrders_temp{index, 4} = 0;
                    DailyOrders_temp{index, 5} = abs(DailyOrders_temp{index-1, 7});  
                    DailyOrders_temp{index, 6} = Signal(iS,iCommodity); 
                    DailyOrders_temp{index, 7} = 0;                    
                    % 更新下标
                    index = index + 1;                   
                    % 后开
                    DailyOrders_temp{index, 1} = MultiSignal{1}(iS-1,1)*1e6 + MultiSignal{1}(iS-1,2);
                    DailyOrders_temp{index, 2} = Contract;
                    DailyOrders_temp{index, 3} = Str((-sign(Signal(iS,iCommodity))+3)/2);
                    DailyOrders_temp{index, 4} = 1;
                    Position = abs(Signal(iS,iCommodity));
                    DailyOrders_temp{index, 5} = round(Capital*Position/MultiSignal{1}(iS-1,3)/Multiplier);   
                    DailyOrders_temp{index, 6} = Signal(iS,iCommodity);     
                    DailyOrders_temp{index, 7} = sign(Signal(iS,iCommodity))*DailyOrders_temp{index, 5};                    
                    % 更新下标
                    index = index + 1;                    
                end
            end
        end 
        % 剔除Balance & 未用到的空数组
        DailyOrders_temp = DailyOrders_temp(2:index-1,:);  
        % 合并成最终订单
        DailyOrders = [DailyOrders;ReplaceOrders;DailyOrders_temp];
    end
    
    % 按时间排序 
    DailyOrders = sortrows(DailyOrders,1);
end

function ReplaceOrders = MCReplace(LSOrder, Date, Contract)
%   根据开仓LSOrder生成该日Date的换仓ReplaceOrder

    % 未持仓不操作
    if LSOrder{6} == 0
        ReplaceOrders = {}; return
    end

    Str = {'买','卖'};    
    LastContract = LSOrder{2};
    
    %   当天第1个时刻将原持仓平仓
    load(['..\00_DataBase\MarketData\MinData\ByDate\',num2str(Date),'\',LastContract,'.mat'])
    ReplaceOrders{1, 1} = MinData(1,1)*1e6 + MinData(1,2);
    ReplaceOrders{1, 2} = LastContract;
    ReplaceOrders{1, 3} = Str((sign(LSOrder{6})+3)/2);
    ReplaceOrders{1, 4} = 0;
    ReplaceOrders{1, 5} = LSOrder{5};  
    ReplaceOrders{1, 6} = LSOrder{6}; 
    ReplaceOrders{1, 7} = 0;     
    
    %   当天第1个时刻在新主力合约上开仓
    load(['..\00_DataBase\MarketData\MinData\ByDate\',num2str(Date),'\',Contract,'.mat'])
    ReplaceOrders{2, 1} = MinData(1,1)*1e6 + MinData(1,2);
    ReplaceOrders{2, 2} = Contract;
    ReplaceOrders{2, 3} = Str((-sign(LSOrder{6})+3)/2);
    ReplaceOrders{2, 4} = 1;
    ReplaceOrders{2, 5} = LSOrder{5};  
    ReplaceOrders{2, 6} = LSOrder{6};   
    ReplaceOrders{2, 7} = LSOrder{7};    

end