function CommodityListFlag = select_Commodity(Date, CommodityList, BackTestCommodityList, AmountMat)
%% 通过成交量筛选不达标品种    
%   筛选除去过去Ndays中平均成交量未达到AmountLimit的品种
    
    % 一般直接导入, 以降低时耗
    if nargin <= 2
        BackTestCommodityList = [];
        load('..\00_DataBase\Edited_Factor\Amount\AmountMat.mat', 'AmountMat')
    elseif nargin <= 3
        load('..\00_DataBase\Edited_Factor\Amount\AmountMat.mat', 'AmountMat')        
    end
    % 初始设定
    AmountLimit = 30000;
    NDays = 10;
    index = find(AmountMat(:, end) == Date);
    if index <= NDays
        index1 = 1;
    else
        index1 = index - NDays;
    end
    
    % 
    for ii = 1:length(CommodityList)
        Condition = mean(AmountMat(index1:index, ii)) > AmountLimit;
        CommodityListFlag(1,ii) = double(Condition);
    end
    
    % 如果不为空集, 则仅做BackTestCommodityList中的品种
    if ~isempty(BackTestCommodityList)
        CommodityTemp = zeros(size(CommodityListFlag));        
        for iCommodity = 1:length(BackTestCommodityList)
            Commodity = BackTestCommodityList{iCommodity};
            % 找出该商品位置, 仅令其为1 (如果该商品不活跃依旧为0)
            [~,ind] = find(strcmp(CommodityList, Commodity));
            CommodityTemp(ind) = 1;
        end
        CommodityListFlag = CommodityListFlag.*CommodityTemp;
    end
end
