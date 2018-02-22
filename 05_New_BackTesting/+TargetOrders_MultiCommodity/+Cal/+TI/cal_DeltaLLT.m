function TI = cal_DeltaLLT(MinData, Params)    

    N = Params(1);
    d = 1;


    Price = MinData(1:end, 6);

    Value = cal_LLT(Price,N);
    
    TI(:, 1:2) = MinData(:, 1:2);
    TI(:, 3) = MinData(:, 6);
    TI(:, 4) = [0;diff(Value)];
    
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