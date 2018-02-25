function Factor2TargetHolding_LS(FactorName, R, H, LS, StartDate, EndDate)
%% ���������ɳֲ�Ŀ��

    %% 1.��ʼ��
    % ����ȱʡ����
    if nargin <= 3
        StartDate = 20100101;
        [Y, M, D] = datevec(today);
        EndDate = Y*1e4+M*1e2+D; 
    end
    
    % Ĭ�Ϸ���Ϊ5
    Group = 5;
    
    % ���ӳ�ʼ��    
    eval(['Factor = Testing.Factors.', FactorName, ';']);
    Factor.R = R;
    Factor.H = H;
    Factor.initial_BackTesting(R, H, EndDate);
    
    % ����ģ�Ͳ������ļ���
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
    
    % ��ȡ����
    load('TrdDate.mat')
    DateList = TrdDate(find(TrdDate(:, 1) >= StartDate & TrdDate(:, 1) <= EndDate)); 
    
    % ���ô�ӡ����
    PrintInfo = 1; % 0 - ����ӡ��Ϣ 1 - ��ӡ��Ϣ
    iPrint = 1; % ��ӡ������ɰٷֱ� ��ʼ��ֵ
    PrintPct = 0.05; % ��ӡ���

    
    %% 2.����TargetHolding
    for ii = 1:H:length(DateList)
        
        % ����
        Date = DateList(ii, 1);        
        
        % ����TargetHolding
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
        
        % ����TargetHolding
        save([ModelFolderName, 'TargetHolding\', num2str(Date), '.mat'], 'TargetHolding')       
        
        % ��ӡ����
        if ii/size(DateList,1) >= iPrint*PrintPct && PrintInfo ~= 0
            fprintf('%s %.2f%% TargetHolding is completed: %d \n',datestr(now,'yyyy-mm-dd HH:MM:SS'),ii/size(DateList,1)*100,DateList(ii,1));
            iPrint = iPrint + 1;
        end
        
    end

end
