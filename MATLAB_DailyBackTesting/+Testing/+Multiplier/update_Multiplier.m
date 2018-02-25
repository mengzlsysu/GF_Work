function update_Multiplier()
%% ���º�Լ��������

    % �����Լ�б�
    ContractList = Market.Methods.get_ContractList();
    % �������������������ֵ
    load('MultiplierMap.mat')
    Keys = MultiplierMap.keys';
    % ��ʼ��ts
    ts = actxserver('TSExpert.CoExec');
    % �󼯺ϲ
    Delta = setdiff(Keys,upper(ContractList));
    % ѭ�����������Լ�ĳ���
    for ii = 1:length(Delta)
        Contract = upper(Delta{ii});
        MultiplierMap(Contract) = Testing.Multiplier.get_Multiplier(Contract,ts);
        if mod(ii, 50) == 0
            disp(num2str(ii));
        end
    end
    % �������
    save('.\MultiplierMap.mat','MultiplierMap')
    
end