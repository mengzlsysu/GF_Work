%%

ContractList = Market.Methods.get_ContractList();
CommodityList = sortrows(upper(unique(regexprep(ContractList,'\d+',''))));
PeriodList = {'1','5','15'};

for ll = 1:length(CommodityList)
    Commodity = CommodityList{ll};
    for kk = 1:3
        Period = PeriodList{kk};
        
        FolderName = ['..\00_DataBase\MarketData\MinData\ByContract\',upper(Commodity),'\',Period,'min\'];
        if ~isdir(FolderName)
            mkdir(FolderName);
        end
        
        ContractList = Market.Methods.get_ContractList();
        index = find(strncmpi(ContractList,Commodity,length(Commodity)));
        
        TempConList = ContractList(index);
        
        
        %%
        for ii = 1:length(TempConList)
            Contract = upper(TempConList{ii});
            MinData = Market.Methods.get_MinData_ByContract(Contract,Period);
            if isempty(MinData)
                continue
            end
            index1 = find(MinData(:,9) == 0 & MinData(:,8) == 0);
            MinData(index1,:) = [];
            save([FolderName,Contract,'.mat'],'MinData');
        end
    end
end