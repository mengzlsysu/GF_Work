function Asset = update_Asset(Asset, TradeResult, TrsParam)
%% ���׺󣬼����µĳֲֺ��ֽ�

    % ����������Ʒ��ѭ��������ӯ���������Ѳ����¿����ֽ�
    for ind2 = 1:size(TradeResult, 1)
        % ��ȡ������Ϣ
        Contract = TradeResult{ind2, 1};  % ��Լ����
        Multiplier = TrsParam.Multiplier(Contract); % ��Լ����

        % �жϵ�ǰ����Ʒ���Ƿ���ԭ�гֲ���
        [~, ind1] = ismember(TradeResult{ind2, 1}, Asset.Holding(:, 1));  

        if ind1 > 0
            %% ԭ�гֲַ�������
            % ����ӯ��������
            Profit = Asset.Holding{ind1, 2} * (TradeResult{ind2, 3} - Asset.Holding{ind1, 3}) * Multiplier;     % ӯ�� = ԭ�ֲ�����������շ���*�����׼�-�ֲּۣ�*��Լ����
            Cost = TradeResult{ind2, 3} * abs(TradeResult{ind2, 2}) * Multiplier * TrsParam.TrsCost;            % ���׷��� = ���׼�*��������������ֵ��*��Լ���� *���׷���
            % �ջر�֤��
            Receive = abs(Asset.Holding{ind1, 2}) * Asset.Holding{ind1, 3} * Multiplier * TrsParam.Margin;  % �ջر�֤�� = �ֲּ�*�ֲ�����������ֵ��*��Լ���� * ��֤�����
            % ���³ֲ�
            TradeResult{ind2, 2} = TradeResult{ind2, 2} + Asset.Holding{ind1, 2};
            Asset.Holding(ind1, :) = TradeResult(ind2, :);
            % ֧����֤��
            Pay = abs(Asset.Holding{ind1, 2}) * (Asset.Holding{ind1, 3}) * Multiplier * TrsParam.Margin;    % ֧���ֽ� = ���׼�*��������������ֵ��*��Լ���� * ��֤�����    
            % �����ֽ�
            Asset.Cash = Asset.Cash + Profit - Cost + Receive - Pay;        % �ֽ� = ǰֵ + ӯ�� - ���׷��� + �ջر�֤�� - ֧����֤��

        else
            %% ��Ʒ�ֿ���
            % ������á�֧����֤��
            Cost = TradeResult{ind2, 3} * abs(TradeResult{ind2, 2}) * Multiplier * TrsParam.TrsCost; % ���׷��� = ���׼�*��������������ֵ��*��Լ���� *���׷���
            Pay = abs(TradeResult{ind2, 2}) * TradeResult{ind2, 3} * Multiplier * TrsParam.Margin;  % ֧���ֽ� = ���׼�*��������������ֵ��*��Լ���� * ��֤�����
            % �����ֽ�
            Asset.Cash = Asset.Cash - Cost - Pay;      % �ֽ� = ǰֵ - ���׷��� - ֧����֤��
            % ���³ֲ�        
            Asset.Holding(end+1, :) = TradeResult(ind2, :);     

        end        
    end
    
    % ɾ���ֲ���Ϊ0�ĺ�Լ
    index = find(cell2mat(Asset.Holding(:,2)) == 0);
    Asset.Holding(index, :) = [];
    
    % ������Ȩ��
    HoldingValue = 0;
    for ii = 1:size(Asset.Holding,1)
        Contract = Asset.Holding{ii, 1};  % ��Լ����
        Multiplier = TrsParam.Multiplier(Contract); % ��Լ����
        HoldingValue = HoldingValue + abs(Asset.Holding{ii, 2}) * Asset.Holding{ii, 3} * Multiplier * TrsParam.Margin;
    end
    Asset.Total = HoldingValue + Asset.Cash;
    
end
