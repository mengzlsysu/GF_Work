classdef SimTrade < handle
    properties
        MultiplierMap;
    end
    
    methods
        function obj = SimTrade()
            load_MultiplierMap(obj);
        end
        
        [DailyStats] = execute(obj, Orders, TrdDate, ti_begin, ti_end, ModelPath, ModelName,TrsParam, Balance, DailyStats, ModelParams);
        [newBalance] = calNewBalance(obj, balance, trades, trsCost, dataMap, msgHead);

         
    end % methods
    
    methods(Abstract)
        %% calTrsTime: 根据信号时间orderTime， 及执行交易参数trsParam，计算执行交易时间
        [trsTime] = calTrsTime(obj, ordTime, trsParam);
        %% loadDataMap: 将dataPath目录下tiStr日期数据读入map中，文件名为其key.
        [dataMap] = loadDataMap(obj,tiStr,ContractList);
        %% getTrsPrice: 根据trsParam获取sym在trdTime时间的成交价格
        [prc] = getTrsPrice(obj, prcData, trdTime, trdSide,trsParam, msgHead);
         %% getSttlPrice: clsTime时点后的最后一个非NAN的成交价，视为当日结算价。
        [sttl] = getSttlPrice(obj, dataMap, sym, clsTime);
    end
end % classdef SimTrade