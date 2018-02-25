% Commodity = 'ru';
% ContractList = get_ContractList(Commodity);
ContractList = Market.Methods.get_ContractList();

SaveFolderName = '..\00_DataBase\MarketData\MinData\ByDate\';
if ~exist(SaveFolderName,'dir')
    mkdir(SaveFolderName);
end

StartDate = 20100104;
EndDate = str2double(datestr(today,'yyyymmdd'));
load('TrdDate.mat')
TDList = TrdDate(find(TrdDate(:,1) >= StartDate & TrdDate(:,1) <= EndDate));

Period = 1;

for iTD = 2:length(TDList)
    Date1 = TDList(iTD-1);
    Date2 = TDList(iTD);

    SaveFolderName1 = [SaveFolderName,num2str(Date2),'\'];
    if ~exist(SaveFolderName1,'dir')
        mkdir(SaveFolderName1);
    end
    
    for iContract = 1:length(ContractList)
        Contract = ContractList{iContract};
        MinData = Market.Methods.get_MinData_Commodity(Contract,Date1,Date2,Period);
        if ~isempty(MinData)
            save([SaveFolderName1,upper(Contract),'.mat'],'MinData')
        end
    end
end