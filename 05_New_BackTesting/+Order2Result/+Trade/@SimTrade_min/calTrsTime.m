function [trsTime] = calTrsTime(~, ordTime, ~)
    trsTime = mod(ordTime, 1000000);
end