%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: wei.he
% Date: 2016/9/30
% Discription:  根据交易日期数组，计算对应的当月&次月合约标记，并指出交割日
% 1，输入参数：
%       trdDate: double数组; 例 [  ...;
%                                                     20160923, 736596;
%                                                     ...]
% 2，输出结果：
%       mthTag: double数组; 例 [  ...;
%                                                     1610, 1611;
%                                                     ...]
%      sttlMsk:  logical数组;  例 [  ...;
%                                                     0;
%                                                     ...]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mthTag,sttlMsk] = getMthTag(trdDate)
    mthTag = nan(size(trdDate, 1),2);   %1.当月合约，2.次月合约
    sttlMsk = false(size(trdDate,1),1);    %true: 交割日
    
    trdMth = fix(trdDate(:,1)/100); % YYYYMM
    curMth = trdMth(1);
    sttlTi = find(trdDate(:,2)>= ThirdFriday(fix(curMth/100), mod(curMth,100)), 1, 'first');
    if ~isempty(sttlTi)
        sttlMsk(sttlTi)=true;
    end
    for ti =1 : size(trdDate,1)
        if trdMth(ti)~=curMth
            curMth = trdMth(ti);
            sttlTi = find(trdDate(:,2)>= ThirdFriday(fix(curMth/100), mod(curMth,100)), 1, 'first');    % 该月交割日
            if ~isempty(sttlTi)
                sttlMsk(sttlTi)=true;
            end
        end
        if isempty(sttlTi) || trdDate(ti,2) <= trdDate(sttlTi, 2)   % 该月交割日以前
            mthTag(ti,1)= mod(curMth,10000);
            mthTag(ti,2) = calNextMth(mthTag(ti,1));
        else                                                                                        % 该月交割日以后
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