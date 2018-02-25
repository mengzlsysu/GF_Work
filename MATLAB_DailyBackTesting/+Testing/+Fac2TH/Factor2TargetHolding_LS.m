function Factor2TargetHolding_LS(FactorName, R, H, LS, StartDate, EndDate)
%% 单因子生成持仓目标

    %% 1.初始化
    % 日期缺省处理
    if nargin <= 3
        StartDate = 20100101;
        [Y, M, D] = datevec(today);
        EndDate = Y*1e4+M*1e2+D; 
    end
    
    % 默认分组为5
    Group = 5;
    
    % 因子初始化    
    eval(['Factor = Testing.Factors.', FactorName, ';']);
    Factor.R = R;
    Factor.H = H;
    Factor.initial_BackTesting(R, H, EndDate);
    
    % 命名模型并创建文件夹
    ModelName = [FactorName, '_', num2str(R), '_', num2str(H), '_', num2str(LS)];
    
    ModelFolderName = ['.\Evaluation\', ModelName, '\'];
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

    
    %% 2.生成TargetHolding
    for ii = 1:H:length(DateList)
        
        % 日期
        Date = DateList(ii, 1);        
        
        % 生成TargetHolding
        TempTH = Factor.generate_RH_Mat(Date);
        TargetHolding = Factor.CommodityList(TempTH(:,2));        
        sTH = size(TargetHolding, 1);
        for iTH = 1:sTH
            Mat = Factor.MainContractMap(TargetHolding{iTH, 1});
            index = find(Mat{:, 1} == Date);
            TargetHolding{iTH, 1} = Mat{1, 2}{index, 1};
        end
        
        sGroup = ceil(sTH/Group);
        TargetHolding(:,2) = num2cell(ones(sTH,1)/sGroup);
        
        if LS < Group
           TargetHolding = TargetHolding((LS-1)*sGroup+1:LS*sGroup, :);
        else
           TargetHolding = TargetHolding(end-sGroup+1:end, :);
        end
        
        % 保存TargetHolding
        save([ModelFolderName, 'TargetHolding\', num2str(Date), '.mat'], 'TargetHolding')       
        
        % 打印进度
        if ii/size(DateList,1) >= iPrint*PrintPct && PrintInfo ~= 0
            fprintf('%s %.2f%% TargetHolding is completed: %d \n',datestr(now,'yyyy-mm-dd HH:MM:SS'),ii/size(DateList,1)*100,DateList(ii,1));
            iPrint = iPrint + 1;
        end
        
    end

end
