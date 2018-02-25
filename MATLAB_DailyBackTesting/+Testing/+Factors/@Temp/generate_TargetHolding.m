function TargetHolding = generate_TargetHolding(obj, Date, AmountMat)
    %% 1.��ʼ��
    % �ؿ�R����ָ��ֵ����
    DataMap_R = obj.DataMap_R;    
    % �ҳ���ǰ������
    index = find(DataMap_R(:, end) == Date);
    
    % ��ճֲ��������ֱ����Nums�֣�
    % Nums = 5;
    
    % ��λ
    Position = 1;
    % �Ƿ��Ծ����Ʒ�б�, 0����Ծ, 1��Ծ
    CommodityListFlag = Testing.Methods.select_Commodity(Date, obj.CommodityList, obj.BackTestCommodityList, AmountMat);

    %% 2. ����ָ���������в���, ָ��Ϊ��: long ָ��Ϊ��: short 

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