function Orders = Orders(Orders_Raw, DateList, ModelParams)
%%  对DailyOrders进行整合
%   DailyOrders: 1. 时刻 2. 合约 3. 买/卖 4. 0/1 5. 手数

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
        Orders = Orders_Raw{1};
        for itemp = 2:ss_temp    
            LastContract = unique(Orders_Raw{itemp-1}); NowContract = unique(Orders_Raw{itemp});
            Orders = [Orders;Orders_Raw{itemp}];
        end
        return;
    end
    
end

function ReplaceOrder = MCReplace(LSOrder, Date, ModelParams)
%   根据开仓LSOrder生成该日Date的换仓ReplaceOrder

    Str = {'买','卖'};    
    Contract = LSOrder{2};
    
    ind = regexp(Contract, '\D');
    Commodity = Contract(ind);
    load(['..\00_DataBase\MarketData\MinData\ByContract\',Commodity,'\',ModelParams(1).TrsType,'\',Contract,'.mat'])
    index = find(MinData(:,1) <= Date, 1, 'last');

    ReplaceOrders{1, 1} = MinData(index,1)*1e6 + MinData(index,2);
    ReplaceOrders{1, 2} = Contract;
    ReplaceOrders{1, 3} = Str(~ismember(Str, LSOrder{3}));
    ReplaceOrders{1, 4} = 0;
    ReplaceOrders{1, 5} = LSOrder{index2,5};       

end