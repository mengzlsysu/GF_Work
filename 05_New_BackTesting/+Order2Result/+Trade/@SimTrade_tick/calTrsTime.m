function [trsTime] = calTrsTime(~, ordTime, trsParam)
    ordH = fix(mod(ordTime,1000000)/10000);
    ordM = fix(mod(ordTime,10000)/100);
    ordS = mod(ordTime,100) + trsParam.TrsDelay;
    msk = ordS>=60;
    ordS(msk) = ordS(msk)-60;
    ordM(msk) = ordM(msk) + 1;
    msk = ordM>=60;
    ordM(msk) = ordM(msk)-60;
    ordH(msk) = ordH(msk)+1;
    trsTime = ordH*10000+ordM*100+ordS;    
end