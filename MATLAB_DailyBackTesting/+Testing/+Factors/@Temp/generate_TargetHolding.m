function TargetHolding = generate_TargetHolding(obj, Date, AmountMat)
    %% 1.初始化
    % 回看R周期指标值矩阵
    DataMap_R = obj.DataMap_R;    
    % 找出当前交易日
    index = find(DataMap_R(:, end) == Date);
    
    % 多空持仓数量（分别持有Nums手）
    % Nums = 5;
    
    % 仓位
    Position = 1;
    % 是否活跃的商品列表, 0不活跃, 1活跃
    CommodityListFlag = Testing.Methods.select_Commodity(Date, obj.CommodityList, obj.BackTestCommodityList, AmountMat);

    %% 2. 根据指标正负进行操作, 指标为正: long 指标为负: short 

    RawRH_Mat = [CommodityListFlag.*DataMap_R(index, 1:end-1);1:length(CommodityListFlag)];
    RH_Mat = RawRH_Mat(:, CommodityListFlag == 1)';

    Direction_Vector = sign(RH_Mat(:,1));
    Nums = sum(abs(Direction_Vector));
    if Nums ~= 0
        TargetHolding(:, 1) = obj.CommodityList(RH_Mat(:,2));
        TargetHolding(:, 2) = num2cell(Direction_Vector*(Position/Nums)); 
    else
        TargetHolding = []; 
        obj.TargetHolding = TargetHolding; return;
    end

    %% 3.
    for ii = 1:length(TargetHolding(:, 1))
        Mat = obj.MainContractMap(TargetHolding{ii, 1});
        % index = find(Mat{:, 1} == Date);
        if Mat.isKey(Date) == 1
            TargetHolding{ii, 1} = Mat(Date);
        else
            TargetHolding = [];
        end
    end
    
    obj.TargetHolding = TargetHolding;
    
end