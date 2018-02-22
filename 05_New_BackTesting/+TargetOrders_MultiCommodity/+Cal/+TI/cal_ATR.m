function TI = cal_ATR( MinData, Params )
%   返回 累积波幅减去标准波幅, 具体参考银河证券20170322
%   计算标准波幅所用到的历史波动率, 直接使用TR的标准差. 
%   累积波幅ATR: TR的和, 若当日收盘价低于昨日收盘价, 则记为-1*TR

    if nargin <= 1
        Std_N = 20;  %20天的标准波幅
    else
        Std_N = Params(1);   
    end

    LS_N = 5;   %入场点
    Flag_N = 10;   %出场点
    % 初始化
    ss = size(MinData,1);
    TI(:, 1:2) = MinData(:, 1:2);
    TI(:, 3) = MinData(:, 6);    
    TI(:,4) = zeros(ss,1);
    Close = MinData(:,6);
    High = MinData(:,4);
    Low = MinData(:,5);
    
    if ss < max(Std_N,Flag_N)
        return;
    end
    
    % 计算TR
    H = High(2:end);
    L = Low(2:end);
    YC = Close(1:end-1);
    TR1 = log(max(H,L)./min(H,L));
    TR2 = log(max(H,YC)./min(H,YC));
    TR3 = log(max(L,YC)./min(L,YC));
    TR = [0;max(TR1,max(TR2,TR3))];
    
    for ii = Std_N:ss
        % 历史波动率, 累计波幅
        HistoryTR = std(TR(ii-Std_N+1:ii)) ; 
        AccumlatedTR = 0;
        
        % 判断是否开仓
        if TI(ii-1,4) == 0
            for kk = 1:LS_N
                today = ii-(kk-1);
                yesterday = ii-kk;
                if Close(today) > Close(yesterday)
                    AccumlatedTR = AccumlatedTR + TR(today);
                elseif Close(today) < Close(yesterday)
                    AccumlatedTR = AccumlatedTR - TR(today);
                end
                
                if AccumlatedTR > HistoryTR * sqrt(kk)
                    TI(ii,4) = AccumlatedTR - HistoryTR * sqrt(kk);
                    continue;
                elseif AccumlatedTR < -HistoryTR * sqrt(kk)
                    TI(ii,4) = AccumlatedTR + HistoryTR * sqrt(kk);
                    continue;
                end
            end            
        % 判断long是否需要平仓    
        elseif TI(ii-1,4) > 0
            for kk = 1:Flag_N
                today = ii-(kk-1);
                yesterday = ii-kk;
                if Close(today) > Close(yesterday)
                    AccumlatedTR = AccumlatedTR + TR(today);
                elseif Close(today) < Close(yesterday)
                    AccumlatedTR = AccumlatedTR - TR(today);
                end
                
                if AccumlatedTR > HistoryTR * sqrt(kk)
                    TI(ii,4) = AccumlatedTR - HistoryTR * sqrt(kk);
                    continue;
                elseif AccumlatedTR < HistoryTR * sqrt(kk) && kk == Flag_N
                    TI(ii,4) = 0;       
                end
            end
        % 判断short是否需要平仓               
        elseif TI(ii-1,4) < 0
            for kk = 1:Flag_N
                today = ii-(kk-1);
                yesterday = ii-kk;
                if Close(today) > Close(yesterday)
                    AccumlatedTR = AccumlatedTR + TR(today);
                elseif Close(today) < Close(yesterday)
                    AccumlatedTR = AccumlatedTR - TR(today);
                end
                
                if AccumlatedTR < -HistoryTR * sqrt(kk)
                    TI(ii,4) = AccumlatedTR + HistoryTR * sqrt(kk);
                    continue;
                elseif AccumlatedTR > -HistoryTR * sqrt(kk) && kk == Flag_N
                    TI(ii,4) = 0;
                end
            end          
        end
        
    end

end

