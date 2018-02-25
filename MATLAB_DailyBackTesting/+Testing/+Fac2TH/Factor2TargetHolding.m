function Factor2TargetHolding(ModelFolderName, SignalPath, CommodityList, ModelParams)
%% ���ɳֲ�Ŀ��

    %% 1.��ʼ��
    % ��ȡ����
    StartDate = ModelParams(1).StartDate;
    EndDate = ModelParams(1).EndDate;  
    
    load('..\00_DataBase\Edited_Factor\Amount\AmountMat.mat', 'AmountMat');
    % ���ӳ�ʼ��    
    Factor = Testing.Factors.Temp;
    Factor.ModelParams = ModelParams;
    Factor.SignalPath = SignalPath;
    Factor.BackTestCommodityList = CommodityList;

    Factor.initial_BackTesting();
    
    % ���û���ļ���, �����ļ���
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
    
    % ��ȡ����
    load('TrdDate.mat')
    DateList = TrdDate(find(TrdDate(:, 1) >= StartDate & TrdDate(:, 1) <= EndDate)); 
    
    % ���ô�ӡ����
    PrintInfo = 1; % 0 - ����ӡ��Ϣ 1 - ��ӡ��Ϣ
    iPrint = 1; % ��ӡ������ɰٷֱ� ��ʼ��ֵ
    PrintPct = 0.05; % ��ӡ���

    % ��������
    H = ModelParams(1).H;
    
    %% 2.����TargetHolding
    for ii = 1:H:length(DateList)
        
        % ����
        Date = DateList(ii, 1);        
        
        % ����TargetHolding
        TargetHolding = Factor.generate_TargetHolding(Date, AmountMat);
        
        % ����TargetHolding, ����ǿռ�����, ���Ϊ�մ���δ����
        if isempty(TargetHolding) == 0 
            save([ModelFolderName, 'TargetHolding\', num2str(Date), '.mat'], 'TargetHolding')  
        end
        
        % ��ӡ����
        if ii/size(DateList,1) >= iPrint*PrintPct && PrintInfo ~= 0
            fprintf('%s %.2f%% TargetHolding is completed: %d \n',datestr(now,'yyyy-mm-dd HH:MM:SS'),ii/size(DateList,1)*100,DateList(ii,1));
            iPrint = iPrint + 1;
        end
        
    end
  
end
