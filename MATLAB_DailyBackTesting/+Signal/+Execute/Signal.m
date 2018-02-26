function MultiSignal = Signal( TechIndex_List, MCDuration, ModelParams )
%   根据所有指标值, 计算综合MultiSignal, 再根据MCDuration切割出主力合约时间段内的指标值
%   MultiSignal: 1. Date 2. Time 3. Close 4. 最终指标值

%%  1. 生成最终指标

    % 指标数
    Signal_Num = length(TechIndex_List);   
    % 单一指标不处理
    if Signal_Num == 1
        MultiSignal = TechIndex_List{1};
    else
        % 多技术指标生成信号的计算方法
        TI2Signal = ModelParams(1).TI2Signal;

        % 生成句柄
        fhandle = str2func(['Signal.Signal.cal_', TI2Signal]);    
        MultiSignal = fhandle(TechIndex_List);
    end

%%  2. 切割出主力合约时间段内的指标值

    % 起始日期
    StartDate = ModelParams(1).StartDate; EndDate = ModelParams(1).EndDate;
    MCDuration(1) = max(MCDuration(1),StartDate);
    MCDuration(2) = min(MCDuration(2),EndDate);
    
    % 寻找下标
    index1 = find(MultiSignal(:, 1) >= MCDuration(1), 1, 'first');
    index2 = find(MultiSignal(:, 1) <= MCDuration(2), 1, 'last');
    % 截取矩阵
    MultiSignal =  MultiSignal(index1:index2,:);     
    
end

