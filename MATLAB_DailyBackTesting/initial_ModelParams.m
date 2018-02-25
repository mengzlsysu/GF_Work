%% 初始化 ModelParams

ModelParams = struct( 'TrsType', {'day'}...      % 执行方式，day,使用日线行情数据，min,使用分钟行情数据，tick,使用Tick行情数据
                                    ,'TIName',{'DeltaLLT','ATR'}...         % 技术指标名称
                                    ,'TIParams', {200,20}...              % 技术指标参数
                                    ,'FileName', {'DeltaLLT_200_','ATR_20_'}...      % 储存技术指标的文件名
                                    ,'TI2Signal',{'SumSign'}...             % 多技术指标生成信号的计算方法
                                    ,'Signal2Commodity',{'MaxMin'}...       % 根据信号选择商品的方法 
                                    ,'CommodityParams',{0.1}...             % 信号选择商品函数的参数
                                    ,'Margin', {0.2}...             % 保证金比例
                                    ,'ModelName', {'JustForTest'}...     % 储存在 Evaluation 中的文件夹名称
                                    ,'StartDate', {20100105}, 'EndDate', {20170731}...             % 回测区间
                                    ,'H',{5}...             % 持仓周期
                                    ,'LS', {0}...           %   LS代表分组, ex: 1代表指标值顺序排列后, 排在第1组内的期货进行回测
);

%   LS功能尚未实现