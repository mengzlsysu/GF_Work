%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: wei.he
% Date: 2016/9/29
% Discription:  模拟器入口函数。
% 1，输入参数：
%       EndDate(字符串'yyyymmdd'): 结束日期
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dailyStats = GenerateResults(ModelParams, Orders)
    
    global DataPath;
    DataPath = '..\00_DataBase\MarketData\';
    
    %% 初始化：确定结束日期
    if nargin == 0 
        [Y, M, D, H] = datevec(now);
        if H > 20 %如果目前已经是晚上10点以后，结束日期为当日，否则为昨日。
            EndDate = datenum(Y, M, D);
        else
            EndDate = datenum(Y, M, D)-1;
        end
        EndDate = datestr(EndDate, 'yyyymmdd');
    elseif nargin == 1
        Orders = [];    
    elseif nargin >= 3
        error('参数太多！');
    end
    
    StartDate = num2str(ModelParams(1).StartDate);
    EndDate = num2str(ModelParams(1).EndDate);
    
    %% 模拟成交参数
    minTrsParam = struct('TrsType', {'min'}...      % 执行方式，min,使用分钟行情数据，tick,使用Tick行情数据
                                   ,'TrsMinS', {1}...              % 执行起始分钟数
                                   ,'TrsMinE', {1}...              % 执行结束分钟数
                                   ,'TrsTerm', {1}...              % 执行价格，1: Twap,区间内收盘价平均值，2: Vwap,区间内交易金额/交易量
                                   ,'TrsCost', {0.0002}...     % 冲击成本+交易费用
                                   );
    tickTrsParam = struct('TrsType', {'tick'}...      % 执行方式，min,使用分钟行情数据，tick,使用Tick行情数据
                                    ,'TrsDelay', {10}...          % 延迟执行秒数
                                    ,'TrsTerm', {1}...             % 执行价格, 1: 对手价， 2: 最新价
                                    ,'TrsCost', {0.00005}...  % 交易费用&成本
                                    );
    
    %% 模型模拟，此处添加更多模型
    modelPath = ['Evaluation\',ModelParams(1).ModelName,'\',ModelParams(1).TrsType,'\'];
%     models = {'411A','411C', '413A', '413C', '421B_120'};
    models = [];
    for itemp = 1:length(ModelParams)
       models = [models,ModelParams(itemp).FileName]; 
    end
 
   [dailyStats] = Order2Result.Trade.simTrade_Commodity(Orders, StartDate, EndDate, modelPath, models, 1e7, minTrsParam, ModelParams);
   [kpi, nav] = Order2Result.Stats.reapStats_Commodity(modelPath, models, dailyStats);
   Order2Result.Stats.display_Commodity(kpi, nav);% 模拟结果展示
  
end