function MultiSignal = Signals( TechIndex )
%   ��������ָ��ֵ, �����ۺ�MultiSignal
    
    % ָ����
    Signal_Num = length(TechIndex);
    
    % ��һָ�겻����
    if Signal_Num == 1
       MultiSignal = TechIndex;
       return;
    end
    
    % ��ʼ��
    MultiSignal = zeros(size(TechIndex{1},1),1);
    
    % Example: ָ��ȡ���ź�ֱ�����, ֮����Կ���ML�ȷ�������
    for itemp = 1:Signal_Num
          Tech_temp = TechIndex{itemp}; 
          MultiSignal = MultiSignal + sign(Tech_temp(:,4));
    end
    
    % ÿ��ָ��TechIndexǰ������ͬ, ����Ϊ ����, ʱ��, ���̼�
    MultiSignal = [Tech_temp(:,1:3),MultiSignal];

end

