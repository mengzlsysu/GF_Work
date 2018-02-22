%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: wei.he
% Date: 2016/9/27
% Discription:  根据模型交易信号文件，计算模型每日持仓&盈亏结果。
% 1，输入参数：
%       StartDate/EndDate(字符串'yyyymmdd'): 起始日期和结束日期
%       ModelPath: 模型文件夹路径，不包含模型文件夹名 
%       Model: 模型名称，即文件夹名称
%       InitialBalance: 初始规模
%       TrsParam: 模拟成交参数
% 2，输入输出文件结构：
%       模型交易信号Order文件:    1.信号时间， 2.合约代码，3.买/卖，4.开/平，5.数量 
%       模型日终持仓Balance文件: 最后行: 1.''， 2.当日交易市值，3.日终持仓市值，4.日终权益
%                                                    其它行: 1.合约代码， 2.持仓数量(+/-)， 3.当日结算价， 4.当日结算市值
% 3，函数逻辑
%       如果Balance目录下存在历史模拟结果时，读取Balance目录下的最近日期为真实起始日期，否则以指定起始日期为真实起始日期
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [DailyStats] = simTrade_Commodity(Orders, StartDate, EndDate, ModelPath, ModelName, InitBalance, TrsParam, ModelParams)
    global DataPath;
    load('TrdDate.mat');   % 读取变量: TrdDate
    
    %% 初始化：开始日期
    % 读取变量 Orders
    if isempty(Orders)
       load([ModelPath, ModelName, '\Orders.mat']);    
    end
    if size(Orders,1)<1 
        disp([ModelName, ' 交易信号文件为空.']);
        disp([ModelName, ' 模拟结束.']);
        return;
    end
    ordSDate = fix(Orders{1,1}/1000000);
    if str2double(StartDate) > ordSDate
        disp([ModelName, ' 模拟起始日期[ ', StartDate, ' ]将调整为最早信号日期[ ', num2str(ordSDate), ' ].']);
        StartDate = num2str(ordSDate);
    end
    
    %% 初始化：结束日期
    ti_end = find(TrdDate(:,1) <= str2double(EndDate), 1, 'last');
    if isempty(ti_end)
        disp([ModelName, ' 模拟结束日期:', EndDate, ', 最早交易日期:', num2str(TrdDate(1,1)), '.']);
        disp([ModelName, ' 模拟结束.']);
        return;
    end

    %% 初始化：Balance目录和Trade目录
    blcPath = [ModelPath,ModelName,'\Balance\'];
    if ~isdir(blcPath)  
        mkdir(blcPath);
    end
    trdPath = [ModelPath,ModelName, '\Trade\'];
    if ~isdir(trdPath)
        mkdir(trdPath)
    end
    
    %% 初始化：Balance, DailyStats, 开始日期
    blcFile = dir([blcPath, '*.mat']);
    if isempty(blcFile)
        disp([ModelName, ' 历史模拟结果为空.']);
        ti_begin = find(TrdDate(:,1)>=str2double(StartDate), 1, 'first');
        if isempty(ti_begin)
            disp([ModelName, ' 模拟起始日期:', StartDate, ', 最近交易日期:', num2str(TrdDate(end,1)), '.']);
            disp([ModelName, ' 模拟结束.']);
            DailyStats=[]; 
            return;
        end
        Balance = {'', 0, 0, InitBalance, ''};
        save([blcPath, datestr(TrdDate(ti_begin-1, 2), 'yyyymmdd'), '.mat'], 'Balance');    % 默认ti_begin> 1
        DailyStats = [TrdDate(ti_begin-1,1), 0, 0, InitBalance];
    else
        disp([ModelName, ' 历史模拟结果不为空.']);
        load([blcPath,blcFile(end).name]);  % 读取变量: Balance
        stsFile = [ModelPath, ModelName, '\DailyStats.mat'];
        if ~exist(stsFile, 'file')
            disp([ModelName, ' DailyStats文件缺失, 将重新生成.']);
            DailyStats = genDailyStats(blcPath, blcFile);
        else
            load(stsFile);  % 读取变量: DailyStats
            if DailyStats(end,1)~=str2double(blcFile(end).name(1:end-4))
                disp([ModelName, ' DailyStats文件日期与Balance文件日期不一致，将重新生成.']);
                DailyStats= genDailyStats(blcPath, blcFile);
            end
        end
        StartDate = int2str(DailyStats(end,1));
        ti_begin = find(TrdDate(:,1)>str2double(StartDate), 1, 'first');
        if isempty(ti_begin)
            disp([ModelName, ' 历史模拟结束日期:', StartDate, ', 最近交易日期:', num2str(TrdDate(end,1)), '.']);
            disp([ModelName, ' 模拟结束.']);
            return;
        end
    end
    
    %% 模拟主程序
    SimTradeConstructor = str2func(['Order2Result.Trade.SimTrade_', TrsParam.TrsType]);
    simTrade = SimTradeConstructor();
    DailyStats = simTrade.execute(TrdDate, ti_begin, ti_end, ModelPath, ModelName, TrsParam, Balance, DailyStats, ModelParams)
        
    disp([ModelName, ' 模拟成功结束.']);
end

%% genDailyStats: 从Balance文件中重新生成DailyStats
    function [dailyStats] = genDailyStats(blcPath, blcFile)
        fNum = length(blcFile);
        load([blcPath, blcFile(1).name]); %读取变量Balance
        dailyStats = nan(fNum, size(Balance,2)-1);
        for fi=1 : fNum
            load([blcPath, blcFile(fi).name]); %读取变量Balance
            dailyStats(fi,1) = str2double(blcFile(fi).name(1:end-4)); % 日期
            dailyStats(fi, 2:end) = cell2mat(Balance(end,2:end-1));
        end
    end
        