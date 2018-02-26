function GenerateSignals( CommodityList, SignalPath, ModelParams )
%   ��������Ʒ������Ӧʱ���ڵ�����ָ��ֵ, ���洢����Ӧλ��

%   ��ÿ��Ʒ��������Ӧ������ָ��ֵ
    for iCommodity = 1:length(CommodityList)
        Commodity = CommodityList{iCommodity};    
        if exist([SignalPath,Commodity,'.mat'])
            continue
        end
        GenerateCommoditySignal( Commodity, SignalPath, ModelParams )
    end

end

function GenerateCommoditySignal( Commodity, SignalPath, ModelParams )
%   �����Ʒ������ָ��ֵ, ������

    %% 0. ��ʼ��   
    GV = Signal.Object.GlobalVar(Commodity);    
    % ��ȡ������Լ�б�ʹ�����
    [MainContractList, MCDuration] = Signal.Execute.MCDetail(GV.MainContract);
    % ��ʼ����
    StartDate = ModelParams(1).StartDate; EndDate = ModelParams(1).EndDate;     

    %% 1. ����Լ����ָ��
    % ��Լָ��ֵ�洢�� DataBase �ļ���ָ�����
    DataPath = ['..\00_DataBase\TechIndex\',ModelParams(1).TrsType,'\',Commodity, '\']; 
    MultiSignal = [];
    
    for iMC = 1:length(MainContractList)
        % �ú�Լ��δ�ﵽ��ʼ���� 
        if MCDuration(iMC,2)<StartDate || MCDuration(iMC,1)>EndDate
            continue;
        end
        Contract = MainContractList{iMC};
        % ��������ָ��
        TechIndex_List = Signal.Execute.TIs( Contract, ModelParams, DataPath );
        if isempty(TechIndex_List)
            continue;
        end        
        % ָ����ܳ��ź�
        MultiSignal_Contract = Signal.Execute.Signal(TechIndex_List, MCDuration(iMC,:), ModelParams);  
        % ����Լƴ�ӳ���Ʒ�����ź�
        MultiSignal(end+1:end+size(MultiSignal_Contract,1),:) = MultiSignal_Contract; 
    end
    
    %% 2. ����ָ��
    
    if ~isdir(SignalPath)
        mkdir(SignalPath);
    end
    save([SignalPath,Commodity,'.mat'],'MultiSignal');
    
end