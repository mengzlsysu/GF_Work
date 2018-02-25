function [MainContractList, MCDuration] = MCDetail(MainContract)
%% 计算主力合约的一些细节
% MainContractList 主力合约列表
% MCDuration 主力合约存续期
% 主力合约不切回

    %% 1
    MainContractList = unique(MainContract(:, 2));
    
    %% 2
    for iMC = 1:length(MainContractList)
        Contract = MainContractList{iMC};
        index = find(strcmp(MainContract(:,2),Contract) == 1,1,'first');
        if iMC ~= length(MainContractList)
            NextContract = MainContractList{iMC+1};
            lastindex = find(strcmp(MainContract(:,2),NextContract) == 1,1,'first') - 1;
        else
            lastindex = size(MainContract,1);
        end
        MCDuration(iMC,1) = MainContract{index, 1};
        MCDuration(iMC,2) = MainContract{lastindex, 1};
    end
    
end