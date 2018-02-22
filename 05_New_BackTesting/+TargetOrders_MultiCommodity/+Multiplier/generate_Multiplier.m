function generate_Multiplier()
%% 计算合约乘数

    ContractList = Market.Methods.get_ContractList();
    CommodityList = sortrows(upper(unique(regexprep(ContractList,'\d+',''))));
    load('TrdDate.mat')

    MultiplierMap = containers.Map;

    for ii = 1:length(CommodityList)
        jj = 1;
        Commodity = upper(CommodityList{ii});
        Temp = NaN;
        while isnan(Temp)
            Date = TrdDate(end-jj,1);
            Temp = Multiplier.cal_Multiplier(Commodity,Date);
            jj = jj+1;
        end
        MultiplierMap(Commodity) = Temp;
    end
    save('.\MultiplierMap.mat','MultiplierMap')
    
end