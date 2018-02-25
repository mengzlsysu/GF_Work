function Asset = settle_Asset(Asset, DataMap, DateTime,TrsParam)
%% �̺�����µĳֲּ۸���ֽ�

    % ���ֲ�ѭ��������ӯ�������¿����ֽ�ͳֲּ�
    for ii = 1:size(Asset.Holding(:, 1), 1)
        % ��ȡ������Ϣ
        Contract = Asset.Holding{ii, 1};  % ��Լ����
        Multiplier = TrsParam.Multiplier(Contract); % ��Լ����        
        
        % �����
        Mat = DataMap.DayData(Contract);
        index = find(Mat(:,1) == floor(DateTime/1e6));
        if isempty(index) == 1
            settlePrice = Asset.Holding{ii, 3};
        else
            settlePrice = Mat(index, 6);
        end

        % ����ӯ��
        Profit = Asset.Holding{ii, 2} * (settlePrice - Asset.Holding{ii, 3}) * Multiplier;      % ӯ�� = ԭ�ֲ�����������շ���*�����׼�-�ֲּۣ�*��Լ����        

        % �����ֽ���Ȩ��
        Asset.Cash = Asset.Cash + Profit;        % �ֽ� = ǰֵ + ӯ��       
        Asset.Total = Asset.Total + Profit;        % ��Ȩ�� = ǰֵ + ӯ��
        % ���³ֲ�
        Asset.Holding{ii, 3} = settlePrice;
    end

end
