function MultiSignal = Signal( TechIndex_List, CommodityList, ModelParams )
%   ��������ָ��ֵ, �����ۺ�MultiSignal
%   MultiSignal{1}:  1: Date 2: Time 3-end: ��Ʒ��Close
%   MultiSignal{2}:  1: Date 2: Time 3-end: ��Ʒ�������ź�ֵ
    
    % ����ָ����/��Ʒ��
    Commodity_Num = length(TechIndex_List);

    %% 1. ���ÿ��Ʒ��, ���༼��ָ�����ɸ�Ʒ�������ź�, ����: �źŻ����Ը�ָ��ȡ���ż���
    
    % �༼��ָ�������źŵļ��㷽��
    TI2Signal = ModelParams(1).TI2Signal;
    
    for iCommodity = 1:Commodity_Num
        Commodity = CommodityList{iCommodity};
        % ���ɾ��
        fhandle = str2func(['TargetOrders_MultiCommodity.Cal.Signal.cal_', TI2Signal]);  
        MultiSignal_Commodity = fhandle(TechIndex_List{iCommodity},Commodity);
        % ��ʼ��        
        if iCommodity == 1
            MultiSignal{1} = MultiSignal_Commodity(:,1:3); MultiSignal{2} = MultiSignal_Commodity(:,[1 2 4]);
        % ���ڲ���Ʒ��ĳЩ����ȱ����, ֻ�ܶԶ������ݵĲ��ֽ��в���    
        else
            MultiSignal{1} = innerjoin(MultiSignal{1},MultiSignal_Commodity(:,2:3));
            MultiSignal{2} = innerjoin(MultiSignal{2},MultiSignal_Commodity(:,[2 4])); 
        end
    end
    
    MultiSignal{1} = table2array(MultiSignal{1}); MultiSignal{2} = table2array(MultiSignal{2}); 
    %% 2. ��Ը���Ʒ�ֵ�ָ��ֵ, ɸѡ�����в�����Ʒ��, ����: ɸѡѡ���ź���������, �ź���С������, ���಻��
    
    Signal2Commodity = ModelParams(1).Signal2Commodity;
    
    % ���ɾ��
    fhandle = str2func(['TargetOrders_MultiCommodity.Cal.Commodity.cal_', Signal2Commodity]); 
    MultiSignal{2} = fhandle(MultiSignal{2});
    
end

