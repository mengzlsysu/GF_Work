%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: wei.he
% Date: 2016/9/29
% Discription:  ģ������ں�����
% 1�����������
%       EndDate(�ַ���'yyyymmdd'): ��������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dailyStats = GenerateResults(ModelParams, CommodityList, Orders)
    
    global DataPath;
    DataPath = '..\00_DataBase\MarketData\';
    
    %% ��ʼ����ȷ����������
    if nargin == 0 
        [Y, M, D, H] = datevec(now);
        if H > 20 %���Ŀǰ�Ѿ�������10���Ժ󣬽�������Ϊ���գ�����Ϊ���ա�
            EndDate = datenum(Y, M, D);
        else
            EndDate = datenum(Y, M, D)-1;
        end
        EndDate = datestr(EndDate, 'yyyymmdd');
    elseif nargin == 2
        Orders = [];    
    elseif nargin >= 4
        error('����̫�࣡');
    end
    
    StartDate = num2str(ModelParams(1).StartDate);
    EndDate = num2str(ModelParams(1).EndDate);
    
    %% ģ��ɽ�����
    minTrsParam = struct('TrsType', {'min'}...      % ִ�з�ʽ��min,ʹ�÷����������ݣ�tick,ʹ��Tick��������
                                   ,'TrsMinS', {1}...              % ִ����ʼ������
                                   ,'TrsMinE', {1}...              % ִ�н���������
                                   ,'TrsTerm', {1}...              % ִ�м۸�1: Twap,���������̼�ƽ��ֵ��2: Vwap,�����ڽ��׽��/������
                                   ,'TrsCost', {0.0002}...     % ����ɱ�+���׷���
                                   );
    tickTrsParam = struct('TrsType', {'tick'}...      % ִ�з�ʽ��min,ʹ�÷����������ݣ�tick,ʹ��Tick��������
                                    ,'TrsDelay', {10}...          % �ӳ�ִ������
                                    ,'TrsTerm', {1}...             % ִ�м۸�, 1: ���ּۣ� 2: ���¼�
                                    ,'TrsCost', {0.00005}...  % ���׷���&�ɱ�
                                    );
    
    %% ģ��ģ�⣬�˴���Ӹ���ģ��
    modelPath = ['Evaluation\',ModelParams(1).ModelName,'\',ModelParams(1).TrsType,'\'];
%     models = {'411A','411C', '413A', '413C', '421B_120'};
    models = [];
    for itemp = 1:length(ModelParams)
       models = [models,ModelParams(itemp).FileName]; 
    end
    
    if ischar(CommodityList)
       models = [models,'\',CommodityList];    
    elseif iscell(CommodityList)
       models = [models,'\']; 
       for itemp = 1:length(CommodityList)
           Commodity = CommodityList{itemp}; 
           models = [models,Commodity,'_']; 
       end 
    end
 
   [dailyStats] = Order2Result.Trade.simTrade_Commodity(Orders, StartDate, EndDate, modelPath, models, 1e7, minTrsParam, ModelParams);
   [kpi, nav] = Order2Result.Stats.reapStats_Commodity(modelPath, models, dailyStats);
   Order2Result.Stats.display_Commodity(kpi, nav);% ģ����չʾ
  
end