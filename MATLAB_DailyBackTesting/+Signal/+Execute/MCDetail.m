function [MainContractList, MCDuration] = MCDetail(MainContract)
%% 计算主力合约的一些细节
% MainContractList 主力合约列表
% MCDuration 主力合约存续期
% 主力合约不切回

    %% 1
    MainContractList = unique(MainContract(:, 2),'stable');
    iiMC = 1;
    
    %% 2
    for iMC = 1:length(MainContractList)
        Contract = MainContractList{iMC};
        if str2double(Contract(end-3:end)) <= 500
            continue
        end
        index = find(strcmp(MainContract(:,2),Contract) == 1,1,'first');
        if iMC ~= length(MainContractList)
            NextContract = MainContractList{iMC+1};
            lastindex = find(strcmp(MainContract(:,2),NextContract) == 1,1,'first') - 1;
        else
            lastindex = size(MainContract,1);
        end
        MCDuration(iiMC,1) = MainContract{index, 1};
        MCDuration(iiMC,2) = MainContract{lastindex, 1};
        iiMC = iiMC + 1;
    end
    MainContractList = MainContractList(end-length(MCDuration)+1:end);
end