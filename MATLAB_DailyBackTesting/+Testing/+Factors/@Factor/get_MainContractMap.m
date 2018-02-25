function MainContractMap = get_MainContractMap(obj)

    MainContractMap = containers.Map;
    
    for ii = 1:length(obj.CommodityList)
        Commodity = obj.CommodityList{ii};
        load(['..\00_DataBase\MarketData\MCContainer\',Commodity,'.mat'])
        MainContractMap(Commodity) = MCContainer;    
    end

    obj.MainContractMap = MainContractMap;

end