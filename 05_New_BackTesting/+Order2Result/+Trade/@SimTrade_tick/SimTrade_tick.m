classdef SimTrade_tick < Order2Result.Trade.SimTrade
    properties
    end
    
    methods
        function obj = SimTrade_tick()
            obj = obj@Order2Result.Trade.SimTrade();
            % do nothing
        end
        
        [trsTime] = calTrsTime(obj, ordTime, trsParam);
        [dataMap] = loadDataMap(obj,  tiStr);
        [prc] = getTrsPrice(obj, tickData, trdTime, trdSide, trsParam, msgHead);
        [sttl] = getSttlPrice(obj, dataMap, sym, clsTime);
    end
end