%% ��ʼ�� ModelParams

ModelParams = struct( 'TrsType', {'day'}...      % ִ�з�ʽ��day,ʹ�������������ݣ�min,ʹ�÷����������ݣ�tick,ʹ��Tick��������
                                    ,'TIName',{'DeltaLLT','ATR'}...         % ����ָ������
                                    ,'TIParams', {200,20}...              % ����ָ�����
                                    ,'FileName', {'DeltaLLT_200_','ATR_20_'}...      % ���漼��ָ����ļ���
                                    ,'TI2Signal',{'SumSign'}...             % �༼��ָ�������źŵļ��㷽��
                                    ,'Signal2Commodity',{'MaxMin'}...       % �����ź�ѡ����Ʒ�ķ��� 
                                    ,'CommodityParams',{0.1}...             % �ź�ѡ����Ʒ�����Ĳ���
                                    ,'Margin', {0.2}...             % ��֤�����
                                    ,'ModelName', {'JustForTest'}...     % ������ Evaluation �е��ļ�������
                                    ,'StartDate', {20100105}, 'EndDate', {20170731}...             % �ز�����
                                    ,'H',{5}...             % �ֲ�����
                                    ,'LS', {0}...           %   LS�������, ex: 1����ָ��ֵ˳�����к�, ���ڵ�1���ڵ��ڻ����лز�
);

%   LS������δʵ��