classdef SimTrade_min < Order2Result.Trade.SimTrade
    properties
    end
    
    methods
        function obj = SimTrade_min()
            obj = obj@Order2Result.Trade.SimTrade();
            % do nothing
        end
        
        [trsTime] = calTrsTime(obj, ordTime, trsParam);
        [dataMap] = loadDataMap(obj,  tiStr,ContractList); % *** Edit
        [prc] = getTrsPrice(obj, minData, trdTime, trdSide, trsParam, msgHead);
        [sttl] = getSttlPrice(obj, dataMap, sym, clsTime);
        [Adj_Trade] = StopPnL(obj, Trade, Balance, dataMap, ModelParams);    
    end
    
end