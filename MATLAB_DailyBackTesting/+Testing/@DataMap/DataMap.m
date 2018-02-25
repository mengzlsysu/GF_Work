classdef DataMap < handle
    %UNTITLED14 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        MinData = containers.Map;
        DayData = containers.Map;
        MainContract = containers.Map;
        MCContainer = containers.Map;
        DataPath = '..\00_DataBase\MarketData\';
    end
    
    methods
        function obj = DataMap()
            % do nothing
        end  
    
        loadDataMap(obj,Contract,dataParam);
        loadMainContract(obj,Contract);
        loadMCContainer(obj,Commodity);
        
    end
    
end

