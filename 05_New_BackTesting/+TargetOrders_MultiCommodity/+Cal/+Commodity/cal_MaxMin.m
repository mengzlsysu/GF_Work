function MultiSignal = cal_MaxMin( MultiSignal_Raw )
%   ɸѡѡ���ź�����Ʒ������, �ź���С������, ���಻����
%   MultiSignal: 1. Date 2. Time 3-end: ��Ʒ�ֶ�Ӧ�������ź�
%   ����&���յ�N��Ʒ��, �����ź�ֵΪ1/N, �����ź�ֵΪ-1/N

    % ��Ʒ��
    Commodity_Num = size(MultiSignal_Raw,2)-2;
    
    % ��ʼ��
    MultiSignal = zeros(size(MultiSignal_Raw,1),Commodity_Num);  
    
    [~,MaxID] = max(MultiSignal_Raw(:,3:end),[],2);
    [~,MinID] = min(MultiSignal_Raw(:,3:end),[],2);
    
    for itemp = 1:length(MaxID)
       % ָ�����ֵ����Сֵ���, ���� 
       if MaxID(itemp) == MinID(itemp)
           continue
       end
       MultiSignal(itemp,MaxID(itemp)) = 1/2;
       MultiSignal(itemp,MinID(itemp)) = -1/2;
    end
    
    MultiSignal = [MultiSignal_Raw(:,1:2),MultiSignal];
end

