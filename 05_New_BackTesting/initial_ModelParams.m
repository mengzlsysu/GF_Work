%% 初始化 ModelParams

ModelParams = struct( 'TrsType', {'1min'}...      % 执行方式，day,使用日线行情数据，min,使用分钟行情数据，tick,使用Tick行情数据
                                    ,'TIName',{'DeltaLLT','ATR'}...         % 技术指标名称
                                    ,'TIParams', {200,20}...              % 技术指标参数
                                    ,'FileName', {'DeltaLLT_200_','ATR_20_'}...      % 储存技术指标的文件名
                                    ,'TI2Signal',{'SumSign'}...             % 多技术指标生成信号的计算方法
                                    ,'Signal2Commodity',{'MaxMin'}...       % 根据信号选择商品的方法 
                                    ,'Margin', {0.2}...             % 保证金比例
                                    ,'MCTrade',{0}...                 % 是否按主力合约切换, 1代表是, 0代表主力合约到期继续持仓至信号结束, 但限5日平仓
                                    ,'ModelName', {'JustForTest'}...     % 储存在 Evaluation 中的文件夹名称
                                    ,'StartDate', {20100105}, 'EndDate', {20170731}...             % 回测区间
                                    ,'StopLoss',{0}, 'StopProfit',{1}...                  % 是否止损/止盈 止损/止盈:1 不止损/不止盈:0 
                                    ,'StopLossRange',{0.01}, 'StopProfitRange',{0.01}...                  % 止损/止盈幅度, ex:下跌1%止损, 上涨1%止盈                                     
);

