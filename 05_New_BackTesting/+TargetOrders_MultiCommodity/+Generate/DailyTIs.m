function TechIndex_List = DailyTIs( Date, TechIndex_ContractList, ModelParams )
%   ���ݺ�Լָ��ֵ��ȡ���յ�ָ��ֵ
%   TechIndex: 1. Date 2. Time 3. Close 4. ָ��ֵ
%   TechIndex_List: Ԫ������, ��Commodity����TechIndex

    TI_Num = length(ModelParams); Commodity_Num = length(TechIndex_ContractList);
    
    for iCommodity = 1:Commodity_Num
        TechIndex_Contract = TechIndex_ContractList{iCommodity};
        for iTI = 1:TI_Num
            TechIndex = TechIndex_Contract{iTI};
            TechIndex_List_temp{iTI} = TechIndex((TechIndex(:,1)==Date),:);
        end
        TechIndex_List{iCommodity} = TechIndex_List_temp;
    end

end

