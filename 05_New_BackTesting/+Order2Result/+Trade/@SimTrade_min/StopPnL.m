function  [Adj_Trade] = StopPnL(obj, Trade, Balance, dataMap, ModelParams)
%% ƽ���ж��Ƿ�ֹ��ֹӯ, ��ǰ����Trade
% Trade 1. ����ʱ�� 2. ��Լ���� 3. ��/�� 4. 0/1 (ƽ��/����) 5. ����

%% 0. ��ʼ��
    IsStopLoss = ModelParams(1).StopLoss;
    IsStopProfit = ModelParams(1).StopProfit;

    % ��ֹ��ֹӯ
    if IsStopLoss == 0 && IsStopProfit == 0
       Adj_Trade = Trade;
       return;
    end
    
    Adj_Trade = {};
    StopLossRange = ModelParams(1).StopLossRange;
    StopProfitRange = ModelParams(1).StopProfitRange;
    
    % ��ʼ�ʽ�, ���ڷ��Ƴɱ���
    Capital = 1e8;
    % ��Լ����
    MultiplierMap = obj.MultiplierMap;
    
    % ֹ��ֹӯ����ֵ
    StopLossRange = ModelParams(1).StopLossRange;
    StopProfitRange = ModelParams(1).StopProfitRange;    

%%  1. ���ж����ճֲ��Ƿ�ǿƽ
    NowDate = fix( Trade{1,1}/1e6 )*1e6;
    Balance_Open = cell(size(Balance,1)-1,size(Trade,2));
    Str = ['��','��'];
    
    if ~isempty(Balance_Open)
        % Balance_Open: 1. Date000000 2. ��Լ���� 3. ��/�� 4. 1(����) 5. ���� 
        for itemp = 1:size(Balance_Open,1)
           Balance_Open{itemp,1} = NowDate;
           Balance_Open{itemp,2} = Balance{itemp,1};
           Balance_Open{itemp,3} = Str((sign(Balance{itemp,2})+3)/2);
           Balance_Open{itemp,4} = 1;
           Balance_Open{itemp,5} = abs(Balance{itemp,2});
        end 
        % �ж�����ͷ���Ƿ�Ҫ����ֹ��ֹӯ
        for jtemp = 1:size(Balance_Open,1)
            Contract = Balance_Open{jtemp,2};
            MinData = dataMap(Contract);
            index_temp = find( strcmp(Trade(:,2),Contract) == 1, 1, 'first');
            % ���ոú�Լδƽ��
            if isempty(index_temp)
                continue;
            end
            Trade_Close = Trade(index_temp,:);
            Temp_AdjTrade = AdjTrade( Balance_Open(jtemp,:), Trade_Close, MinData, IsStopLoss, IsStopProfit, MultiplierMap, Capital, StopLossRange, StopProfitRange);
            Trade(index_temp,:) = Temp_AdjTrade; 
        end
    end

%%  2. ���ж������Ƿ�ǿƽ
    
    ContractList = unique(Trade(:,2));
    % ��ÿ����Լ���б���
    for ii = 1:length(ContractList)
        Contract = ContractList{ii};
        Trade_Contract = Trade(strcmp(Trade(:,2),Contract),:);
        MinData = dataMap(Contract);
        
        for kk = 1:size(Trade_Contract,1)
            % ������ƽ�ֺ�Լ��Ӧ�Ŀ��ֺ�ԼTrade_Open
            if Trade_Contract{kk,4} == 0 || kk == size(Trade_Contract,1)
                continue;
            end
            % ����Trade_Open��Ӧ��Trade_Close
            Trade_Open = Trade_Contract(kk,:); Trade_Close = Trade_Contract(kk+1,:);
            Temp_AdjTrade = AdjTrade(Trade_Open, Trade_Close, MinData, IsStopLoss, IsStopProfit, MultiplierMap, Capital, StopLossRange, StopProfitRange);
            Trade_Contract(kk+1,:) = Temp_AdjTrade;
        end        
        Adj_Trade = [Adj_Trade;Trade_Contract];
    end
    
    Adj_Trade = sortrows(Adj_Trade,1);
end

function Adj_Trade = AdjTrade(Trade_Open, Trade_Close, MinData, IsStopLoss, IsStopProfit, MultiplierMap, Capital, StopLossRange, StopProfitRange)
%%  ���ڸ����Ŀ��ֺ�ƽ��ʱ��, �ж��Ƿ�ֹӯ/ֹ��, �粻�����򷵻�����ƽ��Trade_Close

    %% 0. ��ʼ��
    Str = ['��','��'];    
    Adj_Trade = Trade_Close;
    % ���ּ�
    OpenPrice = round(Capital/MultiplierMap(Trade_Open{2})/Trade_Open{5});
    
    StartTime = rem(Trade_Open{1},1e6); EndTime = rem(Trade_Close{1},1e6);
    StartTime = AdjTime(StartTime, 1); EndTime = AdjTime(EndTime, 1);
    
    for itemp = 1:size(MinData,1)
        MinData(itemp,2) = AdjTime(MinData(itemp,2),1); 
    end
    
    StartIndex = find( MinData(:,2)>StartTime, 1, 'first' ); EndIndex = find( MinData(:,2)<EndTime, 1, 'last' );
    
    % �䶯����
    Float = (MinData(StartIndex:EndIndex,6) - OpenPrice)/OpenPrice;

    %% 1. ֹ��/ֹӯ�ж�
    
    % ��ֹ����ֹӯ
    if IsStopLoss && IsStopProfit
       StopLossIndex = find( Float < -StopLossRange, 1, 'first'); 
       StopProfitIndex = find( Float > StopLossRange, 1, 'first');
       Index_temp = [StopLossIndex,StopProfitIndex];
       if isempty(Index_temp)
           return;
       else
           Index_temp = min(Index_temp);
           Adj_Trade{1} = MinData(StartIndex + Index_temp,1)*1e6 + AdjTime(MinData(StartIndex + Index_temp,2),2);
           disp([num2str(Adj_Trade{1}),' ǿƽֹ��/ֹӯ !', ' ���ּ�: ', num2str(OpenPrice), ', Ŀ��ƽ�ּ�: ', num2str(MinData(StartIndex + Index_temp,6))]);                      
       end
    % ֹֻ��   
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
           disp([num2str(Adj_Trade{1}),' ǿƽֹ�� !', ' ���ּ�: ', num2str(OpenPrice), ', Ŀ��ƽ�ּ�: ', num2str(MinData(StartIndex + Index_temp,6))]);           
       end
    % ֹֻӯ   
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
           disp([num2str(Adj_Trade{1}),' ǿƽֹӯ !', ' ���ּ�: ', num2str(OpenPrice), ', Ŀ��ƽ�ּ�: ', num2str(MinData(StartIndex + Index_temp,6))]);                      
       end       
    end
end

function Adj_Time = AdjTime(NormalTime, Params)
%   ÿ�մ�ҹ�̿�ʼ, ��150000����, �������ʱ��
%   Params = 1: 00000-150000����, ������ȥ240000
%   Params = 2: 00000-150000����, ��������240000
    
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
        error('��������ȷ�Ĳ���!')
    end
end