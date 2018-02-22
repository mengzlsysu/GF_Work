function [sttl] = getSttlPrice(~, dataMap, sym, clsTime)
    if ~isKey(dataMap, sym)
        sttl=nan;
    else
        tickData = dataMap(sym);
        mi = find(tickData(:,2)>=clsTime & ~isnan(tickData(:,3)), 1, 'last');
        if isempty(mi)
            sttl = nan;
        else
            sttl = tickData(mi, 3);
        end
    end
end