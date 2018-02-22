function DailyStats = BackTesting(CommodityList, ModelParams)
%%  �ز�ƽ̨
% 1. CommodityList: �ַ�����ʽΪ��Ʒ�ֻز�, Ԫ������Ϊ��Ʒ�ֻز�

%%  1. ���ɶ���

    % ������Ʒ�ز�
    if ischar(CommodityList)
       Orders = TargetOrders.GenerateOrders(CommodityList, ModelParams); 
    % �����Ʒ�ز�   
    elseif iscell(CommodityList)
       Orders = TargetOrders_MultiCommodity.GenerateOrders(CommodityList, ModelParams);         
    else
       error('��������ȷ����Ʒ���� !');
    end

%%  2. ģ��ز�
    DailyStats = Order2Result.GenerateResults(ModelParams, Orders);

end