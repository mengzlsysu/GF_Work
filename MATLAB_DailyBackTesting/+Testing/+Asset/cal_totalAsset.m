function totalAsset = cal_totalAsset(Asset,TrsParam)
    
    totalAsset = Asset.Cash;
    
    for ii = 1:size(Asset.Holding(:, 1), 1)
        
        % ��ȡ������Ϣ
        Contract = Asset.Holding{ii, 1};  % ��Լ����
        Commodity = Contract(1:end-4); % ��Ʒ����
        Multiplier = TrsParam.Multiplier(Commodity); % ��Լ����
        Receive = abs(Asset.Holding{ii, 2}) * Asset.Holding{ii, 3} * Multiplier * TrsParam.Margin;  % �ջر�֤�� = �ֲּ�*�ֲ�����������ֵ��*��Լ���� * ��֤�����
        totalAsset = totalAsset + Receive;
        
    end

end