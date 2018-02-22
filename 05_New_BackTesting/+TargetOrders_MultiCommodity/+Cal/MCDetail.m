function [MainContractList, MCDuration] = MCDetail(MainContract)
%% ����������Լ��һЩϸ��
% MainContractList ������Լ�б�
% MCDuration ������Լ������

    %% 1
    MainContractList = unique(MainContract(:, 2));
    
    %% 2
    for iMC = 1:length(MainContractList)
        Contract = MainContractList{iMC};
        index = find(strcmp(MainContract(:,2),Contract) == 1);
        MCDuration(iMC,1) = MainContract{index(1), 1};
        MCDuration(iMC,2) = MainContract{index(end), 1};
    end
    
end