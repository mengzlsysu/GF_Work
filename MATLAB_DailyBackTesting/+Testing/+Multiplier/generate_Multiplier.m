function generate_Multiplier()
%% �����Լ����

    % �����Լ�б�
    ContractList = Market.Methods.get_ContractList();
    % ��ʼ����������
    MultiplierMap = containers.Map;
    % ��ʼ��ts
    ts = actxserver('TSExpert.CoExec');
    % ѭ�����������Լ�ĳ���
    for ii = 1:length(ContractList)
        Contract = upper(ContractList{ii});
        MultiplierMap(Contract) = Testing.Multiplier.get_Multiplier(Contract,ts);
        if mod(ii, 50) == 0
            disp(num2str(ii));
        end
    end
    % �������
    save('.\MultiplierMap.mat','MultiplierMap')
    
end