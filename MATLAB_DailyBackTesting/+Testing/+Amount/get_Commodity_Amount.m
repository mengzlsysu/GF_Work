function Amount = get_Commodity_Amount(Date, Commodity)    
%% ���ָ����Ʒ��ָ�����ڵ����к�Լ�е���߳ɽ���

    load(['..\00_DataBase\MarketData\DayData\',Commodity,'\byDate\',num2str(Date),'.mat'])
    if isempty(DayData)
        Amount = 0;
    else
        Amount = max(DayData(:,6));
    end
    
end
