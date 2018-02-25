function totalAsset = cal_totalAsset(Asset,TrsParam)
    
    totalAsset = Asset.Cash;
    
    for ii = 1:size(Asset.Holding(:, 1), 1)
        
        % 获取基本信息
        Contract = Asset.Holding{ii, 1};  % 合约名称
        Commodity = Contract(1:end-4); % 商品名称
        Multiplier = TrsParam.Multiplier(Commodity); % 合约乘数
        Receive = abs(Asset.Holding{ii, 2}) * Asset.Holding{ii, 3} * Multiplier * TrsParam.Margin;  % 收回保证金 = 持仓价*持仓数量（绝对值）*合约乘数 * 保证金比例
        totalAsset = totalAsset + Receive;
        
    end

end