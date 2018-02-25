function Asset = update_Asset(Asset, TradeResult, TrsParam)
%% 交易后，计算新的持仓和现金

    % 按发生交易品种循环，计算盈亏、手续费并更新可用现金
    for ind2 = 1:size(TradeResult, 1)
        % 获取基本信息
        Contract = TradeResult{ind2, 1};  % 合约名称
        Multiplier = TrsParam.Multiplier(Contract); % 合约乘数

        % 判断当前交易品种是否在原有持仓中
        [~, ind1] = ismember(TradeResult{ind2, 1}, Asset.Holding(:, 1));  

        if ind1 > 0
            %% 原有持仓发生交易
            % 计算盈亏、费用
            Profit = Asset.Holding{ind1, 2} * (TradeResult{ind2, 3} - Asset.Holding{ind1, 3}) * Multiplier;     % 盈利 = 原持仓数量（含多空方向）*（交易价-持仓价）*合约乘数
            Cost = TradeResult{ind2, 3} * abs(TradeResult{ind2, 2}) * Multiplier * TrsParam.TrsCost;            % 交易费用 = 交易价*交易数量（绝对值）*合约乘数 *交易费率
            % 收回保证金
            Receive = abs(Asset.Holding{ind1, 2}) * Asset.Holding{ind1, 3} * Multiplier * TrsParam.Margin;  % 收回保证金 = 持仓价*持仓数量（绝对值）*合约乘数 * 保证金比例
            % 更新持仓
            TradeResult{ind2, 2} = TradeResult{ind2, 2} + Asset.Holding{ind1, 2};
            Asset.Holding(ind1, :) = TradeResult(ind2, :);
            % 支出保证金
            Pay = abs(Asset.Holding{ind1, 2}) * (Asset.Holding{ind1, 3}) * Multiplier * TrsParam.Margin;    % 支付现金 = 交易价*交易数量（绝对值）*合约乘数 * 保证金比例    
            % 更新现金
            Asset.Cash = Asset.Cash + Profit - Cost + Receive - Pay;        % 现金 = 前值 + 盈亏 - 交易费用 + 收回保证金 - 支出保证金

        else
            %% 新品种开仓
            % 计算费用、支付保证金
            Cost = TradeResult{ind2, 3} * abs(TradeResult{ind2, 2}) * Multiplier * TrsParam.TrsCost; % 交易费用 = 交易价*交易数量（绝对值）*合约乘数 *交易费率
            Pay = abs(TradeResult{ind2, 2}) * TradeResult{ind2, 3} * Multiplier * TrsParam.Margin;  % 支付现金 = 交易价*交易数量（绝对值）*合约乘数 * 保证金比例
            % 更新现金
            Asset.Cash = Asset.Cash - Cost - Pay;      % 现金 = 前值 - 交易费用 - 支出保证金
            % 更新持仓        
            Asset.Holding(end+1, :) = TradeResult(ind2, :);     

        end        
    end
    
    % 删除持仓量为0的合约
    index = find(cell2mat(Asset.Holding(:,2)) == 0);
    Asset.Holding(index, :) = [];
    
    % 更新总权益
    HoldingValue = 0;
    for ii = 1:size(Asset.Holding,1)
        Contract = Asset.Holding{ii, 1};  % 合约名称
        Multiplier = TrsParam.Multiplier(Contract); % 合约乘数
        HoldingValue = HoldingValue + abs(Asset.Holding{ii, 2}) * Asset.Holding{ii, 3} * Multiplier * TrsParam.Margin;
    end
    Asset.Total = HoldingValue + Asset.Cash;
    
end
