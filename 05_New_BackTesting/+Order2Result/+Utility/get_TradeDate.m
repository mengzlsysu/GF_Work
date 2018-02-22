function TD = get_TradeDate(DateTime,TrdDate)
Time = mod(DateTime,1000000);
TempDate = fix((DateTime)/1000000);
if Time <= 153000
    index_TD = find(TrdDate(:,1)>=TempDate,1,'first');
    TD = TrdDate(index_TD,1);
else
    index_TD = find(TrdDate(:,1)>TempDate,1,'first');
    TD = TrdDate(index_TD,1);
end
