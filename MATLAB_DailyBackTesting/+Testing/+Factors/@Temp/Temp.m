classdef Temp < Testing.Factors.Factor
    %UNTITLED2 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        DataMap_R
        ModelParams
        SignalPath
        BackTestCommodityList
    end
    
    methods
        function obj = Temp()
            obj = obj@Testing.Factors.Factor();
        end

        % ��ʼ������, �ú������õ�������������
        initial_BackTesting(obj);        
        
        % ȡָ��ֵ����
        DataMap = get_DataMap(obj, CommodityList);
        
        % ����TargetHolding
        TargetHolding = generate_TargetHolding(obj, Date, AmountMat);
        
        RH_Mat = generate_RH_Mat(obj, Date);
        
    end
    
end

