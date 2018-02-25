function Orders = GenerateOrders(CommodityList, ModelParams)
%%  �����Ʒ�ز�
% 1.CommodityList �����Ʒ���Ƶ�Ԫ������
% 2.ModelParams ���initial_ModelParams

    %% 1. ��ʼ��
    % ��ʼ������
    GV = TargetOrders_MultiCommodity.Object.GlobalVar(CommodityList); 
    % ȷ����������
    TrdDate = GV.TrdDate;
    StartDate = ModelParams(1).StartDate; EndDate = ModelParams(1).EndDate;
    DateList = TrdDate((TrdDate(:,1)>= StartDate & TrdDate(:,1)<= EndDate),1);
    % ��ȡ������������Լ��Ӧ��map�ļ�    
    MCContainerList = GV.MCContainerList;
    % ��ȡ��Լ������map�ļ�
    load('MultiplierMap.mat')
    
    %% 2. �����ڼ���/����ָ�ꡢ���ɶ���    
    % ָ��ֵ�洢�� DataBase �ļ���ָ�����
    DataPath = ['..\00_DataBase\TechIndex\',ModelParams(1).TrsType,'\'];
    DailyBalance = cell(length(CommodityList),1); Orders = {};TechIndex_ContractList = {};

    for iDate = 1:length(DateList)
        Date = DateList(iDate); 
        if iDate~= 1
            LastDate = DateList(iDate-1);
        else
            LastDate = [];
        end
        % ���㵱��������Լ��Ӧ������ָ�� 
        TechIndex_ContractList = TargetOrders_MultiCommodity.Generate.ContractTIs(TechIndex_ContractList, Date, LastDate, CommodityList, ModelParams, DataPath, MCContainerList );
        if isempty(TechIndex_ContractList)
            continue;
        end        
        % ���㵱��ָ��
        TechIndex_List = TargetOrders_MultiCommodity.Generate.DailyTIs( Date, TechIndex_ContractList, ModelParams );        
        % ָ����ܳ��ź�
        MultiSignal = TargetOrders_MultiCommodity.Generate.Signal(TechIndex_List, CommodityList, ModelParams);  
        % ���ɸ����ڶ���
        DailyOrders = TargetOrders_MultiCommodity.Generate.DailyOrders(DailyBalance, MultiSignal, Date, MCContainerList, MultiplierMap);
        % ���ɸ��ճֲ�
        DailyBalance = TargetOrders_MultiCommodity.Generate.DailyBalance( DailyBalance, DailyOrders, Date, MCContainerList, CommodityList );
        % �ϲ�����
        Orders(end+1:end+size(DailyOrders,1),:) = DailyOrders;  
    end
    Orders = Orders(:,1:5);
    
    %% 3. �������ն���
    
    % ���涩��
    SavePath = ['..\05_New_BackTesting\Evaluation\',ModelParams(1).ModelName,'\',ModelParams(1).TrsType,'\'];
    for itemp = 1:length(ModelParams)
       SavePath = [SavePath,ModelParams(itemp).FileName]; 
    end
    SavePath = [SavePath,'\'];
    for itemp = 1:length(CommodityList)
       Commodity = CommodityList{itemp}; 
       SavePath = [SavePath,Commodity,'_']; 
    end    
    
    if ~isdir(SavePath)
        mkdir(SavePath);
    end
    save( [SavePath,'\Orders.mat'], 'Orders' );

end