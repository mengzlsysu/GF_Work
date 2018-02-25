function generate_Multiplier()
%% 计算合约乘数

    % 导入合约列表
    ContractList = Market.Methods.get_ContractList();
    % 初始化数据容器
    MultiplierMap = containers.Map;
    % 初始化ts
    ts = actxserver('TSExpert.CoExec');
    % 循环求出各个合约的乘数
    for ii = 1:length(ContractList)
        Contract = upper(ContractList{ii});
        MultiplierMap(Contract) = Testing.Multiplier.get_Multiplier(Contract,ts);
        if mod(ii, 50) == 0
            disp(num2str(ii));
        end
    end
    % 保存矩阵
    save('.\MultiplierMap.mat','MultiplierMap')
    
end