function Orders = GenerateOrders(Commodity, ModelParams)
%%  ������Ʒ�ز�
% 1.Commodity ��Ʒ����
% 2.ModelParams ���initial_ModelParams

    %% 1. ��ʼ��
    % ��ʼ������
    GV = TargetOrders.Object.GlobalVar(Commodity); 
    load('MultiplierMap.mat')
    % ��ȡ������Լ�б�ʹ�����
    [MainContractList, MCDuration] = TargetOrders.Cal.MCDetail(GV.MainContract);

    %% 2. ����Լ����/����ָ�ꡢ���ɶ���    
    % ָ��ֵ�洢�� DataBase �ļ���ָ�����
    DataPath = ['..\00_DataBase\TechIndex\',ModelParams(1).TrsType,'\',Commodity, '\']; 

    for iMC = 1:length(MainContractList)
        Contract = MainContractList{iMC};
        % ��ȡ��Լ����
        Mltp = MultiplierMap(Contract);        
        % ��������ָ��
        TechIndex_List = TargetOrders.Generate.TIs( Contract, ModelParams, DataPath );
        if isempty(TechIndex_List)
            continue;
        end        
        % ָ����ܳ��ź�
        MultiSignal = TargetOrders.Generate.Signal(TechIndex_List, ModelParams);
        % ���ɸú�Լ����
        ContractOrders = TargetOrders.Generate.ContractOrders(MultiSignal, MCDuration(iMC,:), Contract, Mltp, ModelParams);
        % �ϲ�����
        Orders_Raw{iMC} = ContractOrders;
    end
    
    %% 3. �������ն���
    Orders = TargetOrders.Generate.Orders(Orders_Raw, MCDuration, ModelParams);
    % ���涩��
    SavePath = ['..\05_New_BackTesting\Evaluation\',ModelParams(1).ModelName,'\',ModelParams(1).TrsType,'\'];
    for itemp = 1:length(ModelParams)
       SavePath = [SavePath,ModelParams(itemp).FileName]; 
    end
    SavePath = [SavePath,'\',Commodity];
    if ~isdir(SavePath)
        mkdir(SavePath);
    end
    save( [SavePath,'\Orders.mat'], 'Orders' );

end