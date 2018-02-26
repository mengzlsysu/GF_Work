function TargetHolding = Sort( RH_Mat, CommodityList, Position, Params )
%   按指标值排序
%   Params (1): -1代表仅做空指标值较小的 1代表仅做多指标值较大的 0代表既做多指标值较大的又做空指标值较小的
%   Params (2): 进行操作的品种/总品种
%   RH_Mat 列1: 指标值 列2: 商品数字
%   TargetHolding 列1: 商品代码 列2: 持仓比例

    if nargin <= 2
        Type = 0;
        Fraction = 0.2; 
    else
        Type = Params(1);
        Fraction = Params(2);
    end
    
    Commodity_Num = size(RH_Mat,1);
    RH_Mat = sort(RH_Mat,1);
    
    % 进行操作的品种数量
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

