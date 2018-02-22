function DailyOrders = DailyOrders(MultiSignal, Date, MCContainerList, MultiplierMap, ModelParams)
%   ���ɸ��յĶ���Orders
%   MultiSignal{1}:  1: Date 2: Time 3-end: ��Ʒ��Close
%   MultiSignal{2}:  1: Date 2: Time 3-end: ��Ʒ�������ź�ֵ
%   DailyOrders: 1. ʱ�� 2. ��Լ 3. ��/�� 4. 0/1 5. ����

    %% 1.��ʼ��, Ԥ�ȷ����ڴ���������ٶ�
    Capital = 1e8;
    Str = ['��','��'];
    ss = size(MultiSignal{1}, 1);
    Commodity_Num = size(MultiSignal{1}, 2)-2;
    DailyOrders = cell(2*Commodity_Num*ss,5);
    % ��ֵ�±�
    index = 1;
    
    %% 2. ��ȡָ��
    Signal = MultiSignal{2}(:,3:end);
    
    %% 3. ���ɶ���
    for iS = 2:size(Signal,1)  
        for iCommodity = 1:Commodity_Num
            Contract = MCContainerList{iCommodity}(Date);
            Multiplier = MultiplierMap(Contract);
            if Signal(iS,iCommodity)-Signal(iS-1,iCommodity) ~= 0
                % ����
                if Signal(iS-1,iCommodity) == 0
                    DailyOrders{index, 1} = MultiSignal{1}(iS,1)*1e6 + MultiSignal{1}(iS,2);
                    DailyOrders{index, 2} = Contract;
                    DailyOrders{index, 3} = Str((-sign(Signal(iS,iCommodity))+3)/2);
                    DailyOrders{index, 4} = 1;
                    DailyOrders{index, 5} = round(Capital*abs(Signal(iS,iCommodity))/MultiSignal{1}(iS,3)/Multiplier);    
                    % �����±�
                    index = index + 1;                    
                % ƽ��    
                elseif Signal(iS,iCommodity) == 0 && index>1
                    DailyOrders{index, 1} = MultiSignal{1}(iS,1)*1e6 + MultiSignal{1}(iS,2);
                    DailyOrders{index, 2} = Contract;
                    DailyOrders{index, 3} = Str((sign(Signal(iS-1,iCommodity))+3)/2);
                    DailyOrders{index, 4} = 0;
                    DailyOrders{index, 5} = DailyOrders{index-1, 5};   
                    % �����±�
                    index = index + 1;               
                % ��ƽ�ֺ󿪲�    
                elseif index>1
                    % ��ƽ
                    DailyOrders{index, 1} = MultiSignal{1}(iS,1)*1e6 + MultiSignal{1}(iS,2);
                    DailyOrders{index, 2} = Contract;
                    DailyOrders{index, 3} = Str((sign(Signal(iS,iCommodity))+3)/2);
                    DailyOrders{index, 4} = 0;
                    DailyOrders{index, 5} = DailyOrders{index-1, 5};  
                    % �����±�
                    index = index + 1;                   
                    % ��
                    DailyOrders{index, 1} = MultiSignal{1}(iS,1)*1e6 + MultiSignal{1}(iS,2);
                    DailyOrders{index, 2} = Contract;
                    DailyOrders{index, 3} = Str((-sign(Signal(iS,iCommodity))+3)/2);
                    DailyOrders{index, 4} = 1;
                    DailyOrders{index, 5} = round(Capital*abs(Signal(iS,iCommodity))/MultiSignal{1}(iS,3)/Multiplier);   
                    % �����±�
                    index = index + 1;                    
                end
            end
        end          
    end
    
    % �޳�δ�õ��Ŀ�����
    DailyOrders = DailyOrders(1:index-1,:);    

end

