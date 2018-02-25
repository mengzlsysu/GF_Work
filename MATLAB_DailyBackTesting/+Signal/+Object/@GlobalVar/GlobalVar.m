classdef GlobalVar < handle
    % presetting of global variables 
    
    properties
%        ts = actxserver('TSExpert.CoExec');
        DataPath = '..\00_DataBase\MarketData\MainContract\';
        TrdDate
        MainContract
    end
    
    methods
        function obj = GlobalVar(Commodity)
            obj.TrdDate = obj.loadDate();
            obj.MainContract = obj.loadMainContract(Commodity);
        end        
        
        % load TrdDate matrix
        TrdDate = loadDate(obj);
        
        % get MainContract and update if necessary
        MainContract = loadMainContract(obj,Commodity);
        
    end
    
end

