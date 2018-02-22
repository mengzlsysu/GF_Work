function Multiplier = cal_Multiplier(Commodity,Date)

FileName = ['..\00_DataBase\MarketData\DayData\',Commodity,'\byDate\',num2str(Date),'.mat'];
load(FileName)
if isempty(DayData)
    Multiplier = NaN;
else
    [~,index] = max(DayData(:,6));
    Multiplier = round(2*DayData(index,7)/DayData(index,6)/DayData(index,5),-1)/2;
    if Multiplier == 0
        Multiplier = round(1e4*DayData(index,7)/DayData(index,6)/DayData(index,5),-1);
    end
end

