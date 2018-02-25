function DeltaLLT = cal_DeltaLLT(DayData, Params)
% ������ӳ�������LLT, ������� �㷢֤ȯ20130726
    
    if nargin <=2
        N = 30;
    else
        N = Params;
    end
    d = 1;
    
    Price = DayData(:, 6);
    len = length(Price);

    Value = cal_LLT(Price,N);
    
    if len > d+1
    DeltaLLT = [zeros(d,1);Value(d+1:end)-Value(1:len-d)];
    % ��������, �������ж��Ƿ����ʱ, ���ߵȼ�
    % DeltaLLT(:,2) = [zeros(d+1,1);log(Value(d+2:end)./Value(2:len-d))]; %��ĸ��Ϊ0, ��ǰ2��ȡ0
    else
    DeltaLLT = zeros(len,1);
    % ��������
    % DeltaLLT(:,2) = zeros(len,1);
    end
    
    DeltaLLT = [DayData(:,1:3),DeltaLLT];
    
end

function LLT = cal_LLT(Price,N)
           
    len = length(Price);
    if len < 3
        LLT = Price;
        return
    end
    alpha = 2/(N+1);

    LLT(1) = Price(1);
    LLT(2) = Price(2);
    
    for ii = 3:len
        LLT(ii) = (alpha - alpha^2/4)*Price(ii) + alpha^2/2*Price(ii-1) - (alpha - 3*alpha^2/4)*Price(ii-2) + 2*(1-alpha)*LLT(ii-1) - (1-alpha)^2*LLT(ii-2);        
    end
    LLT = LLT';
end