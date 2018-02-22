function [dataMap] = loadDataMap(~,tiStr,ContractList)
    global DataPath;
    
%     dataPath = [DataPath, '\Future\Basic_股指期货_Min\', tiStr, '\'];
    dataPath = [DataPath, 'MinData\ByDate\', tiStr, '\'];
    
    dataMap = containers.Map;
    
%     files = dir(fullfile([dataPath, '*.mat']));
%     files = {files.name}';

    if isempty(ContractList)
        return
    end
    for i=1 : size(ContractList, 1)
            load([dataPath, ContractList{i},'.mat']);   % 读取变量: MinData
            dataMap(ContractList{i}) = MinData;
    end