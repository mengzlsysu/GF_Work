function RH_Mat = generate_RH_Mat(obj, Date)
    %% 1.初始化
    % 回看R周期收益率矩阵
    DataMap_R = obj.DataMap_R;    
    % 找出当前交易日
    index = find(DataMap_R(:, end) == Date);
    
    %% 2
    CommodityListFlag = Testing.Methods.select_Commodity(Date, obj.CommodityList);
    
    RawRH_Mat = [CommodityListFlag.*DataMap_R(index, 1:end-1);1:length(CommodityListFlag)];
    RH_Mat = RawRH_Mat(:, CommodityListFlag == 1)';
    RH_Mat = sortrows(RH_Mat, 1);