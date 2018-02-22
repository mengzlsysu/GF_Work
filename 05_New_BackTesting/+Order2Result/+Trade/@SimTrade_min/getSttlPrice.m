function [sttl] = getSttlPrice(~, dataMap, sym, clsTime)
    if ~isKey(dataMap, sym)
        sttl=nan;
    else
        minData = dataMap(sym);
        mi = find(minData(:,2)>=clsTime & ~isnan(minData(:,6)), 1, 'last');
        if isempty(mi)
            sttl = nan;
        else
            sttl = minData(mi, 6);
        end
    end
end