function TradePlan = generate_TradePlan(Asset, DataMap, TargetHolding, DateTime, TrsParam)
%% 根据当前资产、目标持仓和交易数据，计算交易结果
    
    % 计算交易日期（注：如果交易类型为日线交易，则Date为交易日前一天）
    Date = floor(DateTime/1e6);
    
    %% 需平仓品种：不在TargetHolding的原持仓
    ClosePosition = setdiff(Asset.Holding(:, 1), TargetHolding(:, 1));
    TradePlan = cell(0,2);
    
    % 如果持仓有变化，执行
    if size(ClosePosition, 2) ~= 0    
        for ii = 1:size(ClosePosition, 1)
            
            % 平仓品种、交易数量、交易时间
            index = find(strcmp(Asset.Holding(:, 1), ClosePosition(ii, 1)));
            TradePlan{ii, 1} = Asset.Holding{index, 1};
            TradePlan{ii, 2} = -Asset.Holding{index, 2};
            TradePlan{ii, 3} = DateTime;
            
        end
    end
    
    if ~exist('ii', 'var') | isempty(ii)
        ii = 0;
    end
    
    %% 待开仓/调仓品种
    
    for jj = 1:size(TargetHolding(:, 1), 1)
        
        % 交易品种名称
        ii = ii+1;
        TradePlan{ii, 1} = TargetHolding{jj, 1};
        
        % 判断当前品种是否在原有持仓中
        [~, ind1] = ismember(TradePlan{ii, 1}, Asset.Holding(:, 1));  
        
        if ind1 == 0            
        % 1.不在原持仓之内，开仓
            Contract =  TradePlan{ii, 1};  % 合约名称         
            
            % 计算结算价
            Mat = DataMap.DayData(Contract);
            index1 = find(Mat(:,1) == Date);
            settlePrice = Mat(index1, 6);
            % 合约乘数
            Multiplier = TrsParam.Multiplier(Contract);
            
            % 计算交易数量、记录交易时间
            if isempty(settlePrice) == 1
                TradePlan{ii, 2} = 0;
            else
                TradePlan{ii, 2} = round(Asset.Total*TargetHolding{jj, 2}/(settlePrice*Multiplier));
            end
            TradePlan{ii, 3} = DateTime;
            
        else
        % 2.原来有原持仓之内，计算开平仓数量
            Contract = TradePlan{ii, 1};  % 合约名称            
            
            % 计算结算价
            Mat = DataMap.DayData(Contract);
            index1 = find(Mat(:,1) == Date);
            settlePrice = Mat(index1, 6);
            % 合约乘数
            Multiplier = TrsParam.Multiplier(Contract);
            
            % 计算交易数量、记录交易时间
            if isempty(settlePrice) == 1
               TradePlan{ii, 2} = 0;
            elseif sign(TargetHolding{jj, 2}) ~= sign(Asset.Holding{ind1, 2})            
               TradePlan{ii, 2} = round(Asset.Total*TargetHolding{jj, 2}/(settlePrice*Multiplier) - Asset.Holding{ind1, 2});
            else
               TradePlan{ii, 2} = 0; 
            end
            TradePlan{ii, 3} = DateTime;
        end
    end
    
end