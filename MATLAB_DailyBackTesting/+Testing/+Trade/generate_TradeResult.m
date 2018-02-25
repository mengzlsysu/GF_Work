function TradeResult = generate_TradeResult(DataMap, TradePlan, TrsParam, Asset)
%% ����TradePlan�´�ָ����ؽ��׽��TradeResult  
% ��TrsParam.TrsType�ֳ����ֲ�ͬ���㷽��

    fhandle = str2func(['generate_TradeResult_', TrsParam.TrsType]);
    TradeResult = fhandle(DataMap, TradePlan, TrsParam, Asset);
    
end


%% ���߽���
function TradeResult = generate_TradeResult_day(DataMap, TradePlan, TrsParam, Asset)
    %% 1.��ʼ��
    TradeResult = cell(size(TradePlan,1),3);
    TradeResult(:,1:2) = TradePlan(:,1:2);
    TrsParam.TrsTerm = 1;
    
    %% 2.����ִ�м۸�
    for ii = 1:size(TradeResult(:, 1), 1)  

        Contract =  TradeResult{ii, 1};  % ��Լ����       
        Date = TradePlan{ii, 3}/1e6; % �������ڣ�ע����������Ϊ���߽��ף���DateΪ������ǰһ�죩
        
        % ��������
        
        Mat = DataMap.DayData(Contract);

        index = find(Mat(:,1) == Date) + 1; % ������ΪDate�ĺ�һ��
        
        if TrsParam.TrsTerm < 5
            settlePrice = Mat(index, TrsParam.TrsTerm+2); % ����� +2������ ���ڡ�ʱ�� ����
            TradeResult{ii, 3} = settlePrice; % �ɽ��۸�
        else
            Multiplier = round(Mat(index, 8)/Mat(index, 7)/Mat(index, 6)); % ��Լ����
            settlePrice = round(Mat(index, 8)/Mat(index, 7)/Multiplier); % �����
            TradeResult{ii, 3} = settlePrice; % �ɽ��۸�
        end
        
        % �����Ҳ���������Լ�۸�/������Լ�����޷��ṩ�����ռ۸���쳣���
        if isempty(index) == 1 || size(Mat,1)<index
             % δ���и�Ʒ���Ҽƻ���Ʒ��Ϊ�ղֵ�, �ǳɽ��۸�Ϊ0 
             if TradePlan{ii, 2} == 0 % && isempty(Asset.Holding) == 1
                 ind = regexp(Contract,'\D');
                 Commodity = Contract(ind);
                 for itemp = 1:size(Asset.Holding(:,1),1)
                     Contract_temp = Asset.Holding{itemp,1};
                     ind_temp = regexp(Contract_temp,'\D');
                     Commodity_temp = Contract_temp(ind_temp);
                     if strcmp(Commodity, Commodity_temp) == 1
                         continue;
                     elseif itemp == size(Asset.Holding(:,1),1)
                         TradeResult{ii, 3} = 0;  
                         continue;
                     end                         
                 end
             end     
        end

    end
    
end

