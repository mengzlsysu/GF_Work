function DailyStats = BackTesting(CommodityList, ModelParams)
%%  回测平台
% 1. CommodityList: 字符串格式为单品种回测, 元胞数组为多品种回测

%%  1. 生成订单

    % 单个商品回测
    if ischar(CommodityList)
       Orders = TargetOrders.GenerateOrders(CommodityList, ModelParams); 
    % 多个商品回测   
    elseif iscell(CommodityList)
       Orders = TargetOrders_MultiCommodity.GenerateOrders(CommodityList, ModelParams);         
    else
       error('请输入正确的商品代码 !');
    end

%%  2. 模拟回测
    DailyStats = Order2Result.GenerateResults(ModelParams, Orders, CommodityList);

end