function CommodityListFlag = select_Commodity(Date, CommodityList, AmountMat)
%% 通过成交量筛选不达标品种    

    % 初始设定
    AmountLimit = 30000;
    NDays = 10;
    load('..\00_DataBase\Edited_Factor\Amount\AmountMat.mat', 'AmountMat')
    index = find(AmountMat(:, end) == Date);
    if index <= 10
        index1 = 1;
    else
        index1 = index - 10;
    end
    
    %
    for ii = 1:length(CommodityList)
        Condition = mean(AmountMat(index1:index, ii)) > AmountLimit;
        CommodityListFlag(1,ii) = double(Condition);
    end
    
end
