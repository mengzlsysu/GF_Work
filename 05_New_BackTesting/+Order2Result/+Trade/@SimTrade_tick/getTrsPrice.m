function [prc] = getTrsPrice(~, tickData, trdTime, trdSide, trsParam, msgHead)
    mi = find(tickData(:,2)>=trdTime, 1, 'first');
    if isempty(mi) 
        error([msgHead ', 交易时间:', num2str(trdTime,'%08.1f'), ' tick行情数据缺失.']);
    end
    if trsParam.TrsTerm==1   % 对手价
        prc = tickData(mi, 10+trdSide);
        if isnan(prc)
            error([msgHead, ', 行情时间:', num2str(tickData(mi,2),'%08.1f'), ' 买(卖)1价 数据NAN.']);
        elseif prc==0 %处理涨(跌)停板
            disp([msgHead, ', 行情时间:', num2str(tickData(mi,2),'%08.1f'), ' 涨(跌)停板, 采用tick最新价成交.']);
%             disp(['>>>>最新价:', tickData(mi, 3), ', 卖1价:', tickData(mi,10), ', 买1价:', tickData(mi,11)]);
            prc = tickData(mi,3);
            if prc==0 || isnan(prc)
                error(['>>>>tick最新价 数据NAN或0.']);
            end
        end
    else                                       % 最新价
        prc = tickData(mi, 3);
        if prc==0 || isnan(prc)
            error([msgHead, ', 行情时间:', num2str(tickData(mi,2), '%08.1f'), ' tick最新价 数据NAN或0.']);
        end
    end
end