if ~exist('MultiplierMap','var')
    load('MultiplierMap.mat')
end

TrsParam = struct('TrsType', {'min'}...      % ִ�з�ʽ��day,ʹ�������������ݣ�min,ʹ�÷����������ݣ�tick,ʹ��Tick��������
,'TrsTerm', {1}...              % ִ�м۸�1: ���̼ۣ�4: ���̼�
,'TrsCost', {0.0003}...      % ����ɱ�+���׷���
,'Margin', {0.2}...             % ��֤�����
);

TrsParam.Multiplier = MultiplierMap;

