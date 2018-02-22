function [prc] = getTrsPrice(~, minData, trdTime, ~, trsParam, msgHead)
    if trdTime > 0 && trdTime < 153000
        mi = find(minData(:,2)<=trdTime, 1, 'last');
    else
        mi = find(minData(:,2)>=trdTime, 1, 'first');
    end
    if isempty(mi) 
        error([msgHead ', 交易时间:', num2str(trdTime,'%08.1f'), ' min行情数据缺失.']);
    end
    
    if mi == size(minData(:,2),1)
        prc = minData(mi,6);
        return
    end
    
    if sum(minData(mi+trsParam.TrsMinS:mi+trsParam.TrsMinE,7))==0
        disp([msgHead, ',  行情时间:', num2str(minData(mi+trsParam.TrsMinS,2),'%08.1f') ' 至 ',...
                                                             num2str(minData(mi+trsParam.TrsMinE,2),'%08.1f'), ' 涨(跌)板, 采用min收盘价成交.']);
        prc = minData(mi + trsParam.TrsMinS, 6);
        if isnan(prc) || prc == 0
            error('>>>>min收盘价数据nan或0.');
        end
    end
    if trsParam.TrsTerm==1  % Twap
        prc = mean(minData(mi+trsParam.TrsMinS:mi+trsParam.TrsMinE,6));
        if isnan(prc) || prc == 0
            error([msgHead, ', 行情时间:', num2str(minData(mi+trsParam.TrsMinS,2),'%08.1f'), ' 至 ',...
                                                                 num2str(minData(mi+trsParam.TrsMinE,2),'%08.1f'), ' min收盘价数据nan或0.']);
        end
    else                                     % Vwap
        tmp = sum(minData(mi+trsParam.TrsMinS:mi+trsParam.TrsMinE,7:8));
        prc = tmp(2)/tmp(1);
         if isnan(prc) || prc == 0
            error([msgHead, ', 行情时间:', num2str(minData(mi+trsParam.TrsMinS,2),'%08.1f'), ' 至 ',...
                                                                 num2str(minData(mi+trsParam.TrsMinE,2),'%08.1f'), ' min成交额数据nan或0.']);
         end
    end
end