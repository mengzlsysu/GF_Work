function RetraceRatio = cal_RetraceRatio(Equity)
%% �������س�����
% by asprilla.hu 2017/06/21


%% ��ʼ��
len = numel(Equity);
RetraceRatio = zeros(len, 1);

%% �������س�����
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
    plot(Equity);
    title('�ʽ�Ȩ��');
    grid on;
    axis tight;   
    subplot(2,1,2);
    plot(RetraceRatio(:, 1));
    title('���س�����');
    grid on;
    axis tight;
end