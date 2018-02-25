function DailyOrders = DailyOrders(LastDayBalance, MultiSignal, Date, MCContainerList, MultiplierMap)
%   ���ɸ��յĶ���Orders
%   MultiSignal{1}:  1: Date 2: Time 3-end: ��Ʒ��Close
%   MultiSignal{2}:  1: Date 2: Time 3-end: ��Ʒ�������ź�ֵ
%   DailyOrders: 1. ʱ�� 2. ��Լ 3. ��/�� 4. 0/1 5. �ñ����� 6. ��λ����(ex. -0.1) 7. ����ֲ�������
%   DailyBalance ��commodity���ɵ�Ԫ������, ÿ��Ԫ��: 1. ʱ�� 2. ��Լ 3. ��/�� 4. 0/1 5. ���� 6. ��λ����(ex. -0.1) 7. ����ֲ�������

    %% 1.��ʼ��, Ԥ�ȷ����ڴ���������ٶ�
    Capital = 1e8;
    Str = ['��','��'];
    ss = size(MultiSignal{1}, 1);
    Commodity_Num = size(MultiSignal{1}, 2)-2;
    
    %% 2. ��ȡָ�� & �����ճֲ��������Signal��һ��
    Signal = MultiSignal{2}(:,3:end);
    Signal_temp = zeros(1,Commodity_Num);
    for iCommodity = 1:Commodity_Num
        if isempty(LastDayBalance{iCommodity})
            continue
        else
            Signal_temp(iCommodity) = LastDayBalance{iCommodity}{6};
        end
    end
    Signal = [Signal_temp;Signal];
    
    %% 3. ���ɶ���
    DailyOrders = {};
    for iCommodity = 1:Commodity_Num     
        Contract = MCContainerList{iCommodity}(Date);
        % ��Ʒ�ֵ��ն�����ʼ��
        if isempty(LastDayBalance{iCommodity})
            DailyOrders_temp = [num2cell(zeros(1,7));cell(2*ss,7)]; 
        else
            DailyOrders_temp = [LastDayBalance{iCommodity};cell(2*ss,7)];             
        end
        % ������Լ����
        if ~isempty(LastDayBalance{iCommodity}) && ~strcmp(Contract,LastDayBalance{iCommodity}{2})
            ReplaceOrders = MCReplace(LastDayBalance{iCommodity}, Date, Contract);
        else
            ReplaceOrders = {}; 
        end        
        % ��ֵ�±�
        index = 2;  
        % ��Լ����
        Multiplier = MultiplierMap(Contract);
        
        for iS = 2:size(Signal,1)  
            if Signal(iS,iCommodity)-Signal(iS-1,iCommodity) ~= 0
                % ������: ��λ����ֵ��� �� �źŷ�����ͬ
                if abs(Signal(iS,iCommodity)) > abs(Signal(iS-1,iCommodity)) && Signal(iS,iCommodity)*Signal(iS-1,iCommodity) >= 0
                    DailyOrders_temp{index, 1} = MultiSignal{1}(iS-1,1)*1e6 + MultiSignal{1}(iS-1,2);
                    DailyOrders_temp{index, 2} = Contract;
                    DailyOrders_temp{index, 3} = Str((-sign(Signal(iS,iCommodity))+3)/2);
                    DailyOrders_temp{index, 4} = 1;
                    Position = abs(Signal(iS,iCommodity)) - abs(Signal(iS-1,iCommodity));
                    DailyOrders_temp{index, 5} = round(Capital*Position/MultiSignal{1}(iS-1,3)/Multiplier); 
                    DailyOrders_temp{index, 6} = Signal(iS,iCommodity);
                    DailyOrders_temp{index, 7} = sign(Signal(iS,iCommodity))*DailyOrders_temp{index, 5} + DailyOrders_temp{index-1, 7};
                    % �����±�
                    index = index + 1;                    
                % ������ƽ��: ��λ����ֵ��С �� �źŷ�����ͬ    
                elseif abs(Signal(iS,iCommodity)) < abs(Signal(iS-1,iCommodity)) && Signal(iS,iCommodity)*Signal(iS-1,iCommodity) > 0
                    DailyOrders_temp{index, 1} = MultiSignal{1}(iS-1,1)*1e6 + MultiSignal{1}(iS-1,2);
                    DailyOrders_temp{index, 2} = Contract;
                    DailyOrders_temp{index, 3} = Str((sign(Signal(iS-1,iCommodity))+3)/2);
                    DailyOrders_temp{index, 4} = 0;
                    Position = abs(Signal(iS-1,iCommodity)) - abs(Signal(iS,iCommodity));
                    DailyOrders_temp{index, 5} = round(Capital*Position/MultiSignal{1}(iS-1,3)/Multiplier); 
                    DailyOrders_temp{index, 6} = Signal(iS,iCommodity);  
                    DailyOrders_temp{index, 7} = - sign(Signal(iS,iCommodity))*DailyOrders_temp{index, 5} + DailyOrders_temp{index-1, 7};                    
                    % �����±�
                    index = index + 1;         
                % ȫ��ƽ��: ���ź�Ϊ0, Ҫ��ղ�    
                elseif abs(Signal(iS,iCommodity)) == 0
                    DailyOrders_temp{index, 1} = MultiSignal{1}(iS-1,1)*1e6 + MultiSignal{1}(iS-1,2);
                    DailyOrders_temp{index, 2} = Contract;
                    DailyOrders_temp{index, 3} = Str((sign(Signal(iS-1,iCommodity))+3)/2);
                    DailyOrders_temp{index, 4} = 0;
                    DailyOrders_temp{index, 5} = abs(DailyOrders_temp{index-1, 7});
                    DailyOrders_temp{index, 6} = Signal(iS,iCommodity);  
                    DailyOrders_temp{index, 7} = 0;
                    % �����±�
                    index = index + 1;                                   
                % ��ƽ�ֺ󿪲�: �źŷ����෴    
                elseif Signal(iS,iCommodity)*Signal(iS-1,iCommodity) < 0
                    % ����ȫƽ��
                    DailyOrders_temp{index, 1} = MultiSignal{1}(iS-1,1)*1e6 + MultiSignal{1}(iS-1,2);
                    DailyOrders_temp{index, 2} = Contract;
                    DailyOrders_temp{index, 3} = Str((sign(Signal(iS-1,iCommodity))+3)/2);
                    DailyOrders_temp{index, 4} = 0;
                    DailyOrders_temp{index, 5} = abs(DailyOrders_temp{index-1, 7});  
                    DailyOrders_temp{index, 6} = Signal(iS,iCommodity); 
                    DailyOrders_temp{index, 7} = 0;                    
                    % �����±�
                    index = index + 1;                   
                    % ��
                    DailyOrders_temp{index, 1} = MultiSignal{1}(iS-1,1)*1e6 + MultiSignal{1}(iS-1,2);
                    DailyOrders_temp{index, 2} = Contract;
                    DailyOrders_temp{index, 3} = Str((-sign(Signal(iS,iCommodity))+3)/2);
                    DailyOrders_temp{index, 4} = 1;
                    Position = abs(Signal(iS,iCommodity));
                    DailyOrders_temp{index, 5} = round(Capital*Position/MultiSignal{1}(iS-1,3)/Multiplier);   
                    DailyOrders_temp{index, 6} = Signal(iS,iCommodity);     
                    DailyOrders_temp{index, 7} = sign(Signal(iS,iCommodity))*DailyOrders_temp{index, 5};                    
                    % �����±�
                    index = index + 1;                    
                end
            end
        end 
        % �޳�Balance & δ�õ��Ŀ�����
        DailyOrders_temp = DailyOrders_temp(2:index-1,:);  
        % �ϲ������ն���
        DailyOrders = [DailyOrders;ReplaceOrders;DailyOrders_temp];
    end
    
    % ��ʱ������ 
    DailyOrders = sortrows(DailyOrders,1);
