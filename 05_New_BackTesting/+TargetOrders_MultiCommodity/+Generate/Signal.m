function MultiSignal = Signal( TechIndex_List, ModelParams )
%   ��������ָ��ֵ, �����ۺ�MultiSignal
%   MultiSignal{1}:  1: Date 2: Time 3-end: ��Ʒ��Close
%   MultiSignal{2}:  1: Date 2: Time 3-end: ��Ʒ�������ź�ֵ
    
    % ����ָ����/��Ʒ��
    Commodity_Num = length(TechIndex_List);
    
    % ��ʼ��
    MultiSignal{1} = TechIndex_List{1}{1}(:,1:2); MultiSignal{2} = MultiSignal{1};

    %% 1. ���ÿ��Ʒ��, ���༼��ָ�����ɸ�Ʒ�������ź�, ����: �źŻ����Ը�ָ��ȡ���ż���
    
    % �༼��ָ�������źŵļ��㷽��
    TI2Signal = ModelParams(1).TI2Signal;
    
    for iCommodity = 1:Commodity_Num
        % ���ɾ��
        fhandle = str2func(['TargetOrders_MultiCommodity.Cal.Signal.cal_', TI2Signal]);  
        MultiSignal_Commodity = fhandle(TechIndex_List{iCommodity});
        MultiSignal{2} = [MultiSignal{2},MultiSignal_Commodity(:,4)];
        MultiSignal{1} = [MultiSignal{1},TechIndex_List{iCommodity}{1}(:,3)];
    end

    %% 2. ��Ը���Ʒ�ֵ�ָ��ֵ, ɸѡ�����в�����Ʒ��, ����: ɸѡѡ���ź���������, �ź���С������, ���಻��
    
    Signal2Commodity = ModelParams(1).Signal2Commodity;
    
    % ���ɾ��
    fhandle = str2func(['TargetOrders_MultiCommodity.Cal.Commodity.cal_', Signal2Commodity]); 
    MultiSignal{2} = fhandle(MultiSignal{2});
    
end

