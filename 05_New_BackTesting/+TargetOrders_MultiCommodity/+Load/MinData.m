function MinData = MinData(ContractName, Minutes)
%% load MinData

    if nargin == 1
        Minutes = '1';
    elseif isnumeric(Minutes)
        Minutes = num2str(Minutes);
    end
    
    Commodity = ContractName(1:end-4);
    DataPath = ['..\00_DataBase\MarketData\MinData\ByContract\',Commodity,'\',Minutes,'min\'];
    
    load([DataPath,ContractName])

end