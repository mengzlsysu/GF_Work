function TargetHolding = Sort( RH_Mat, CommodityList, Position, Params )
%   ��ָ��ֵ����
%   Params (1): -1���������ָ��ֵ��С�� 1���������ָ��ֵ�ϴ�� 0���������ָ��ֵ�ϴ��������ָ��ֵ��С��
%   Params (2): ���в�����Ʒ��/��Ʒ��
%   RH_Mat ��1: ָ��ֵ ��2: ��Ʒ����
%   TargetHolding ��1: ��Ʒ���� ��2: �ֱֲ���

    if nargin <= 2
        Type = 0;
        Fraction = 0.2; 
    else
        Type = Params(1);
        Fraction = Params(2);
    end
    
    Commodity_Num = size(RH_Mat,1);
    RH_Mat = sort(RH_Mat,1);
    
    % ���в�����Ʒ������
    Nums = round(Commodity_Num*Fraction);
    if Nums == 0
        TargetHolding = []; return;
    end
    
    if Type == 1
        Direction_Vector = ones(Nums,1);
        TargetHolding(:, 1) = CommodityList(RH_Mat(end-Nums+1:end,2));
        TargetHolding(:, 2) = num2cell(Direction_Vector*Position/Nums);
    elseif Type == -1
        Direction_Vector = -ones(Nums,1);
        TargetHolding(:, 1) = CommodityList(RH_Mat(1:Nums,2));
        TargetHolding(:, 2) = num2cell(Direction_Vector*Position/Nums);        
    elseif Type == 0
        Nums = round(Commodity_Num*Fraction/2);
        if Nums == 0
            TargetHolding = []; return;
        end        
        Direction_Vector = [-ones(Nums,1);ones(Nums,1)];
        TargetHolding(:, 1) = CommodityList(RH_Mat([1:Nums,end-Nums+1:end],2));
        TargetHolding(:, 2) = num2cell(Direction_Vector*Position/Nums);            
    end

end

