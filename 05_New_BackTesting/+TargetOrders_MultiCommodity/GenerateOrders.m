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
    load('MultiplierMap.mat')
    
    %% 2. �����ڼ���/����ָ�ꡢ���ɶ���    
    % ָ��ֵ�洢�� DataBase �ļ���ָ�����
    DataPath = ['..\00_DataBase\TechIndex\',ModelParams(1).TrsType,'\'];
    
    for iDate = 1:length(DateList)
        if iDate == 6
            disp(num2str(iDate));
        end
        Date = DateList(iDate);
        % ��������ָ�� 
        TechIndex_List = TargetOrders_MultiCommodity.Generate.DailyTIs( Date, CommodityList, ModelParams, DataPath, MCContainerList );
        if isempty(TechIndex_List)
            continue;
        end        
        % ָ����ܳ��ź�
        MultiSignal = TargetOrders_MultiCommodity.Generate.Signal(TechIndex_List, ModelParams);  
        % ���ɸ����ڶ���
        DailyOrders = TargetOrders_MultiCommodity.Generate.DailyOrders(MultiSignal, Date, MCContainerList, MultiplierMap, ModelParams);
        % �ϲ�����
        Orders_Raw{iDate} = DailyOrders;        
    end
       
    %% 3. �������ն���
    Orders = TargetOrders_MultiCommodity.Generate.Orders(Orders_Raw, DateList, ModelParams);
    % ���涩��
    SavePath = ['..\05_New_BackTesting\Evaluation\',ModelParams(1).ModelName,'\',ModelParams(1).TrsType,'\'];
    for itemp = 1:length(ModelParams)
       SavePath = [SavePath,ModelParams(itemp).FileName]; 
    end
    SavePath = [SavePath,'\'];
    for itemp = 1:length(CommodityList)
       Commodity = CommodityList{itemp}; 
       SavePath = [SavePath,Commodity]; 
    end    
    
    if ~isdir(SavePath)
        mkdir(SavePath);
    end
    save( [SavePath,'\Orders.mat'], 'Orders' );

end