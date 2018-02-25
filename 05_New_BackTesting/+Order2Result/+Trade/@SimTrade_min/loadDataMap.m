function [dataMap] = loadDataMap(~,tiStr,ContractList)
    global DataPath;
    
%     dataPath = [DataPath, '\Future\Basic_��ָ�ڻ�_Min\', tiStr, '\'];
    dataPath = [DataPath, 'MinData\ByDate\', tiStr, '\'];
    
    dataMap = containers.Map;
    
%     files = dir(fullfile([dataPath, '*.mat']));
%     files = {files.name}';

    if isempty(ContractList)
        return
    end
    for i=1 : size(ContractList, 1)
        load([dataPath, ContractList{i},'.mat']);   % ��ȡ����: MinData
        dataMap(ContractList{i}) = MinData;
    end