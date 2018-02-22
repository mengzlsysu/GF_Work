%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: wei.he
% Date: 2016/9/30
% Discription:  ���ݽ����������飬�����Ӧ�ĵ���&���º�Լ��ǣ���ָ��������
% 1�����������
%       trdDate: double����; �� [  ...;
%                                                     20160923, 736596;
%                                                     ...]
% 2����������
%       mthTag: double����; �� [  ...;
%                                                     1610, 1611;
%                                                     ...]
%      sttlMsk:  logical����;  �� [  ...;
%                                                     0;
%                                                     ...]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mthTag,sttlMsk] = getMthTag(trdDate)
    mthTag = nan(size(trdDate, 1),2);   %1.���º�Լ��2.���º�Լ
    sttlMsk = false(size(trdDate,1),1);    %true: ������
    
    trdMth = fix(trdDate(:,1)/100); % YYYYMM
    curMth = trdMth(1);
    sttlTi = find(trdDate(:,2)>= ThirdFriday(fix(curMth/100), mod(curMth,100)), 1, 'first');
    if ~isempty(sttlTi)
        sttlMsk(sttlTi)=true;
    end
    for ti =1 : size(trdDate,1)
        if trdMth(ti)~=curMth
            curMth = trdMth(ti);
            sttlTi = find(trdDate(:,2)>= ThirdFriday(fix(curMth/100), mod(curMth,100)), 1, 'first');    % ���½�����
            if ~isempty(sttlTi)
                sttlMsk(sttlTi)=true;
            end
        end
        if isempty(sttlTi) || trdDate(ti,2) <= trdDate(sttlTi, 2)   % ���½�������ǰ
            mthTag(ti,1)= mod(curMth,10000);
            mthTag(ti,2) = calNextMth(mthTag(ti,1));
        else                                                                                        % ���½������Ժ�
            mthTag(ti,1) = calNextMth(mod(curMth,10000));
            mthTag(ti,2) = calNextMth(mthTag(ti,1));
        end
    end
end

function rst=ThirdFriday(yr, mth)
    c = calendar(yr, mth);
    if c(1,6)==0
        rst = datenum(yr, mth, c(4,6));
    else
        rst = datenum(yr, mth, c(3,6));
    end
end

function [nxtMth] = calNextMth(curMth)
    if mod(curMth,100) == 12
        nxtMth = (fix(curMth/100)+1)*100+1;
    else
        nxtMth = curMth+1;
    end
end