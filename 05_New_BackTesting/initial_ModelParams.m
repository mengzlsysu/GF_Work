%% ��ʼ�� ModelParams

ModelParams = struct( 'TrsType', {'1min'}...      % ִ�з�ʽ��day,ʹ�������������ݣ�min,ʹ�÷����������ݣ�tick,ʹ��Tick��������
                                    ,'TIName',{'DeltaLLT','ATR'}...         % ����ָ������
                                    ,'TIParams', {200,20}...              % ����ָ�����
                                    ,'FileName', {'DeltaLLT_200_','ATR_20_'}...      % ���漼��ָ����ļ���
                                    ,'TI2Signal',{'SumSign'}...             % �༼��ָ�������źŵļ��㷽��
                                    ,'Signal2Commodity',{'MaxMin'}...       % �����ź�ѡ����Ʒ�ķ��� 
                                    ,'Margin', {0.2}...             % ��֤�����
                                    ,'MCTrade',{0}...                 % �Ƿ�������Լ�л�, 1������, 0����������Լ���ڼ����ֲ����źŽ���, ����5��ƽ��
                                    ,'ModelName', {'JustForTest'}...     % ������ Evaluation �е��ļ�������
                                    ,'StartDate', {20100105}, 'EndDate', {20170731}...             % �ز�����
                                    ,'StopLoss',{0}, 'StopProfit',{1}...                  % �Ƿ�ֹ��/ֹӯ ֹ��/ֹӯ:1 ��ֹ��/��ֹӯ:0 
                                    ,'StopLossRange',{0.01}, 'StopProfitRange',{0.01}...                  % ֹ��/ֹӯ����, ex:�µ�1%ֹ��, ����1%ֹӯ                                     
);

