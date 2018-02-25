classdef CompoundSignals < handle
    %UNTITLED2 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        ModelNames = {};
        DataPath = '.\Evaluation\';
        THPath = {};
        StartDate = 20100101;
        EndDate = 20170929; 
        sigma = 0.05;
    end
    
    methods
        function obj = CompoundSignals()
        end
        
        addModels(obj, ModelName);              
        get_THPath(obj) ;        
        w0 = get_w0(obj, Date);        
        TargetHolding = generate_TargetHolding(obj, Date)        
        save_TargetHolding(obj)
        
    end
    
end

