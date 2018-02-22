function TI = cal_ATR( MinData, Params )
%   ���� �ۻ�������ȥ��׼����, ����ο�����֤ȯ20170322
%   �����׼�������õ�����ʷ������, ֱ��ʹ��TR�ı�׼��. 
%   �ۻ�����ATR: TR�ĺ�, ���������̼۵����������̼�, ���Ϊ-1*TR

    if nargin <= 1
        Std_N = 20;  %20��ı�׼����
    else
        Std_N = Params(1);   
    end

    LS_N = 5;   %�볡��
    Flag_N = 10;   %������
    % ��ʼ��
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
        % �ж�long�Ƿ���Ҫƽ��    
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
        % �ж�short�Ƿ���Ҫƽ��               
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

