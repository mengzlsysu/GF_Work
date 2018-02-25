function addModels(obj, ModelName)
    
    nrows = size(obj.ModelNames,1);
    if ~ismember(ModelName, obj.ModelNames)
        obj.ModelNames{nrows+1,1} = ModelName;
    end
    
end