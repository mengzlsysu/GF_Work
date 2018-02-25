function DN = cal_stdDN(Price, N)
    
    if nargin <= 1
        N = 20;
    end
    
    x = diff(log(Price));
       
    DN = std(x)*sqrt(N);
    
end