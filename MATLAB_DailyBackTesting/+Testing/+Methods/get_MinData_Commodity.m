function MinData = get_MinData_Commodity(Contract,Date1,Date2,Period)
%% Get Commodity MinData

%% 1.Initial
if nargin <=3
    Period = '1';
else
    if ~ischar(Period)
        Period = num2str(Period);
    end
end

%
global ts
if isempty(ts)
    ts = actxserver('TSExpert.CoExec');
end

%% 2.Load data
if Date1 > 19000000
    strDate1_10 = datestr(datenum(num2str(Date1),'yyyymmdd'),'yyyy-mm-dd');
    strDate2_10 = datestr(datenum(num2str(Date2),'yyyymmdd'),'yyyy-mm-dd');
else
    strDate1_10 = datestr(Date1,'yyyy-mm-dd');
    strDate2_10 = datestr(Date2,'yyyy-mm-dd');
end

ts_quest = ['Mat = ts.RemoteExecute(''setsysparam(pn_cycle(),cy_',Period,'m());return select datetimetostr(["date"]),["open"],["high"],["low"],["close"],["vol"],["amount"],["buy1"],["sale1"],["sectional_cjbs"] from markettable datekey strtodatetime("',strDate1_10,' 15:30:00") to strtodatetime("',strDate2_10,' 15:00:00") of "',Contract,'" end;'');'];
eval(ts_quest);

if isempty(Mat)
    MinData = [];
    return
end

[RowNum,ColNum] = size(Mat);

MarketData = cell2mat(Mat(2:RowNum,2:ColNum-1));
sectional_cjbs = double(cell2mat(Mat(2:RowNum,ColNum)));
DateTime = datevec(Mat(2:RowNum,1));
Date = DateTime(:,1)*1e4+DateTime(:,2)*1e2+DateTime(:,3);
Time = DateTime(:,4)*1e4+DateTime(:,5)*1e2+DateTime(:,6);

MinData = [Date,Time,MarketData,sectional_cjbs];
