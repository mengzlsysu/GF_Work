function MultiSignal = cal_SumSign( TechIndex_List )
%   各指标取符号加总, 计算最终信号
%   TechIndex_List: 元胞数组, 存放所有的TechIndex;  其中数组TechIndex: 1. Date 2. Time 3. Close 4. 指标值

    % 指标数
    Signal_Num = length(TechIndex_List);
    
    % 单一指标不处理
    if Signal_Num == 1
       MultiSignal = TechIndex_List;
       return;
    end
    
    % 初始化
    MultiSignal = zeros(size(TechIndex_List{1},1),1);
    
    % Example: 指标取符号后直接相加, 之后可以考虑ML等方法处理
    for itemp = 1:Signal_Num
          Tech_temp = TechIndex_List{itemp}; 
          MultiSignal = MultiSignal + sign(Tech_temp(:,4));
    end
    
    % 每个指标TechIndex前三列相同, 依次为 日期, 时刻, 收盘价
    MultiSignal = [Tech_temp(:,1:3),MultiSignal];

end

