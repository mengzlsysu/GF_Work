function loadMCContainer(obj,Commodity)
%   ������Ʒ��Container

    load([obj.DataPath,'MCContainer\',Commodity,'.mat']); 
    eval(['obj.MCContainer(''',Commodity,''') = MCContainer;']);

end

