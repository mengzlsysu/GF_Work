function ContractOrders = ContractOrders(MultiSignal, MCDuration, Contract, Multiplier, ModelParams)
%%   ���ɸú�Լ�������ڵĶ���Orders

    %% 1.���������Լ���ڽ����л�, �ؾ���ӿ��ٶ�
    if ModelParams(1).MCTrade == 1
        % Ѱ���±�
        index1 = find(MultiSignal(:, 1) < MCDuration(1) & MultiSignal(:, 2) <= 145800,1, 'last');
        if isempty(index1)
            index1 = 1;
        end    
        index2 = find(MultiSignal(:, 1) <= MCDuration(2) & MultiSignal(:, 2) <= 145900, 1, 'last');
        % 10����ǰ����ȱʧ, TechIndex��2010��ſ�ʼ������
        if isempty(index2)
            return;
        end
        % ��ȡ����
        MultiSignal =  MultiSignal(index1:index2,:); 
    end

    %% 2.��ʼ��, Ԥ�ȷ����ڴ���������ٶ�
    Capital = 1e8;
    Str = ['��','��'];
    ss = size(MultiSignal, 1);
    ContractOrders = cell(2*ss,5);
    % ��ֵ�±�
    index = 1;
    
    %% 3. �����ź�
    Signal = sign(MultiSignal(:,4));
    
    %% 4. ���ɶ���
    for iS = 2:size(Signal,1)       
        % ���һ��
        if iS == size(Signal,1)
            % ƽ��
            if Signal(iS-1) ~= 0
            ContractOrders{index, 1} = MultiSignal(iS,1)*1e6 + MultiSignal(iS,2);
            ContractOrders{index, 2} = Contract;
            ContractOrders{index, 3} = Str((Signal(iS-1)+3)/2);
            ContractOrders{index, 4} = 0;
            ContractOrders{index, 5} = ContractOrders{index-1, 5};
            % �����±�
            index = index + 1;
            end
        elseif Signal(iS)-Signal(iS-1) ~= 0
            % ����
            if Signal(iS-1) == 0
                ContractOrders{index, 1} = MultiSignal(iS,1)*1e6 + MultiSignal(iS,2);
                ContractOrders{index, 2} = Contract;
                ContractOrders{index, 3} = Str((-Signal(iS)+3)/2);
                ContractOrders{index, 4} = 1;
                ContractOrders{index, 5} = round(Capital/MultiSignal(iS,3)/Multiplier);    
                % �����±�
                index = index + 1;                    
            % ƽ��    
            elseif Signal(iS) == 0
                ContractOrders{index, 1} = MultiSignal(iS,1)*1e6 + MultiSignal(iS,2);
                ContractOrders{index, 2} = Contract;
                ContractOrders{index, 3} = Str((Signal(iS-1)+3)/2);
                ContractOrders{index, 4} = 0;
                ContractOrders{index, 5} = ContractOrders{index-1, 5};   
                % �����±�
                index = index + 1;               
            % ��ƽ�ֺ󿪲�    
            else
                % ��ƽ
                ContractOrders{index, 1} = MultiSignal(iS,1)*1e6 + MultiSignal(iS,2);
                ContractOrders{index, 2} = Contract;
                ContractOrders{index, 3} = Str((Signal(iS-1)+3)/2);
                ContractOrders{index, 4} = 0;
                ContractOrders{index, 5} = ContractOrders{index-1, 5};  
                % �����±�
                index = index + 1;                   
                % ��
                ContractOrders{index, 1} = MultiSignal(iS,1)*1e6 + MultiSignal(iS,2);
                ContractOrders{index, 2} = Contract;
                ContractOrders{index, 3} = Str((-Signal(iS)+3)/2);
                ContractOrders{index, 4} = 1;
                ContractOrders{index, 5} = round(Capital/MultiSignal(iS,3)/Multiplier);  
                % �����±�
                index = index + 1;                    
            end
        end          
    end
    
    % �޳�δ�õ��Ŀ�����
    ContractOrders = ContractOrders(1:index-1,:);
    
end

