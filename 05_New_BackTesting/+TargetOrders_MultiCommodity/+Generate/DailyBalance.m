function DailyBalance = DailyBalance( LastDayBalance, DailyOrders, Date, MCContainerList, CommodityList )
%   生成每日持仓, 便于生成当日订单   
%   DailyBalance 按commodity生成的元胞数组, 每个元素: 1. 时刻 2. 合约 3. 买/卖 4. 0/1 5. 手数 6. 仓位比例(ex. -0.1) 7. 至今持仓总手数

    for iCommodity = 1:length(CommodityList)
        % 当前该品种的主力合约
        Contract = MCContainerList{iCommodity}(Date);
        % 该品种最后一笔交易
        index_temp = find(strcmp(DailyOrders(:,2),Contract),1,'last');
        % 如果该品种当日有交易
        if ~isempty(index_temp)
            % 当前该品种持仓
            CommodityBalance = DailyOrders(index_temp,:);
            DailyBalance{iCommodity} = CommodityBalance; 
        % 如果该品种当日未交易, 以昨日持仓作为今日持仓    
        else
            DailyBalance{iCommodity} = LastDayBalance{iCommodity};
        end        
    end

end

