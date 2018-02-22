classdef SimTrade < handle
    properties
        MultiplierMap;
    end
    
    methods
        function obj = SimTrade()
            load_MultiplierMap(obj);
        end
        
        [DailyStats] = execute(obj, TrdDate, ti_begin, ti_end, ModelPath, ModelName,TrsParam, Balance, DailyStats, ModelParams);
        [newBalance] = calNewBalance(obj, balance, trades, trsCost, dataMap, msgHead);

         
    end % methods
    
    methods(Abstract)
        %% calTrsTime: �����ź�ʱ��orderTime�� ��ִ�н��ײ���trsParam������ִ�н���ʱ��
        [trsTime] = calTrsTime(obj, ordTime, trsParam);
        %% loadDataMap: ��dataPathĿ¼��tiStr�������ݶ���map�У��ļ���Ϊ��key.
        [dataMap] = loadDataMap(obj,tiStr,ContractList);
        %% getTrsPrice: ����trsParam��ȡsym��trdTimeʱ��ĳɽ��۸�
        [prc] = getTrsPrice(obj, prcData, trdTime, trdSide,trsParam, msgHead);
         %% getSttlPrice: clsTimeʱ�������һ����NAN�ĳɽ��ۣ���Ϊ���ս���ۡ�
        [sttl] = getSttlPrice(obj, dataMap, sym, clsTime);
    end
end % classdef SimTrade