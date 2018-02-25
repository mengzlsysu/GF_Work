function loadMCContainer(obj,Commodity)
%   生成商品的Container

    load([obj.DataPath,'MCContainer\',Commodity,'.mat']); 
    eval(['obj.MCContainer(''',Commodity,''') = MCContainer;']);

end

