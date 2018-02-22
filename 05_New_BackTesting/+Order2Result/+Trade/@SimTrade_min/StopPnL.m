function  [Adj_Trade] = StopPnL(obj, Trade, Balance, dataMap, ModelParams)
%% 平仓判断是否止损止盈, 提前调整Trade
% Trade 1. 具体时刻 2. 合约代码 3. 买/卖 4. 0/1 (平仓/开仓) 5. 数量

%% 0. 初始化
    IsStopLoss = ModelParams(1).StopLoss;
    IsStopProfit = ModelParams(1).StopProfit;

    % 不止损不止盈
    if IsStopLoss == 0 && IsStopProfit == 0
       Adj_Trade = Trade;
       return;
    end
    
    Adj_Trade = {};
    StopLossRange = ModelParams(1).StopLossRange;
    StopProfitRange = ModelParams(1).StopProfitRange;
    
    % 初始资金, 用于反推成本价
    Capital = 1e8;
    % 合约乘数
    MultiplierMap = obj.MultiplierMap;
    
    % 止损止盈的阈值
    StopLossRange = ModelParams(1).StopLossRange;
    StopProfitRange = ModelParams(1).StopProfitRange;    

%%  1. 先判断昨日持仓是否强平
    NowDate = fix( Trade{1,1}/1e6 )*1e6;
    Balance_Open = cell(size(Balance,1)-1,size(Trade,2));
    Str = ['卖','买'];
    
    if ~isempty(Balance_Open)
        % Balance_Open: 1. Date000000 2. 合约代码 3. 买/卖 4. 1(开仓) 5. 手数 
        for itemp = 1:size(Balance_Open,1)
           Balance_Open{itemp,1} = NowDate;
           Balance_Open{itemp,2} = Balance{itemp,1};
           Balance_Open{itemp,3} = Str((sign(Balance{itemp,2})+3)/2);
           Balance_Open{itemp,4} = 1;
           Balance_Open{itemp,5} = abs(Balance{itemp,2});
        end 
        % 判断昨天头寸是否要进行止损止盈
        for jtemp = 1:size(Balance_Open,1)
            Contract = Balance_Open{jtemp,2};
            MinData = dataMap(Contract);
            index_temp = find( strcmp(Trade(:,2),Contract) == 1, 1, 'first');
            % 当日该合约未平仓
            if isempty(index_temp)
                continue;
            end
            Trade_Close = Trade(index_temp,:);
            Temp_AdjTrade = AdjTrade( Balance_Open(jtemp,:), Trade_Close, MinData, IsStopLoss, IsStopProfit, MultiplierMap, Capital, StopLossRange, StopProfitRange);
            Trade(index_temp,:) = Temp_AdjTrade; 
        end
    end

%%  2. 再判断日内是否强平
    
    ContractList = unique(Trade(:,2));
    % 对每个合约进行遍历
    for ii = 1:length(ContractList)
        Contract = ContractList{ii};
        Trade_Contract = Trade(strcmp(Trade(:,2),Contract),:);
        MinData = dataMap(Contract);
        
        for kk = 1:size(Trade_Contract,1)
            % 先找有平仓合约对应的开仓合约Trade_Open
            if Trade_Contract{kk,4} == 0 || kk == size(Trade_Contract,1)
                continue;
            end
            % 再找Trade_Open对应的Trade_Close
            Trade_Open = Trade_Contract(kk,:); Trade_Close = Trade_Contract(kk+1,:);
            Temp_AdjTrade = AdjTrade(Trade_Open, Trade_Close, MinData, IsStopLoss, IsStopProfit, MultiplierMap, Capital, StopLossRange, StopProfitRange);
            Trade_Contract(kk+1,:) = Temp_AdjTrade;
        end        
        Adj_Trade = [Adj_Trade;Trade_Contract];
    end
    
    Adj_Trade = sortrows(Adj_Trade,1);
end

