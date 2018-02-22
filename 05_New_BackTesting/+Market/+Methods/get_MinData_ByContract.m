function MinData = get_MinData_ByContract(Contract,Period)
%% 1.Initial
if nargin <= 1
    Period = '1';
else
    if ~ischar(Period)
        Period = num2str(Period);
    end
end

%% 2.Get MinData
DateStr = regexp(Contract,'\d+','match');
Date2Str = ['20',DateStr{1},'31'];
Date2 = str2double(Date2Str);
Date1 = Date2 - 20030;
MinData = Market.Methods.get_MinData_Commodity(Contract,Date1,Date2,Period);