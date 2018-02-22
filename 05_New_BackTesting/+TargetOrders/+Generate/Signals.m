function MultiSignal = Signals( TechIndex )
%   根据所有指标值, 计算综合MultiSignal
    
    % 指标数
    Signal_Num = length(TechIndex);
    
    % 单一指标不处理
    if Signal_Num == 1
       MultiSignal = TechIndex;
       return;
    end
    
    % 初始化
    MultiSignal = zeros(size(TechIndex{1},1),1);
    
    % Example: 指标取符号后直接相加, 之后可以考虑ML等方法处理
    for itemp = 1:Signal_Num
          Tech_temp = TechIndex{itemp}; 
          MultiSignal = MultiSignal + sign(Tech_temp(:,4));
    end
    
    % 每个指标TechIndex前三列相同, 依次为 日期, 时刻, 收盘价
    MultiSignal = [Tech_temp(:,1:3),MultiSignal];

end

