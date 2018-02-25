function MultiSignal = cal_SumSign( TechIndex_List, Commodity )
%   ��ָ��ȡ���ż���, ���������ź�
%   TechIndex_List: Ԫ������, ������е�TechIndex;  ��������TechIndex: 1. Date 2. Time 3. Close 4. ָ��ֵ
%   MultiSignal: Table�����ļ�, ����: Date, Time, Close, Commodity

    % ָ����
    Signal_Num = length(TechIndex_List);
    
    % ��һָ�겻����
    if Signal_Num == 1
       MultiSignal = TechIndex_List;
       MultiSignal = array2table(MultiSignal,'VariableNames',{'Date','Time',[Commodity,'_Close'],[Commodity,'_Signal']});
       return;
    end
    
    % ��ʼ��
    MultiSignal = zeros(size(TechIndex_List{1},1),1);
    
    % Example: ָ��ȡ���ź�ֱ�����, ֮����Կ���ML�ȷ�������
    for itemp = 1:Signal_Num
          Tech_temp = TechIndex_List{itemp}; 
          MultiSignal = MultiSignal + sign(Tech_temp(:,4));
    end
    
    % ÿ��ָ��TechIndexǰ������ͬ, ����Ϊ ����, ʱ��, ���̼�
    MultiSignal = [Tech_temp(:,1:3),MultiSignal];
    MultiSignal = array2table(MultiSignal,'VariableNames',{'Date','Time',[Commodity,'_Close'],[Commodity,'_Signal']});
    
end

