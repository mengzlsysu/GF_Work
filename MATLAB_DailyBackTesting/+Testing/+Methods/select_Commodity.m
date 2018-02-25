function CommodityListFlag = select_Commodity(Date, CommodityList, BackTestCommodityList, AmountMat)
%% ͨ���ɽ���ɸѡ�����Ʒ��    
%   ɸѡ��ȥ��ȥNdays��ƽ���ɽ���δ�ﵽAmountLimit��Ʒ��
    
    % һ��ֱ�ӵ���, �Խ���ʱ��
    if nargin <= 2
        BackTestCommodityList = [];
        load('..\00_DataBase\Edited_Factor\Amount\AmountMat.mat', 'AmountMat')
    elseif nargin <= 3
        load('..\00_DataBase\Edited_Factor\Amount\AmountMat.mat', 'AmountMat')        
    end
    % ��ʼ�趨
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
    
    % �����Ϊ�ռ�, �����BackTestCommodityList�е�Ʒ��
    if ~isempty(BackTestCommodityList)
        CommodityTemp = zeros(size(CommodityListFlag));        
        for iCommodity = 1:length(BackTestCommodityList)
            Commodity = BackTestCommodityList{iCommodity};
            % �ҳ�����Ʒλ��, ������Ϊ1 (�������Ʒ����Ծ����Ϊ0)
            [~,ind] = find(strcmp(CommodityList, Commodity));
            CommodityTemp(ind) = 1;
        end
        CommodityListFlag = CommodityListFlag.*CommodityTemp;
    end
end
