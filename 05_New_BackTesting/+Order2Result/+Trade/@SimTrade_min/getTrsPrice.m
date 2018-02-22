function [prc] = getTrsPrice(~, minData, trdTime, ~, trsParam, msgHead)
    if trdTime > 0 && trdTime < 153000
        mi = find(minData(:,2)<=trdTime, 1, 'last');
    else
        mi = find(minData(:,2)>=trdTime, 1, 'first');
    end
    if isempty(mi) 
        error([msgHead ', ����ʱ��:', num2str(trdTime,'%08.1f'), ' min��������ȱʧ.']);
    end
    
    if mi == size(minData(:,2),1)
        prc = minData(mi,6);
        return
    end
    
    if sum(minData(mi+trsParam.TrsMinS:mi+trsParam.TrsMinE,7))==0
        disp([msgHead, ',  ����ʱ��:', num2str(minData(mi+trsParam.TrsMinS,2),'%08.1f') ' �� ',...
                                                             num2str(minData(mi+trsParam.TrsMinE,2),'%08.1f'), ' ��(��)��, ����min���̼۳ɽ�.']);
        prc = minData(mi + trsParam.TrsMinS, 6);
        if isnan(prc) || prc == 0
            error('>>>>min���̼�����nan��0.');
        end
    end
    if trsParam.TrsTerm==1  % Twap
        prc = mean(minData(mi+trsParam.TrsMinS:mi+trsParam.TrsMinE,6));
        if isnan(prc) || prc == 0
            error([msgHead, ', ����ʱ��:', num2str(minData(mi+trsParam.TrsMinS,2),'%08.1f'), ' �� ',...
                                                                 num2str(minData(mi+trsParam.TrsMinE,2),'%08.1f'), ' min���̼�����nan��0.']);
        end
    else                                     % Vwap
        tmp = sum(minData(mi+trsParam.TrsMinS:mi+trsParam.TrsMinE,7:8));
        prc = tmp(2)/tmp(1);
         if isnan(prc) || prc == 0
            error([msgHead, ', ����ʱ��:', num2str(minData(mi+trsParam.TrsMinS,2),'%08.1f'), ' �� ',...
                                                                 num2str(minData(mi+trsParam.TrsMinE,2),'%08.1f'), ' min�ɽ�������nan��0.']);
         end
    end
end