function [dataMap] = loadDataMap(~,  tiStr)
    global DataPath;
    dataPath = [DataPath, '\Future\Basic_��ָ�ڻ�_Tick\', tiStr, '\'];
    dataMap = containers.Map;
    files = dir(fullfile([dataPath, '*.mat']));
    files = cell2mat({files.name}');
    for i=1 : size(files, 1)
        load([dataPath, files(i,:)]);   % ��ȡ����: TickData
        dataMap(files(i,1:end-4)) = TickData;
    end
end