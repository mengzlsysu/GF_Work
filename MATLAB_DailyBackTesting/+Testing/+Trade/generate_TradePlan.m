function TradePlan = generate_TradePlan(Asset, DataMap, TargetHolding, DateTime, TrsParam)
%% ���ݵ�ǰ�ʲ���Ŀ��ֲֺͽ������ݣ����㽻�׽��
    
    % ���㽻�����ڣ�ע�������������Ϊ���߽��ף���DateΪ������ǰһ�죩
    Date = floor(DateTime/1e6);
    
    %% ��ƽ��Ʒ�֣�����TargetHolding��ԭ�ֲ�
    ClosePosition = setdiff(Asset.Holding(:, 1), TargetHolding(:, 1));
    TradePlan = cell(0,2);
    
    % ����ֲ��б仯��ִ��
    if size(ClosePosition, 2) ~= 0    
        for ii = 1:size(ClosePosition, 1)
            
            % ƽ��Ʒ�֡���������������ʱ��
            index = find(strcmp(Asset.Holding(:, 1), ClosePosition(ii, 1)));
            TradePlan{ii, 1} = Asset.Holding{index, 1};
            TradePlan{ii, 2} = -Asset.Holding{index, 2};
            TradePlan{ii, 3} = DateTime;
            
        end
    end
    
    if ~exist('ii', 'var') | isempty(ii)
        ii = 0;
    end
    
    %% ������/����Ʒ��
    
    for jj = 1:size(TargetHolding(:, 1), 1)
        
        % ����Ʒ������
        ii = ii+1;
        TradePlan{ii, 1} = TargetHolding{jj, 1};
        
        % �жϵ�ǰƷ���Ƿ���ԭ�гֲ���
        [~, ind1] = ismember(TradePlan{ii, 1}, Asset.Holding(:, 1));  
        
        if ind1 == 0            
        % 1.����ԭ�ֲ�֮�ڣ�����
            Contract =  TradePlan{ii, 1};  % ��Լ����         
            
            % ��������
            Mat = DataMap.DayData(Contract);
            index1 = find(Mat(:,1) == Date);
            settlePrice = Mat(index1, 6);
            % ��Լ����
            Multiplier = TrsParam.Multiplier(Contract);
            
            % ���㽻����������¼����ʱ��
            if isempty(settlePrice) == 1
                TradePlan{ii, 2} = 0;
            else
                TradePlan{ii, 2} = round(Asset.Total*TargetHolding{jj, 2}/(settlePrice*Multiplier));
            end
            TradePlan{ii, 3} = DateTime;
            
        else
        % 2.ԭ����ԭ�ֲ�֮�ڣ����㿪ƽ������
            Contract = TradePlan{ii, 1};  % ��Լ����            
            
            % ��������
            Mat = DataMap.DayData(Contract);
            index1 = find(Mat(:,1) == Date);
            settlePrice = Mat(index1, 6);
            % ��Լ����
            Multiplier = TrsParam.Multiplier(Contract);
            
            % ���㽻����������¼����ʱ��
            if isempty(settlePrice) == 1
               TradePlan{ii, 2} = 0;
            elseif sign(TargetHolding{jj, 2}) ~= sign(Asset.Holding{ind1, 2})            
               TradePlan{ii, 2} = round(Asset.Total*TargetHolding{jj, 2}/(settlePrice*Multiplier) - Asset.Holding{ind1, 2});
            else
               TradePlan{ii, 2} = 0; 
            end
            TradePlan{ii, 3} = DateTime;
        end
    end
    
end