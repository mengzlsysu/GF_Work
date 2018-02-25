function update_Multiplier()
%% 更新合约乘数容器

    % 导入合约列表
    ContractList = Market.Methods.get_ContractList();
    % 导入数据容器，求出键值
    load('MultiplierMap.mat')
    Keys = MultiplierMap.keys';
    % 初始化ts
    ts = actxserver('TSExpert.CoExec');
    % 求集合差，
    Delta = setdiff(Keys,upper(ContractList));
    % 循环求出各个合约的乘数
    for ii = 1:length(Delta)
        Contract = upper(Delta{ii});
        MultiplierMap(Contract) = Testing.Multiplier.get_Multiplier(Contract,ts);
        if mod(ii, 50) == 0
            disp(num2str(ii));
        end
    end
    % 保存矩阵
    save('.\MultiplierMap.mat','MultiplierMap')
    
end