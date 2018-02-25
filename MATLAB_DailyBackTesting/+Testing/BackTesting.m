function Stats = BackTesting(ModelName, Params, Holding, Commodity, LS)
%% 多因子策略
%   数组Params存放Model所有参数, Holding代表持仓期长度, 一般为5的倍数(即1周的倍数)
%   Commodity如果为0代表不进行单商品回测
%   LS代表分组, ex: 1代表指标值顺序排列后, 排在第1组内的期货进行回测

% profile on

    if nargin <= 3
        Commodity = 0;
        LS = 0;
    elseif nargin <= 4 
        LS = 0;
    end
    close all
    %% 1.初始化
    % 获取日期
    StartDate = 20100104;
    EndDate = 20170831;    
    load('TrdDate.mat')
    DateList = TrdDate(find(TrdDate(:, 1) >= StartDate & TrdDate(:, 1) <= EndDate), :);  
    
    % 命名模型并创建文件夹
    ModelFolderName = ['.\EvaluationSingle\', ModelName];
    if ~isempty(Params)
        ModelFolderName = [ModelFolderName, '\',num2str(Params(1))];
        if length(Params)>1
            for itemp = 2:length(Params)
               ModelFolderName = [ModelFolderName,'_',num2str(Params(itemp))]; 
            end
        end
    end
    ModelFolderName = [ModelFolderName,'\',num2str(Commodity),'\',num2str(Holding),'\',num2str(StartDate),'_',num2str(EndDate),'\'];
    
    H = Holding;
    % 如果文件夹不存在，生成TargetHolding并创建子文件夹
    if ~isdir(ModelFolderName)
        FactorName = ModelName;
        if LS == 0
            TestingForSingle.Fac2TH.Factor2TargetHolding(FactorName, Params, H, Commodity, StartDate, EndDate);   
        else    
            TestingForSingle.Fac2TH.Factor2TargetHolding_LS(FactorName, Params, H, Commodity, StartDate, EndDate);               
        end
    end 
    CommodityName = Commodity;
    
    % 创建文件夹
    TradeVariables = {'Asset', 'TargetHolding','TradePlan','TradeResult'};
    for iTV = 1:length(TradeVariables)
        FolderName = [ModelFolderName, TradeVariables{iTV}, '\'];
        if ~isdir(FolderName)
            mkdir(FolderName);
        end
    end
    
    % 初始化Asset
    InitialCapital = 1e8;
    Asset.Holding = cell(0,3);
    Asset.Cash = InitialCapital;
    Asset.Total = InitialCapital;
    totalAsset = zeros(length(DateList), 1);
    
    % 初始化Stats    
    Stats(:, 1:2) = DateList;
    
    % 设置交易参数
    TestingForSingle.Setting.initial_TrsParam;
    
    % 市场数据初始化
    DataMap = TestingForSingle.DataMap;
    dataParam.Type = 'DayData';
    dataParam.Period = '';
    
    % 判断是否检索TP, (exist过慢)
    isTP = 0;
    
    % 设置打印参数
    PrintInfo = 1; % 0 - 不打印信息 1 - 打印信息
    iPrint = 1; % 打印计算完成百分比 初始化值
    PrintPct = 0.05; % 打印间隔
    
    %% 2.回测
    for ii = 1:length(DateList)
            
        % 获取日期
        Date = DateList(ii, 1);
        DateTime = Date*1e6;
        if ii > 1
            LastDate = DateList(ii-1, 1);
        else
            LastDate = 0;
        end

        %% 执行交易计划
        TPFileName = [ModelFolderName, 'TradePlan\', num2str(LastDate), '.mat'];
        
        % 决定是否检索TP, exist耗时
        if isTP == 1 && exist(TPFileName, 'file')
            % 导入TradePlan
            load(TPFileName);
            % 计算交易结果
            TradeResult = TestingForSingle.Trade.generate_TradeResult(DataMap, TradePlan, TrsParam, Asset);
            % 计算资产变化
            Asset = TestingForSingle.Asset.update_Asset(Asset, TradeResult, TrsParam);            
            % 保存交易结果
            save([ModelFolderName, 'TradeResult\', num2str(Date), '.mat'], 'TradeResult')            
        end

        %% 每日结算、保存文件
        Asset = TestingForSingle.Asset.settle_Asset(Asset, DataMap, DateTime,TrsParam); 
        Holding = Asset.Holding;        
        % 有TP时 计算Holding, Cash, Asset 
        if isTP == 1        
            HoldingList{ii} = Asset.Holding;
            Cash{ii} = Asset.Cash;
            Total{ii} = Asset.Total;   
            isTP = 0;
        end
        % 最终生成Asset总表
        if ii == length(DateList) 
            try HoldingList;
                save([ModelFolderName, 'Asset\AssetTotal.mat'], 'HoldingList', 'Cash', 'Total') 
            catch
            end
        end

        %% 拟定交易计划
        THFileName = [ModelFolderName, 'TargetHolding\', num2str(Date), '.mat'];         
        % 每隔 持有期H 拟定交易计划 
        if rem(ii-1,H) == 0 && exist(THFileName, 'file') % 通过TargetHolding拟定交易计划
            % 导入TargetHolding
            load(THFileName);            
            % 导入相关合约数据
            for iTH = 1:size(TargetHolding, 1)
                Contract = TargetHolding{iTH, 1};
                if ~isKey(DataMap.DayData,Contract)
                    DataMap.loadDataMap(Contract,dataParam);
                end
            end            
            % 计算交易计划并保存
            TradePlan = TestingForSingle.Trade.generate_TradePlan(Asset, DataMap, TargetHolding, DateTime, TrsParam);
            % 保存交易计划
            save([ModelFolderName,  'TradePlan\', num2str(Date), '.mat'], 'TradePlan')
            isTP = 1;            
                
        else %没有TargetHolding的情况下检查是否需要换月
            [TradePlan, isTP] = MCReplacement( Date, Holding, DataMap, ModelFolderName, dataParam );
        end
        
        %% 打印进度
        if ii/size(DateList,1) >= iPrint*PrintPct && PrintInfo ~= 0
            fprintf('%s %.2f%% BackTesting is completed: %d \n',datestr(now,'yyyy-mm-dd HH:MM:SS'),ii/size(DateList,1)*100,DateList(ii,1));
            iPrint = iPrint + 1;
        end
    
        % 计算总资产
        totalAsset(ii, 1) = Asset.Total;

    end  

    % 生成数据文件Stats并保存
    Stats(:, 3) = totalAsset;
    Stats(:, 4) = totalAsset/InitialCapital;
    save([ModelFolderName, 'Stats.mat'], 'Stats')
    
    TestingForSingle.Stats.plot_NetValue( ModelFolderName, H, CommodityName, DateList, Stats);
    TestingForSingle.Stats.cal_RetraceRatio( Stats(:,4), Stats(:,2) );
% profile viewer  
end


function [TradePlan, isTP] = MCReplacement( Date, Holding, DataMap, ModelFolderName, dataParam )
%   主力合约换仓
    
    % 初始化
    isTP = 0; TradePlan = {};    
    % 遍历Holding判断是否换仓
    for iHld = 1:size(Holding, 1)
        Contract = Holding{iHld, 1};
        Commodity = Contract(1:end-4);
        % 导入主力合约
        if ~isKey(DataMap.MCContainer,Commodity)
            DataMap.loadMCContainer(Commodity);
        end
        MCContainer = DataMap.MCContainer(Commodity);

        % 判断Date是否属于换仓日
        logic = strcmp(Contract, MCContainer(Date));
        if ~logic % 换仓
            NewContract = MCContainer(Date);
            if ~isKey(DataMap.DayData,NewContract)
                DataMap.loadDataMap(NewContract,dataParam);
            end
            TempPlan{1,1} = NewContract;
            TempPlan{1,2} = Holding{iHld, 2};
            TempPlan{1,3} = Date*1e6;
            TempPlan{2,1} = Contract;
            TempPlan{2,2} = -Holding{iHld, 2};
            TempPlan{2,3} = Date*1e6;
            % 计算交易计划
            TradePlan = [TradePlan;TempPlan];
            % 保存交易计划
            save([ModelFolderName,  'TradePlan\', num2str(Date), '.mat'], 'TradePlan') 
            isTP = 1;                    
        end
    end
end