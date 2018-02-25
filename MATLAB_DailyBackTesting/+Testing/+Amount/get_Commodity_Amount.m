function Amount = get_Commodity_Amount(Date, Commodity)    
%% 获得指定商品在指定日期的所有合约中的最高成交量

    load(['..\00_DataBase\MarketData\DayData\',Commodity,'\byDate\',num2str(Date),'.mat'])
    if isempty(DayData)
        Amount = 0;
    else
        Amount = max(DayData(:,6));
    end
    
end
