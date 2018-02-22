function MCContainerList = loadMCContainer(obj,CommodityList) 
%   将所有用到的map文件储存在MCContainerList中

    ss = length(CommodityList);
    for iCommodity = 1:ss
        Commodity = CommodityList{iCommodity}; 
        load([obj.DataPath,Commodity,'.mat']) 
        MCContainerList{iCommodity} = MCContainer;
    end
end