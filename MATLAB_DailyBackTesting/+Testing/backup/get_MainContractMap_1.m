function MainContractMap = get_MainContractMap(obj)

    MainContractMap = containers.Map;
    for ii = 1:length(CommodityList)
        Commodity = CommodityList{ii};
        load(['..\00_DataBase\MarketData\MainContract\',Commodity,'.mat'])
        MainContractMap(Commodity) = MainContract;    
    end

    obj.MainContractMap = MainContractMap;

end