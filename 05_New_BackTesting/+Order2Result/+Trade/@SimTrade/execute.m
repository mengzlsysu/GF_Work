function [ DailyStats ] = execute(obj, Orders, TrdDate, ti_begin, ti_end, ModelPath, ModelName,TrsParam, Balance, DailyStats, ModelParams)
    global DataPath; 
    %% 交易信号文件
    
    ordDate = zeros(length(Orders),1);
    for ii = 1:length(Orders)
        DateTime = Orders{ii,1};
        ordDate(ii,1) = Order2Result.Utility.get_TradeDate(DateTime,TrdDate);
    end
    
    trsTime = obj.calTrsTime(cell2mat(Orders(:,1)), TrsParam);
    trsSide = ismember([Orders{:,3}]', '卖');   % 卖：1， 买：0

    %% 逐日模拟交易信号成交， 保存结果至 Balance 和 DailyStats中
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
        %  一次性读取当日全部合约行情数据至变量dataMap中，节省程序IO时间
        dataMap = obj.loadDataMap(tiStr,ContractList);  
        
        % 查询成交价格，检查成交量，结果存放变量Trade中
        msk = ordDate(:,1) == TrdDate(ti,1);
        Trade = Orders(msk, :);
        trdTime = trsTime(msk,1);
        trdSide = trsSide(msk, 1);
        
        % 判断是否止损止盈, 提前调整Trade        
        Trade = obj.StopPnL(Trade, Balance, dataMap, ModelParams);        
        
        for oi = 1 : size(Trade,1)
            if oi~= size(Trade,1)
                msgHead = sprintf('%s, 交易日期: %s, 品种: %s, 方向: %s, 数量: %d\t', ModelName, tiStr, Trade{oi,2}, Trade{oi,3}, Trade{oi,5});
            else
                msgHead = sprintf('%s, 交易日期: %s, 品种: %s, 方向: %s, 数量: %d\t', ModelName, tiStr, Trade{oi,2}, Trade{oi-2,3}, Trade{oi,5});
            end
            if oi>1 && Trade{oi,1} == Trade{oi-1,1} && strcmp(Trade{oi,2}, Trade{oi-1,2}) && strcmp(Trade{oi,3}, Trade{oi-1,3}) 
                % 如果上下两行记录的时间、代码、买卖方向相同，则成交价格相同
                Trade{oi,6} = Trade{oi-1,6};
            else
                if ~isKey(dataMap, Trade{oi, 2})
                    error([msgHead, ' 无市场数据.']);
                end      
                % 查询成交价格
                Trade{oi, 6} = obj.getTrsPrice(dataMap(Trade{oi,2}), trdTime(oi,1), trdSide(oi,1), TrsParam, msgHead);
            end
        end
        % 保存成交信息
        save([trdPath, int2str(TrdDate(ti,1)), '.mat'], 'Trade');
        lastTrade = Trade;

        % 计算并保存模拟结果Balance文件
        Balance = obj.calNewBalance(Balance, Trade, TrsParam.TrsCost, dataMap, [ModelName, ', 交易日期:', tiStr]);
        save([blcPath, int2str(TrdDate(ti,1)), '.mat'], 'Balance');

        DailyStats(end-ti_end+ti,:) =[TrdDate(ti,1), Balance{end, 2}, Balance{end,3}, Balance{end, 4}];
    end  

end

