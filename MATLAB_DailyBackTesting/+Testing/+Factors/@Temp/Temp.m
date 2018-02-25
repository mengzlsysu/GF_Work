classdef Temp < Testing.Factors.Factor
    %UNTITLED2 此处显示有关此类的摘要
    %   此处显示详细说明
    
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

        % 初始化函数, 该函数会用到下列三个函数
        initial_BackTesting(obj);        
        
        % 取指标值矩阵
        DataMap = get_DataMap(obj, CommodityList);
        
        % 生成TargetHolding
        TargetHolding = generate_TargetHolding(obj, Date, AmountMat);
        
        RH_Mat = generate_RH_Mat(obj, Date);
        
    end
    
end

