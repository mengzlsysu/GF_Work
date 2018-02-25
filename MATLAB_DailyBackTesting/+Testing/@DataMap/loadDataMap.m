function loadDataMap(obj,Contract,dataParam)
    Commodity = Contract(1:end-4);
    if isempty(dataParam.Period)
try        load([obj.DataPath,dataParam.Type,'\',Commodity,'\ByContract\',Contract]);   % 读取变量: DayData
catch;end
    else
        load([obj.DataPath,dataParam.Type,'\ByContract\',Commodity,'\',dataParam.Period,'\',Contract]);   % 读取变量: MinData
    end

    eval(['obj.',dataParam.Type,'(''',Contract,''') = ',dataParam.Type,';']);
    
end
