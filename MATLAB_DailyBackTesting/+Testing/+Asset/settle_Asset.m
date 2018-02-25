function Asset = settle_Asset(Asset, DataMap, DateTime,TrsParam)
%% 盘后结算新的持仓价格和现金

    % 按持仓循环，计算盈亏、更新可用现金和持仓价
    for ii = 1:size(Asset.Holding(:, 1), 1)
        % 获取基本信息
        Contract = Asset.Holding{ii, 1};  % 合约名称
        Multiplier = TrsParam.Multiplier(Contract); % 合约乘数        
        
        % 结算价
        Mat = DataMap.DayData(Contract);
        index = find(Mat(:,1) == floor(DateTime/1e6));
        if isempty(index) == 1
            settlePrice = Asset.Holding{ii, 3};
        else
            settlePrice = Mat(index, 6);
        end

        % 计算盈亏
        Profit = Asset.Holding{ii, 2} * (settlePrice - Asset.Holding{ii, 3}) * Multiplier;      % 盈利 = 原持仓数量（含多空方向）*（交易价-持仓价）*合约乘数        

        % 更新现金、总权益
        Asset.Cash = Asset.Cash + Profit;        % 现金 = 前值 + 盈亏       
        Asset.Total = Asset.Total + Profit;        % 总权益 = 前值 + 盈亏
        % 更新持仓
        Asset.Holding{ii, 3} = settlePrice;
    end

end
