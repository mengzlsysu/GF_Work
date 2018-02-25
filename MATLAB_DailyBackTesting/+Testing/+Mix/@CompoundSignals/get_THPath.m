function get_THPath(obj)    

    nModels = size(obj.ModelNames,1);
    THPath = cell(nModels,0);
    for ii = 1:nModels
        ModelName = obj.ModelNames{ii};
        THPath{ii} = [obj.DataPath, ModelName, '\TargetHolding\'];
    end
    obj.THPath = THPath;
    
end