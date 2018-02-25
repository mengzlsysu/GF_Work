function RetraceRatio = cal_RetraceRatio(Equity, Date)
%% 计算最大回撤比例
% by asprilla.hu 2017/06/21

%% 初始化
len = numel(Equity);
RetraceRatio = zeros(len, 1);

%% 计算最大回撤比例
for ii = 2:len
    C = max(Equity(1:ii));
    if C == Equity(ii)
        RetraceRatio(ii,1) = 0;
        RetraceRatio(ii,2) = 0;
    else
        RetraceRatio(ii,1) = (Equity(ii)-C)/C;
        RetraceRatio(ii,2) = (Equity(ii)-C);
    end
end

%% 
if nargout == 0
    figure;
    subplot(2,1,1);
    plot(Date,Equity);
    dateaxis('x',2);
    title('资金权益');
    grid on;
    axis tight;   
    
    subplot(2,1,2);
    plot(Date,RetraceRatio(:, 1));
    dateaxis('x',2);    
    title('最大回撤比例');
    grid on;
    axis tight;
end