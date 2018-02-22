function [ DailyStats ] = execute(obj, Orders, TrdDate, ti_begin, ti_end, ModelPath, ModelName,TrsParam, Balance, DailyStats, ModelParams)
    global DataPath; 
    %% �����ź��ļ�
    
    ordDate = zeros(length(Orders),1);
    for ii = 1:length(Orders)
        DateTime = Orders{ii,1};
        ordDate(ii,1) = Order2Result.Utility.get_TradeDate(DateTime,TrdDate);
    end
    
    trsTime = obj.calTrsTime(cell2mat(Orders(:,1)), TrsParam);
    trsSide = ismember([Orders{:,3}]', '��');   % ����1�� ��0

    %% ����ģ�⽻���źųɽ��� �������� Balance �� DailyStats��
    blcPath = [ModelPath,ModelName,'\Balance\'];
    trdPath = [ModelPath,ModelName, '\Trade\'];
    DailyStats = [DailyStats; nan(ti_end-ti_begin+1, size(Balance,2)-1)];
    
    %%%%%%%%%%%% Edit
    ContractList = {};
    lastTrade = {};
    %%%%%%%%%%%%
    for ti = ti_begin : ti_end
        tiStr = datestr(TrdDate(ti,2), 'yyyymmdd');
        tiNum = str2double(tiStr);

        index = find(ordDate == tiNum);
        if ~isempty(index)
            tiOrders = Orders(index,:);
            ContractList = unique(union(tiOrders(:,2),Balance(1:end-1,1)));
        end            
        %  һ���Զ�ȡ����ȫ����Լ��������������dataMap�У���ʡ����IOʱ��
        dataMap = obj.loadDataMap(tiStr,ContractList);  
        
        % ��ѯ�ɽ��۸񣬼��ɽ����������ű���Trade��
        msk = ordDate(:,1) == TrdDate(ti,1);
        Trade = Orders(msk, :);
        trdTime = trsTime(msk,1);
        trdSide = trsSide(msk, 1);
        
        % �ж��Ƿ�ֹ��ֹӯ, ��ǰ����Trade        
        Trade = obj.StopPnL(Trade, Balance, dataMap, ModelParams);        
        
        for oi = 1 : size(Trade,1)
            if oi~= size(Trade,1)
                msgHead = sprintf('%s, ��������: %s, Ʒ��: %s, ����: %s, ����: %d\t', ModelName, tiStr, Trade{oi,2}, Trade{oi,3}, Trade{oi,5});
            else
                msgHead = sprintf('%s, ��������: %s, Ʒ��: %s, ����: %s, ����: %d\t', ModelName, tiStr, Trade{oi,2}, Trade{oi-2,3}, Trade{oi,5});
            end
            if oi>1 && Trade{oi,1} == Trade{oi-1,1} && strcmp(Trade{oi,2}, Trade{oi-1,2}) && strcmp(Trade{oi,3}, Trade{oi-1,3}) 
                % ����������м�¼��ʱ�䡢���롢����������ͬ����ɽ��۸���ͬ
                Trade{oi,6} = Trade{oi-1,6};
            else
                if ~isKey(dataMap, Trade{oi, 2})
                    error([msgHead, ' ���г�����.']);
                end      
                % ��ѯ�ɽ��۸�
                Trade{oi, 6} = obj.getTrsPrice(dataMap(Trade{oi,2}), trdTime(oi,1), trdSide(oi,1), TrsParam, msgHead);
            end
        end
        % ����ɽ���Ϣ
        save([trdPath, int2str(TrdDate(ti,1)), '.mat'], 'Trade');
        lastTrade = Trade;

        % ���㲢����ģ����Balance�ļ�
        Balance = obj.calNewBalance(Balance, Trade, TrsParam.TrsCost, dataMap, [ModelName, ', ��������:', tiStr]);
        save([blcPath, int2str(TrdDate(ti,1)), '.mat'], 'Balance');

        DailyStats(end-ti_end+ti,:) =[TrdDate(ti,1), Balance{end, 2}, Balance{end,3}, Balance{end, 4}];
    end  

end

