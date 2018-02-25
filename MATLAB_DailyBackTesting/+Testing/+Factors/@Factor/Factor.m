classdef Factor < handle
    %UNTITLED2 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        TargetHolding
        CommodityList
        MainContractMap
        AmountMat
    end
    
    methods
        function obj = Factor()
            load_AmountMat(obj);
        end        
        
        function CommodityList = get_CommodityList(obj)
            ContractList = Testing.Methods.get_ContractList();
            CommodityList = sortrows(upper(unique(regexprep(ContractList, '\d+', ''))));
            obj.CommodityList = CommodityList;
        end
        
        load_AmountMat(obj); 
    end   
    
end

