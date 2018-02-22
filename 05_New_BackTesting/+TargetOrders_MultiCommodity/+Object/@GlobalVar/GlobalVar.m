classdef GlobalVar < handle
    % presetting of global variables 
    
    properties
%        ts = actxserver('TSExpert.CoExec');
        DataPath = '..\00_DataBase\MarketData\MCContainer\';
        TrdDate
        MCContainerList
    end
    
    methods
        function obj = GlobalVar(CommodityList)
            obj.TrdDate = obj.loadDate();
            obj.MCContainerList = obj.loadMCContainer(CommodityList);
        end        
        
        % load TrdDate matrix
        TrdDate = loadDate(obj);
        
        % get MainContract and update if necessary
        MCContainerList = loadMCContainer(obj,CommodityList);
        
    end
    
end

