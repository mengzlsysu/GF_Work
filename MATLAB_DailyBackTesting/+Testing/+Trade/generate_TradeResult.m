function TradeResult = generate_TradeResult(DataMap, TradePlan, TrsParam, Asset)
%% 根据TradePlan下达指令，返回交易结果TradeResult  
% 按TrsParam.TrsType分成三种不同计算方案

    fhandle = str2func(['generate_TradeResult_', TrsParam.TrsType]);
    TradeResult = fhandle(DataMap, TradePlan, TrsParam, Asset);
    
end


%% 日线交易
function TradeResult = generate_TradeResult_day(DataMap, TradePlan, TrsParam, Asset)
    %% 1.初始化
    TradeResult = cell(size(TradePlan,1),3);
    TradeResult(:,1:2) = TradePlan(:,1:2);
    TrsParam.TrsTerm = 1;
    
    %% 2.计算执行价格
    for ii = 1:size(TradeResult(:, 1), 1)  

        Contract =  TradeResult{ii, 1};  % 合约名称       
        Date = TradePlan{ii, 3}/1e6; % 交易日期（注：交易类型为日线交易，则Date为交易日前一天）
        
        % 计算结算价
        
        Mat = DataMap.DayData(Contract);

        index = find(Mat(:,1) == Date) + 1; % 交易日为Date的后一天
        
        if TrsParam.TrsTerm < 5
            settlePrice = Mat(index, TrsParam.TrsTerm+2); % 结算价 +2：跳过 日期、时间 两列
            TradeResult{ii, 3} = settlePrice; % 成交价格
        else
            Multiplier = round(Mat(index, 8)/Mat(index, 7)/Mat(index, 6)); % 合约乘数
            settlePrice = round(Mat(index, 8)/Mat(index, 7)/Multiplier); % 结算价
            TradeResult{ii, 3} = settlePrice; % 成交价格
        end
        
        % 处理找不到主力合约价格/主力合约过短无法提供交易日价格的异常情况
        if isempty(index) == 1 || size(Mat,1)<index
             % 未持有该品种且计划该品种为空仓的, 记成交价格为0 
             if TradePlan{ii, 2} == 0 % && isempty(Asset.Holding) == 1
                 ind = regexp(Contract,'\D');
                 Commodity = Contract(ind);
                 for itemp = 1:size(Asset.Holding(:,1),1)
                     Contract_temp = Asset.Holding{itemp,1};
                     ind_temp = regexp(Contract_temp,'\D');
                     Commodity_temp = Contract_temp(ind_temp);
                     if strcmp(Commodity, Commodity_temp) == 1
                         continue;
                     elseif itemp == size(Asset.Holding(:,1),1)
                         TradeResult{ii, 3} = 0;  
                         continue;
                     end                         
                 end
             end     
        end

    end
    
end

