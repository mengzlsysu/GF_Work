function [dataMap] = loadDataMap(~,  tiStr)
    global DataPath;
    dataPath = [DataPath, '\Future\Basic_股指期货_Tick\', tiStr, '\'];
    dataMap = containers.Map;
    files = dir(fullfile([dataPath, '*.mat']));
    files = cell2mat({files.name}');
    for i=1 : size(files, 1)
        load([dataPath, files(i,:)]);   % 读取变量: TickData
        dataMap(files(i,1:end-4)) = TickData;
    end
end