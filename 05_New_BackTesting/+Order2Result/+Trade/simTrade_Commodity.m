%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: wei.he
% Date: 2016/9/27
% Discription:  ����ģ�ͽ����ź��ļ�������ģ��ÿ�ճֲ�&ӯ�������
% 1�����������
%       StartDate/EndDate(�ַ���'yyyymmdd'): ��ʼ���ںͽ�������
%       ModelPath: ģ���ļ���·����������ģ���ļ����� 
%       Model: ģ�����ƣ����ļ�������
%       InitialBalance: ��ʼ��ģ
%       TrsParam: ģ��ɽ�����
% 2����������ļ��ṹ��
%       ģ�ͽ����ź�Order�ļ�:    1.�ź�ʱ�䣬 2.��Լ���룬3.��/����4.��/ƽ��5.���� 
%       ģ�����ճֲ�Balance�ļ�: �����: 1.''�� 2.���ս�����ֵ��3.���ճֲ���ֵ��4.����Ȩ��
%                                                    ������: 1.��Լ���룬 2.�ֲ�����(+/-)�� 3.���ս���ۣ� 4.���ս�����ֵ
% 3�������߼�
%       ���BalanceĿ¼�´�����ʷģ����ʱ����ȡBalanceĿ¼�µ��������Ϊ��ʵ��ʼ���ڣ�������ָ����ʼ����Ϊ��ʵ��ʼ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [DailyStats] = simTrade_Commodity(Orders, StartDate, EndDate, ModelPath, ModelName, InitBalance, TrsParam, ModelParams)
    global DataPath;
    load('TrdDate.mat');   % ��ȡ����: TrdDate
    
    %% ��ʼ������ʼ����
    
    %��ȡ����: Orders
    if isempty(Orders)
        load([ModelPath, ModelName,'\Orders.mat']);   
    end
    
    if size(Orders,1)<1 
        disp([ModelName, ' �����ź��ļ�Ϊ��.']);
        disp([ModelName, ' ģ�����.']);
        return;
    end
    ordSDate = fix(Orders{1,1}/1000000);
    if str2double(StartDate) > ordSDate
        disp([ModelName, ' ģ����ʼ����[ ', StartDate, ' ]������Ϊ�����ź�����[ ', num2str(ordSDate), ' ].']);
        StartDate = num2str(ordSDate);
    end
    
    %% ��ʼ������������
    ti_end = find(TrdDate(:,1) <= str2double(EndDate), 1, 'last');
    if isempty(ti_end)
        disp([ModelName, ' ģ���������:', EndDate, ', ���罻������:', num2str(TrdDate(1,1)), '.']);
        disp([ModelName, ' ģ�����.']);
        return;
    end

    %% ��ʼ����BalanceĿ¼��TradeĿ¼
    blcPath = [ModelPath,ModelName,'\Balance\'];
    if ~isdir(blcPath)  
        mkdir(blcPath);
    end
    trdPath = [ModelPath,ModelName, '\Trade\'];
    if ~isdir(trdPath)
        mkdir(trdPath)
    end
    
    %% ��ʼ����Balance, DailyStats, ��ʼ����
    blcFile = dir([blcPath, '*.mat']);
    if isempty(blcFile)
        disp([ModelName, ' ��ʷģ����Ϊ��.']);
        ti_begin = find(TrdDate(:,1)>=str2double(StartDate), 1, 'first');
        if isempty(ti_begin)
            disp([ModelName, ' ģ����ʼ����:', StartDate, ', �����������:', num2str(TrdDate(end,1)), '.']);
            disp([ModelName, ' ģ�����.']);
            DailyStats=[]; 
            return;
        end
        Balance = {'', 0, 0, InitBalance, ''};
        save([blcPath, datestr(TrdDate(ti_begin-1, 2), 'yyyymmdd'), '.mat'], 'Balance');    % Ĭ��ti_begin> 1
        DailyStats = [TrdDate(ti_begin-1,1), 0, 0, InitBalance];
    else
        disp([ModelName, ' ��ʷģ������Ϊ��.']);
        load([blcPath,blcFile(end).name]);  % ��ȡ����: Balance
        stsFile = [ModelPath, ModelName, '\DailyStats.mat'];
        if ~exist(stsFile, 'file')
            disp([ModelName, ' DailyStats�ļ�ȱʧ, ����������.']);
            DailyStats = genDailyStats(blcPath, blcFile);
        else
            load(stsFile);  % ��ȡ����: DailyStats
            if DailyStats(end,1)~=str2double(blcFile(end).name(1:end-4))
                disp([ModelName, ' DailyStats�ļ�������Balance�ļ����ڲ�һ�£�����������.']);
                DailyStats= genDailyStats(blcPath, blcFile);
            end
        end
        StartDate = int2str(DailyStats(end,1));
        ti_begin = find(TrdDate(:,1)>str2double(StartDate), 1, 'first');
        if isempty(ti_begin)
            disp([ModelName, ' ��ʷģ���������:', StartDate, ', �����������:', num2str(TrdDate(end,1)), '.']);
            disp([ModelName, ' ģ�����.']);
            return;
        end
    end
    
    %% ģ��������
    SimTradeConstructor = str2func(['Order2Result.Trade.SimTrade_', TrsParam.TrsType]);
    simTrade = SimTradeConstructor();
    DailyStats = simTrade.execute(Orders, TrdDate, ti_begin, ti_end, ModelPath, ModelName, TrsParam, Balance, DailyStats, ModelParams)
        
    disp([ModelName, ' ģ��ɹ�����.']);
end

%% genDailyStats: ��Balance�ļ�����������DailyStats
    function [dailyStats] = genDailyStats(blcPath, blcFile)
        fNum = length(blcFile);
        load([blcPath, blcFile(1).name]); %��ȡ����Balance
        dailyStats = nan(fNum, size(Balance,2)-1);
        for fi=1 : fNum
            load([blcPath, blcFile(fi).name]); %��ȡ����Balance
            dailyStats(fi,1) = str2double(blcFile(fi).name(1:end-4)); % ����
            dailyStats(fi, 2:end) = cell2mat(Balance(end,2:end-1));
        end
    end
        