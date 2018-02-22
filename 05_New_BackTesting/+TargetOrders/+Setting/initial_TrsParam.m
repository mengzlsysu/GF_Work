if ~exist('MultiplierMap','var')
    load('MultiplierMap.mat')
end

TrsParam = struct('TrsType', {'min'}...      % 执行方式，day,使用日线行情数据，min,使用分钟行情数据，tick,使用Tick行情数据
,'TrsTerm', {1}...              % 执行价格，1: 开盘价，4: 收盘价
,'TrsCost', {0.0003}...      % 冲击成本+交易费用
,'Margin', {0.2}...             % 保证金比例
);

TrsParam.Multiplier = MultiplierMap;

