function ATR = cal_ATR( DayData, Params )
%   ���� �ۻ�������ȥ��׼����, ����ο�����֤ȯ20170322
%   �����׼�������õ�����ʷ������, ֱ��ʹ��TR�ı�׼��. 
%   �ۻ�����ATR: TR�ĺ�, ���������̼۵����������̼�, ���Ϊ-1*TR

    if nargin <= 1
        Std_N = 20;  %20��ı�׼����
    else
        Std_N = Params;   
    end
    
    LS_N = 5;   %�볡��
    Flag_N = 10;   %������    
    % ��ʼ��
    ss = size(DayData,1);
    ATR = zeros(ss,1);
    Close = DayData(:,6);
    High = DayData(:,4);
    Low = DayData(:,5);
    
    if ss < max(Std_N,Flag_N)
        ATR = [DayData(:,1:3),ATR];
        return;
    end
    
    % ����TR
    H = High(2:end);
    L = Low(2:end);
    YC = Close(1:end-1);
    TR1 = log(max(H,L)./min(H,L));
    TR2 = log(max(H,YC)./min(H,YC));
    TR3 = log(max(L,YC)./min(L,YC));
    TR = [0;max(TR1,max(TR2,TR3))];
    
    for ii = Std_N:ss
        % ��ʷ������, �ۼƲ���
        HistoryTR = std(TR(ii-Std_N+1:ii)) ; 
        AccumlatedTR = 0;
        
        % �ж��Ƿ񿪲�
        if ATR(ii-1,:) == 0
            for kk = 1:LS_N
                today = ii-(kk-1);
                yesterday = ii-kk;
                if Close(today) > Close(yesterday)
                    AccumlatedTR = AccumlatedTR + TR(today);
                elseif Close(today) < Close(yesterday)
                    AccumlatedTR = AccumlatedTR - TR(today);
                end
                
                if AccumlatedTR > HistoryTR * sqrt(kk)
                    ATR(ii,:) = AccumlatedTR - HistoryTR * sqrt(kk);
                    continue;
                elseif AccumlatedTR < -HistoryTR * sqrt(kk)
                    ATR(ii,:) = AccumlatedTR + HistoryTR * sqrt(kk);
                    continue;
                end
            end            
        % �ж�long�Ƿ���Ҫƽ��    
        elseif ATR(ii-1,:) > 0
            for kk = 1:Flag_N
                today = ii-(kk-1);
                yesterday = ii-kk;
                if Close(today) > Close(yesterday)
                    AccumlatedTR = AccumlatedTR + TR(today);
                elseif Close(today) < Close(yesterday)
                    AccumlatedTR = AccumlatedTR - TR(today);
                end
                
                if AccumlatedTR > HistoryTR * sqrt(kk)
                    ATR(ii,:) = AccumlatedTR - HistoryTR * sqrt(kk);
                    continue;
                elseif AccumlatedTR < HistoryTR * sqrt(kk) && kk == Flag_N
                    ATR(ii,:) = 0;       
                end
            end
        % �ж�short�Ƿ���Ҫƽ��               
        elseif ATR(ii-1,:) < 0
            for kk = 1:Flag_N
                today = ii-(kk-1);
                yesterday = ii-kk;
                if Close(today) > Close(yesterday)
                    AccumlatedTR = AccumlatedTR + TR(today);
                elseif Close(today) < Close(yesterday)
                    AccumlatedTR = AccumlatedTR - TR(today);
                end
                
                if AccumlatedTR < -HistoryTR * sqrt(kk)
                    ATR(ii,:) = AccumlatedTR + HistoryTR * sqrt(kk);
                    continue;
                elseif AccumlatedTR > -HistoryTR * sqrt(kk) && kk == Flag_N
                    ATR(ii,:) = 0;
                end
            end          
        end
        
    end
    ATR = [DayData(:,1:3),ATR];
end

