function TechIndex_List = DailyTIs( Date, CommodityList, ModelParams, DataPath, MCContainerList )
%   生成该日所有商品的技术指标
%   TechIndex: 1. Date 2. Time 3. Close 4. 指标值
%   TechIndex_List: 元胞数组, 按Commodity排列TechIndex

    % 技术指标个数/商品列表个数
    TI_Num = length(ModelParams); Commodity_Num = length(CommodityList);

    for iCommodity = 1:Commodity_Num
        % 提取该商品及对应合约
        Commodity = CommodityList{iCommodity};
        MCContainer = MCContainerList{iCommodity};
        Contract = MCContainer(Date);
        
        for iTI = 1:TI_Num
           ModelParams_temp = ModelParams(iTI);
           TechIndex = ContractDailyTIs(Date, Commodity, Contract, ModelParams_temp, DataPath);
           % 如果为空说明 合约数据缺失. 其它指标亦无法计算, 直接返回空数组
           if isempty(TechIndex)
                TechIndex_List = [];
                return          
           end               
           TechIndex_Commodity{iTI} = TechIndex;
        end
        TechIndex_List{iCommodity} = TechIndex_Commodity;
    end

end

function TechIndex = ContractDailyTIs(Date, Commodity, Contract, ModelParams, DataPath)
% 生成该日该合约所对应的技术指标

        FileName = [DataPath,Commodity,'\',ModelParams.TIName,'\',ModelParams.FileName,'\'];
        if ~isdir(FileName)
            mkdir(FileName);
        end            
        FileName = [FileName, Contract,'.mat'];
        
        % 已经有技术指标数据 且 1710之前的数据无需更新
        if exist(FileName,'file') & Contract(end-3:end) < 1710
            load(FileName);      
        else
            [TechIndex,MinData] = TargetOrders.Cal.TechIndex(Contract, ModelParams); 
            save(FileName,'TechIndex');
            disp([Contract,': ',ModelParams.TIName,' is finished']);            
        end
        % 提取该日的技术指标
        TechIndex = TechIndex((TechIndex(:,1)==Date),:);

end