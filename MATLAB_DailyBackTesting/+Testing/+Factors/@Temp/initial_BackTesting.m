function initial_BackTesting(obj) 

    obj.CommodityList = obj.get_CommodityList();
    obj.MainContractMap = obj.get_MainContractMap();
    obj.DataMap_R = obj.get_DataMap(obj.CommodityList);
    
end