function MultiSignal = Signal( TechIndex_List, ModelParams )
%   ��������ָ��ֵ, �����ۺ�MultiSignal
    
    % ָ����
    Signal_Num = length(TechIndex_List);
    
    % ��һָ�겻����
    if Signal_Num == 1
       MultiSignal = TechIndex_List;
       return;
    end
    
    % �༼��ָ�������źŵļ��㷽��
    TI2Signal = ModelParams(1).TI2Signal;
    
    % ���ɾ��
    fhandle = str2func(['TargetOrders.Cal.Signal.cal_', TI2Signal]);    
    MultiSignal = fhandle(TechIndex_List);

end

