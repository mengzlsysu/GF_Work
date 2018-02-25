function Factor2TargetHolding(ModelFolderName, SignalPath, CommodityList, ModelParams)
%% 生成持仓目标

    %% 1.初始化
    % 获取日期
    StartDate = ModelParams(1).StartDate;
    EndDate = ModelParams(1).EndDate;  
    
    load('..\00_DataBase\Edited_Factor\Amount\AmountMat.mat', 'AmountMat');
    % 因子初始化    
    Factor = Testing.Factors.Temp;
    Factor.ModelParams = ModelParams;
    Factor.SignalPath = SignalPath;
    Factor.BackTestCommodityList = CommodityList;

    Factor.initial_BackTesting();
    
    % 如果没有文件夹, 创建文件夹
    if ~isdir(ModelFolderName)
        mkdir(ModelFolderName);
    end
    
    TradeVariables = {'Asset', 'TargetHolding','TradePlan','TradeResult'};
    for iTV = 1:length(TradeVariables)
        FolderName = [ModelFolderName, TradeVariables{iTV}, '\'];
        if ~isdir(FolderName)
            mkdir(FolderName);
        end
    end
    
    % 获取日期
    load('TrdDate.mat')
    DateList = TrdDate(find(TrdDate(:, 1) >= StartDate & TrdDate(:, 1) <= EndDate)); 
    
    % 设置打印参数
    PrintInfo = 1; % 0 - 不打印信息 1 - 打印信息
    iPrint = 1; % 打印计算完成百分比 初始化值
    PrintPct = 0.05; % 打印间隔

    % 换仓周期
    H = ModelParams(1).H;
    
    %% 2.生成TargetHolding
    for ii = 1:H:length(DateList)
        
        % 日期
        Date = DateList(ii, 1);        
        
        % 生成TargetHolding
        TargetHolding = Factor.generate_TargetHolding(Date, AmountMat);
        
        % 保存TargetHolding, 如果非空即保存, 如果为空代表未上市
        if isempty(TargetHolding) == 0 
            save([ModelFolderName, 'TargetHolding\', num2str(Date), '.mat'], 'TargetHolding')  
        end
        
        % 打印进度
        if ii/size(DateList,1) >= iPrint*PrintPct && PrintInfo ~= 0
            fprintf('%s %.2f%% TargetHolding is completed: %d \n',datestr(now,'yyyy-mm-dd HH:MM:SS'),ii/size(DateList,1)*100,DateList(ii,1));
            iPrint = iPrint + 1;
        end
        
    end
  
end
