function DailyBalance = DailyBalance( LastDayBalance, DailyOrders, Date, MCContainerList, CommodityList )
%   ����ÿ�ճֲ�, �������ɵ��ն���   
%   DailyBalance ��commodity���ɵ�Ԫ������, ÿ��Ԫ��: 1. ʱ�� 2. ��Լ 3. ��/�� 4. 0/1 5. ���� 6. ��λ����(ex. -0.1) 7. ����ֲ�������

    for iCommodity = 1:length(CommodityList)
        % ��ǰ��Ʒ�ֵ�������Լ
        Contract = MCContainerList{iCommodity}(Date);
        % ��Ʒ�����һ�ʽ���
        index_temp = find(strcmp(DailyOrders(:,2),Contract),1,'last');
        % �����Ʒ�ֵ����н���
        if ~isempty(index_temp)
            % ��ǰ��Ʒ�ֲֳ�
            CommodityBalance = DailyOrders(index_temp,:);
            DailyBalance{iCommodity} = CommodityBalance; 
        % �����Ʒ�ֵ���δ����, �����ճֲ���Ϊ���ճֲ�    
        else
            DailyBalance{iCommodity} = LastDayBalance{iCommodity};
        end        
    end

end

