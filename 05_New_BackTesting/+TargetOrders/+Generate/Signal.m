function MultiSignal = Signal( TechIndex_List, ModelParams )
%   根据所有指标值, 计算综合MultiSignal
    
    % 指标数
    Signal_Num = length(TechIndex_List);
    
    % 单一指标不处理
    if Signal_Num == 1
       MultiSignal = TechIndex_List;
       return;
    end
    
    % 多技术指标生成信号的计算方法
    TI2Signal = ModelParams(1).TI2Signal;
    
    % 生成句柄
    fhandle = str2func(['TargetOrders.Cal.Signal.cal_', TI2Signal]);    
    MultiSignal = fhandle(TechIndex_List);

end

