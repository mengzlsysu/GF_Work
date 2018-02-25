function Orders = Orders(Orders_Raw, MCDuration, ModelParams)
%%  按MADuration时间段对ContractOrders进行整合

%%  0. 初始化
    ss = length(Orders_Raw);
    Orders = {};
    Capital = 1e8;
    Str = {'买','卖'};
    % 限定5个交易日平仓, 用7个自然日近似
    StopDay = 7;
    
%%  1. 如果主力合约到期进行切换, 直接进行拼接即可    
    if ModelParams(1).MCTrade == 1
        Orders_Raw(~cellfun(@isempty,Orders_Raw ));
        % 有效长度(非空)
        ss_temp = length(Orders_Raw);        
        for itemp = 1:ss_temp
            Orders(end+1:end+size(Orders_Raw{itemp},1),:) = Orders_Raw{itemp};
        end
        return;
    end
    
%%  2. 如果主力合约到期继续持仓至信号结束, 但限5日平仓
    for itemp = 1:ss
        if isempty(Orders_Raw{itemp})
           continue; 
        end
        
        StartDate = max(MCDuration(itemp,1), ModelParams(1).StartDate)*1e6; 
        EndDate = min(MCDuration(itemp,2), ModelParams(1).EndDate)*1e6;
        if StartDate >= EndDate
            continue;
        end
        Order_temp = Orders_Raw{itemp};
        
        % 上一合约平仓的日期作为该合约开始下单的日期
        if ~isempty(Orders)
           StartDate = max(StartDate, Orders{end,1}); 
        end
        
        % 寻找下标
        index1 = find(cell2mat(Order_temp(:,1)) >= StartDate & cell2mat(Order_temp(:,4)) ~= 0, 1, 'first');
        if isempty(index1)
            index1 = 1;
        end    
        index2 = find(cell2mat(Order_temp(:,1)) <= (EndDate + 150000) & cell2mat(Order_temp(:,4)) ~= 0, 1, 'last');
        if isempty(index2)
            continue;      
        end
        
        % 判断StopDay(7)天内是否平仓
        if Order_temp{index2+1, 1} <= (MCDuration(itemp,2) + StopDay)*1e6
            index2 = index2 + 1;
            Orders = [Orders;Order_temp(index1:index2,:)];
        % 7天后强制平仓    
        else
            Contract = Order_temp{index2, 2};
            ind = regexp(Contract, '\D');
            Commodity = Contract(ind);
            load(['..\00_DataBase\MarketData\MinData\ByContract\',Commodity,'\',ModelParams(1).TrsType,'\',Contract,'.mat'])
            index_temp = find(MinData(:,1) <= (MCDuration(itemp,2) + StopDay), 1, 'last');
 
            NewOrders{1, 1} = MinData(index_temp,1)*1e6 + MinData(index_temp,2);
            NewOrders{1, 2} = Contract;
            NewOrders{1, 3} = Str(~ismember(Str, Order_temp{index2, 3}));
            NewOrders{1, 4} = 0;
            NewOrders{1, 5} = Order_temp{index2,5};   
            
            Orders = [Orders;Order_temp(index1:index2,:);NewOrders];
        end
        
    end
       
end