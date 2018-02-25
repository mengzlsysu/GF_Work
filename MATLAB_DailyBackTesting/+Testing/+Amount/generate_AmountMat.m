function AmountMat = generate_AmountMat()
%% �״�����AmountMat

    % ��ȡ��Ʒ�б�
    ContractList = Testing.Methods.get_ContractList();
    CommodityList = sortrows(upper(unique(regexprep(ContractList, '\d+', ''))));
    
    % ��ȡ�����б�
    StartDate = 20090701;
    EndDate = 20170929;
    load('TrdDate.mat')
    DateList = TrdDate(find(TrdDate(:, 1) >= StartDate & TrdDate(:, 1) <= EndDate));
    
    % ��ʼ��AmountMat
    sDL = size(DateList, 1);
    sC = size(CommodityList, 1);
    AmountMat = zeros(sDL, sC+1);
    AmountMat(:, sC+1) = DateList(:, 1);
    
    % ���ñ����ļ���
    FolderName = '..\00_DataBase\Edited_Factor\Amount\';
    if ~isdir(FolderName)
        mkdir(FolderName)
    end
    
    % ѭ����ȡAmountMat����ֵ
    for iDL = 1:size(DateList, 1)
        Date = DateList(iDL, 1);
        for iC = 1:size(CommodityList, 1)
            Commodity = CommodityList{iC, 1};
            AmountMat(iDL, iC) = Testing.Amount.get_Commodity_Amount(Date, Commodity); % ��ȡ��ֵ
        end        
    end    
    
    % �����ļ�
    save([FolderName, 'AmountMat.mat'], 'AmountMat', 'CommodityList')
    
end