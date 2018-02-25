%%
Commodity = 'TF'
Period = '1'

FolderName = ['.\Data\',Period,'min\',upper(Commodity),'\'];
if ~isdir(FolderName)
    mkdir(FolderName);
end

ContractList = {};
[Year,Month,Day] = datevec(today);
for Y = 10:Year-2000
    for M = 1:12
        ContractNum = Y*100+M; 
        if ContractNum < 1004
            continue
        end
        ContractList = [ContractList;['TF',num2str(ContractNum)]];
    end
end

TempConList = ContractList;

%%
for ii = 1:length(TempConList)
    Contract = upper(TempConList{ii});
    MinData = get_MinData_ByContract(Contract,Period);
    if isempty(MinData)
        continue
    end
    index1 = find(MinData(:,9) == 0 & MinData(:,8) == 0);
    MinData(index1,:) = [];
    save([FolderName,Contract,'.mat'],'MinData');    
end