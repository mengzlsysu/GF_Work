function AmountMat = generate_AmountMat()
%% 首次生成AmountMat

    % 获取商品列表
    ContractList = Testing.Methods.get_ContractList();
    CommodityList = sortrows(upper(unique(regexprep(ContractList, '\d+', ''))));
    
    % 获取日期列表
    StartDate = 20090701;
    EndDate = 20170929;
    load('TrdDate.mat')
    DateList = TrdDate(find(TrdDate(:, 1) >= StartDate & TrdDate(:, 1) <= EndDate));
    
    % 初始化AmountMat
    sDL = size(DateList, 1);
    sC = size(CommodityList, 1);
    AmountMat = zeros(sDL, sC+1);
    AmountMat(:, sC+1) = DateList(:, 1);
    
    % 设置保存文件夹
    FolderName = '..\00_DataBase\Edited_Factor\Amount\';
    if ~isdir(FolderName)
        mkdir(FolderName)
    end
    
    % 循环获取AmountMat的数值
    for iDL = 1:size(DateList, 1)
        Date = DateList(iDL, 1);
        for iC = 1:size(CommodityList, 1)
            Commodity = CommodityList{iC, 1};
            AmountMat(iDL, iC) = Testing.Amount.get_Commodity_Amount(Date, Commodity); % 获取数值
        end        
    end    
    
    % 保存文件
    save([FolderName, 'AmountMat.mat'], 'AmountMat', 'CommodityList')
    
end