function Adj_Trade = AdjTrade(Trade_Open, Trade_Close, MinData, IsStopLoss, IsStopProfit, MultiplierMap, Capital, StopLossRange, StopProfitRange)
%%  对于给定的开仓和平仓时间, 判断是否止盈/止损, 如不操作则返回正常平仓Trade_Close

    %% 0. 初始化
    Str = ['卖','买'];    
    Adj_Trade = Trade_Close;
    % 开仓价
    OpenPrice = round(Capital/MultiplierMap(Trade_Open{2})/Trade_Open{5});
    
    StartTime = rem(Trade_Open{1},1e6); EndTime = rem(Trade_Close{1},1e6);
    StartTime = AdjTime(StartTime, 1); EndTime = AdjTime(EndTime, 1);
    
    for itemp = 1:size(MinData,1)
        MinData(itemp,2) = AdjTime(MinData(itemp,2),1); 
    end
    
    StartIndex = find( MinData(:,2)>StartTime, 1, 'first' ); EndIndex = find( MinData(:,2)<EndTime, 1, 'last' );
    
    % 变动幅度
    Float = (MinData(StartIndex:EndIndex,6) - OpenPrice)/OpenPrice;

    %% 1. 止损/止盈判断
    
    % 既止损又止盈
    if IsStopLoss && IsStopProfit
       StopLossIndex = find( Float < -StopLossRange, 1, 'first'); 
       StopProfitIndex = find( Float > StopLossRange, 1, 'first');
       Index_temp = [StopLossIndex,StopProfitIndex];
       if isempty(Index_temp)
           return;
       else
           Index_temp = min(Index_temp);
           Adj_Trade{1} = MinData(StartIndex + Index_temp,1)*1e6 + AdjTime(MinData(StartIndex + Index_temp,2),2);
           disp([num2str(Adj_Trade{1}),' 强平止损/止盈 !', ' 开仓价: ', num2str(OpenPrice), ', 目标平仓价: ', num2str(MinData(StartIndex + Index_temp,6))]);                      
       end
    % 只止损   
    elseif IsStopLoss
       if strcmp(Trade_Open{3},Str(2)) 
          StopLossIndex = find( Float < -StopLossRange, 1, 'first'); 
       else
          StopLossIndex = find( Float > StopLossRange, 1, 'first'); 
       end
       Index_temp = StopLossIndex;       
       if isempty(Index_temp)
           return;
       else
           Adj_Trade{1} = MinData(StartIndex + Index_temp,1)*1e6 + AdjTime(MinData(StartIndex + Index_temp,2),2);        
           disp([num2str(Adj_Trade{1}),' 强平止损 !', ' 开仓价: ', num2str(OpenPrice), ', 目标平仓价: ', num2str(MinData(StartIndex + Index_temp,6))]);           
       end
    % 只止盈   
    elseif IsStopProfit
       if strcmp(Trade_Open{3},Str(2))  
          StopProfitIndex = find( Float > StopProfitRange, 1, 'first'); 
       else
          StopProfitIndex = find( Float < -StopProfitRange, 1, 'first');  
       end
       Index_temp = StopProfitIndex;       
       if isempty(Index_temp)
           return;
       else
           Adj_Trade{1} = MinData(StartIndex + Index_temp,1)*1e6 + AdjTime(MinData(StartIndex + Index_temp,2),2);         
           disp([num2str(Adj_Trade{1}),' 强平止盈 !', ' 开仓价: ', num2str(OpenPrice), ', 目标平仓价: ', num2str(MinData(StartIndex + Index_temp,6))]);                      
       end       
    end
end

function Adj_Time = AdjTime(NormalTime, Params)
%   每日从夜盘开始, 在150000结束, 这里调整时间
%   Params = 1: 00000-150000不变, 其它减去240000
%   Params = 2: 00000-150000不变, 负数加上240000
    
    Adj_Time = NormalTime;
    if Params == 1
        if 150000 < NormalTime && NormalTime < 240000
            Adj_Time = NormalTime - 240000;
        end
    elseif Params == 2
        if NormalTime < 0
            Adj_Time = NormalTime + 240000;
        end        
    else
        error('请输入正确的参数!')
    end
end