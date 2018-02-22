function ContractOrders = ContractOrders(MultiSignal, MCDuration, Contract, Multiplier, ModelParams)
%%   生成该合约存续期内的订单Orders

    %% 1.如果主力合约到期进行切换, 截矩阵加快速度
    if ModelParams(1).MCTrade == 1
        % 寻找下标
        index1 = find(MultiSignal(:, 1) < MCDuration(1) & MultiSignal(:, 2) <= 145800,1, 'last');
        if isempty(index1)
            index1 = 1;
        end    
        index2 = find(MultiSignal(:, 1) <= MCDuration(2) & MultiSignal(:, 2) <= 145900, 1, 'last');
        % 10年以前数据缺失, TechIndex从2010年才开始有数据
        if isempty(index2)
            return;
        end
        % 截取矩阵
        MultiSignal =  MultiSignal(index1:index2,:); 
    end

    %% 2.初始化, 预先分配内存提高运算速度
    Capital = 1e8;
    Str = ['买','卖'];
    ss = size(MultiSignal, 1);
    ContractOrders = cell(2*ss,5);
    % 赋值下标
    index = 1;
    
    %% 3. 计算信号
    Signal = sign(MultiSignal(:,4));
    
    %% 4. 生成订单
    for iS = 2:size(Signal,1)       
        % 最后一单
        if iS == size(Signal,1)
            % 平仓
            if Signal(iS-1) ~= 0
            ContractOrders{index, 1} = MultiSignal(iS,1)*1e6 + MultiSignal(iS,2);
            ContractOrders{index, 2} = Contract;
            ContractOrders{index, 3} = Str((Signal(iS-1)+3)/2);
            ContractOrders{index, 4} = 0;
            ContractOrders{index, 5} = ContractOrders{index-1, 5};
            % 更新下标
            index = index + 1;
            end
        elseif Signal(iS)-Signal(iS-1) ~= 0
            % 开仓
            if Signal(iS-1) == 0
                ContractOrders{index, 1} = MultiSignal(iS,1)*1e6 + MultiSignal(iS,2);
                ContractOrders{index, 2} = Contract;
                ContractOrders{index, 3} = Str((-Signal(iS)+3)/2);
                ContractOrders{index, 4} = 1;
                ContractOrders{index, 5} = round(Capital/MultiSignal(iS,3)/Multiplier);    
                % 更新下标
                index = index + 1;                    
            % 平仓    
            elseif Signal(iS) == 0
                ContractOrders{index, 1} = MultiSignal(iS,1)*1e6 + MultiSignal(iS,2);
                ContractOrders{index, 2} = Contract;
                ContractOrders{index, 3} = Str((Signal(iS-1)+3)/2);
                ContractOrders{index, 4} = 0;
                ContractOrders{index, 5} = ContractOrders{index-1, 5};   
                % 更新下标
                index = index + 1;               
            % 先平仓后开仓    
            else
                % 先平
                ContractOrders{index, 1} = MultiSignal(iS,1)*1e6 + MultiSignal(iS,2);
                ContractOrders{index, 2} = Contract;
                ContractOrders{index, 3} = Str((Signal(iS-1)+3)/2);
                ContractOrders{index, 4} = 0;
                ContractOrders{index, 5} = ContractOrders{index-1, 5};  
                % 更新下标
                index = index + 1;                   
                % 后开
                ContractOrders{index, 1} = MultiSignal(iS,1)*1e6 + MultiSignal(iS,2);
                ContractOrders{index, 2} = Contract;
                ContractOrders{index, 3} = Str((-Signal(iS)+3)/2);
                ContractOrders{index, 4} = 1;
                ContractOrders{index, 5} = round(Capital/MultiSignal(iS,3)/Multiplier);  
                % 更新下标
                index = index + 1;                    
            end
        end          
    end
    
    % 剔除未用到的空数组
    ContractOrders = ContractOrders(1:index-1,:);
    
end