end

function ReplaceOrders = MCReplace(LSOrder, Date, Contract)
%   ���ݿ���LSOrder���ɸ���Date�Ļ���ReplaceOrder

    % δ�ֲֲ�����
    if LSOrder{6} == 0
        ReplaceOrders = {}; return
    end

    Str = {'��','��'};    
    LastContract = LSOrder{2};
    
    %   �����1��ʱ�̽�ԭ�ֲ�ƽ��
    load(['..\00_DataBase\MarketData\MinData\ByDate\',num2str(Date),'\',LastContract,'.mat'])
    ReplaceOrders{1, 1} = MinData(1,1)*1e6 + MinData(1,2);
    ReplaceOrders{1, 2} = LastContract;
    ReplaceOrders{1, 3} = Str((sign(LSOrder{6})+3)/2);
    ReplaceOrders{1, 4} = 0;
    ReplaceOrders{1, 5} = LSOrder{5};  
    ReplaceOrders{1, 6} = LSOrder{6}; 
    ReplaceOrders{1, 7} = 0;     
    
    %   �����1��ʱ������������Լ�Ͽ���
    load(['..\00_DataBase\MarketData\MinData\ByDate\',num2str(Date),'\',Contract,'.mat'])
    ReplaceOrders{2, 1} = MinData(1,1)*1e6 + MinData(1,2);
    ReplaceOrders{2, 2} = Contract;
    ReplaceOrders{2, 3} = Str((-sign(LSOrder{6})+3)/2);
    ReplaceOrders{2, 4} = 1;
    ReplaceOrders{2, 5} = LSOrder{5};  
    ReplaceOrders{2, 6} = LSOrder{6};   
    ReplaceOrders{2, 7} = LSOrder{7};    

end