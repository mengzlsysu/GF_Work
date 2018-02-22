function [prc] = getTrsPrice(~, tickData, trdTime, trdSide, trsParam, msgHead)
    mi = find(tickData(:,2)>=trdTime, 1, 'first');
    if isempty(mi) 
        error([msgHead ', ����ʱ��:', num2str(trdTime,'%08.1f'), ' tick��������ȱʧ.']);
    end
    if trsParam.TrsTerm==1   % ���ּ�
        prc = tickData(mi, 10+trdSide);
        if isnan(prc)
            error([msgHead, ', ����ʱ��:', num2str(tickData(mi,2),'%08.1f'), ' ��(��)1�� ����NAN.']);
        elseif prc==0 %������(��)ͣ��
            disp([msgHead, ', ����ʱ��:', num2str(tickData(mi,2),'%08.1f'), ' ��(��)ͣ��, ����tick���¼۳ɽ�.']);
%             disp(['>>>>���¼�:', tickData(mi, 3), ', ��1��:', tickData(mi,10), ', ��1��:', tickData(mi,11)]);
            prc = tickData(mi,3);
            if prc==0 || isnan(prc)
                error(['>>>>tick���¼� ����NAN��0.']);
            end
        end
    else                                       % ���¼�
        prc = tickData(mi, 3);
        if prc==0 || isnan(prc)
            error([msgHead, ', ����ʱ��:', num2str(tickData(mi,2), '%08.1f'), ' tick���¼� ����NAN��0.']);
        end
    end
end