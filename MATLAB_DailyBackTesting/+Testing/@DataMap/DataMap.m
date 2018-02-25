classdef DataMap < handle
    %UNTITLED14 此处显示有关此类的摘要
    %   此处显示详细说明
    
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

