function MCContainerList = loadMCContainer(obj,CommodityList) 
%   �������õ���map�ļ�������MCContainerList��

    ss = length(CommodityList);
    for iCommodity = 1:ss
        Commodity = CommodityList{iCommodity}; 
        load([obj.DataPath,Commodity,'.mat']) 
        MCContainerList{iCommodity} = MCContainer;
    end
end