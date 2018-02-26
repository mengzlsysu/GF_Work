function MultiSignal = Signal( TechIndex_List, MCDuration, ModelParams )
%   ��������ָ��ֵ, �����ۺ�MultiSignal, �ٸ���MCDuration�и��������Լʱ����ڵ�ָ��ֵ
%   MultiSignal: 1. Date 2. Time 3. Close 4. ����ָ��ֵ

%%  1. ��������ָ��

    % ָ����
    Signal_Num = length(TechIndex_List);   
    % ��һָ�겻����
    if Signal_Num == 1
        MultiSignal = TechIndex_List{1};
    else
        % �༼��ָ�������źŵļ��㷽��
        TI2Signal = ModelParams(1).TI2Signal;

        % ���ɾ��
        fhandle = str2func(['Signal.Signal.cal_', TI2Signal]);    
        MultiSignal = fhandle(TechIndex_List);
    end

%%  2. �и��������Լʱ����ڵ�ָ��ֵ

    % ��ʼ����
    StartDate = ModelParams(1).StartDate; EndDate = ModelParams(1).EndDate;
    MCDuration(1) = max(MCDuration(1),StartDate);
    MCDuration(2) = min(MCDuration(2),EndDate);
    
    % Ѱ���±�
    index1 = find(MultiSignal(:, 1) >= MCDuration(1), 1, 'first');
    index2 = find(MultiSignal(:, 1) <= MCDuration(2), 1, 'last');
    % ��ȡ����
    MultiSignal =  MultiSignal(index1:index2,:);     
    
end

