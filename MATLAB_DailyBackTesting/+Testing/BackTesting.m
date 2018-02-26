function Stats = BackTesting(ModelName, Params, Holding, Commodity, LS)
%% �����Ӳ���
%   ����Params���Model���в���, Holding�����ֲ��ڳ���, һ��Ϊ5�ı���(��1�ܵı���)
%   Commodity���Ϊ0���������е���Ʒ�ز�
%   LS��������, ex: 1����ָ��ֵ˳�����к�, ���ڵ�1���ڵ��ڻ����лز�

% profile on

    if nargin <= 3
        Commodity = 0;
        LS = 0;
    elseif nargin <= 4 
        LS = 0;
    end
    close all
    %% 1.��ʼ��
    % ��ȡ����
    StartDate = 20100104;
    EndDate = 20170831;    
    load('TrdDate.mat')
    DateList = TrdDate(find(TrdDate(:, 1) >= StartDate & TrdDate(:, 1) <= EndDate), :);  
    
    % ����ģ�Ͳ������ļ���
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
    % ����ļ��в����ڣ�����TargetHolding���������ļ���
    if ~isdir(ModelFolderName)
        FactorName = ModelName;
        if LS == 0
            TestingForSingle.Fac2TH.Factor2TargetHolding(FactorName, Params, H, Commodity, StartDate, EndDate);   
        else    
            TestingForSingle.Fac2TH.Factor2TargetHolding_LS(FactorName, Params, H, Commodity, StartDate, EndDate);               
        end
    end 
    CommodityName = Commodity;
    
    % �����ļ���
    TradeVariables = {'Asset', 'TargetHolding','TradePlan','TradeResult'};
    for iTV = 1:length(TradeVariables)
        FolderName = [ModelFolderName, TradeVariables{iTV}, '\'];
        if ~isdir(FolderName)
            mkdir(FolderName);
        end
    end
    
    % ��ʼ��Asset
    InitialCapital = 1e8;
    Asset.Holding = cell(0,3);
    Asset.Cash = InitialCapital;
    Asset.Total = InitialCapital;
    totalAsset = zeros(length(DateList), 1);
    
    % ��ʼ��Stats    
    Stats(:, 1:2) = DateList;
    
    % ���ý��ײ���
    TestingForSingle.Setting.initial_TrsParam;
    
    % �г����ݳ�ʼ��
    DataMap = TestingForSingle.DataMap;
    dataParam.Type = 'DayData';
    dataParam.Period = '';
    
    % �ж��Ƿ����TP, (exist����)
    isTP = 0;
    
    % ���ô�ӡ����
    PrintInfo = 1; % 0 - ����ӡ��Ϣ 1 - ��ӡ��Ϣ
    iPrint = 1; % ��ӡ������ɰٷֱ� ��ʼ��ֵ
    PrintPct = 0.05; % ��ӡ���
    
    %% 2.�ز�
    for ii = 1:length(DateList)
            
        % ��ȡ����
        Date = DateList(ii, 1);
        DateTime = Date*1e6;
        if ii > 1
            LastDate = DateList(ii-1, 1);
        else
            LastDate = 0;
        end

        %% ִ�н��׼ƻ�
        TPFileName = [ModelFolderName, 'TradePlan\', num2str(LastDate), '.mat'];
        
        % �����Ƿ����TP, exist��ʱ
        if isTP == 1 && exist(TPFileName, 'file')
            % ����TradePlan
            load(TPFileName);
            % ���㽻�׽��
            TradeResult = TestingForSingle.Trade.generate_TradeResult(DataMap, TradePlan, TrsParam, Asset);
            % �����ʲ��仯
            Asset = TestingForSingle.Asset.update_Asset(Asset, TradeResult, TrsParam);            
            % ���潻�׽��
            save([ModelFolderName, 'TradeResult\', num2str(Date), '.mat'], 'TradeResult')            
        end

        %% ÿ�ս��㡢�����ļ�
        Asset = TestingForSingle.Asset.settle_Asset(Asset, DataMap, DateTime,TrsParam); 
        Holding = Asset.Holding;        
        % ��TPʱ ����Holding, Cash, Asset 
        if isTP == 1        
            HoldingList{ii} = Asset.Holding;
            Cash{ii} = Asset.Cash;
            Total{ii} = Asset.Total;   
            isTP = 0;
        end
        % ��������Asset�ܱ�
        if ii == length(DateList) 
            try HoldingList;
                save([ModelFolderName, 'Asset\AssetTotal.mat'], 'HoldingList', 'Cash', 'Total') 
            catch
            end
        end

        %% �ⶨ���׼ƻ�
        THFileName = [ModelFolderName, 'TargetHolding\', num2str(Date), '.mat'];         
        % ÿ�� ������H �ⶨ���׼ƻ� 
        if rem(ii-1,H) == 0 && exist(THFileName, 'file') % ͨ��TargetHolding�ⶨ���׼ƻ�
            % ����TargetHolding
            load(THFileName);            
            % ������غ�Լ����
            for iTH = 1:size(TargetHolding, 1)
                Contract = TargetHolding{iTH, 1};
                if ~isKey(DataMap.DayData,Contract)
                    DataMap.loadDataMap(Contract,dataParam);
                end
            end            
            % ���㽻�׼ƻ�������
            TradePlan = TestingForSingle.Trade.generate_TradePlan(Asset, DataMap, TargetHolding, DateTime, TrsParam);
            % ���潻�׼ƻ�
            save([ModelFolderName,  'TradePlan\', num2str(Date), '.mat'], 'TradePlan')
            isTP = 1;            
                
        else %û��TargetHolding������¼���Ƿ���Ҫ����
            [TradePlan, isTP] = MCReplacement( Date, Holding, DataMap, ModelFolderName, dataParam );
        end
        
        %% ��ӡ����
        if ii/size(DateList,1) >= iPrint*PrintPct && PrintInfo ~= 0
            fprintf('%s %.2f%% BackTesting is completed: %d \n',datestr(now,'yyyy-mm-dd HH:MM:SS'),ii/size(DateList,1)*100,DateList(ii,1));
            iPrint = iPrint + 1;
        end
    
        % �������ʲ�
        totalAsset(ii, 1) = Asset.Total;

    end  

    % ���������ļ�Stats������
    Stats(:, 3) = totalAsset;
    Stats(:, 4) = totalAsset/InitialCapital;
    save([ModelFolderName, 'Stats.mat'], 'Stats')
    
    TestingForSingle.Stats.plot_NetValue( ModelFolderName, H, CommodityName, DateList, Stats);
    TestingForSingle.Stats.cal_RetraceRatio( Stats(:,4), Stats(:,2) );
% profile viewer  
end


function [TradePlan, isTP] = MCReplacement( Date, Holding, DataMap, ModelFolderName, dataParam )
%   ������Լ����
    
    % ��ʼ��
    isTP = 0; TradePlan = {};    
    % ����Holding�ж��Ƿ񻻲�
    for iHld = 1:size(Holding, 1)
        Contract = Holding{iHld, 1};
        Commodity = Contract(1:end-4);
        % ����������Լ
        if ~isKey(DataMap.MCContainer,Commodity)
            DataMap.loadMCContainer(Commodity);
        end
        MCContainer = DataMap.MCContainer(Commodity);

        % �ж�Date�Ƿ����ڻ�����
        logic = strcmp(Contract, MCContainer(Date));
        if ~logic % ����
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
            % ���㽻�׼ƻ�
            TradePlan = [TradePlan;TempPlan];
            % ���潻�׼ƻ�
            save([ModelFolderName,  'TradePlan\', num2str(Date), '.mat'], 'TradePlan') 
            isTP = 1;                    
        end
    end
end