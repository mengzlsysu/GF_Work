function TechIndex_List = TIs( Contract, ModelParams, DataPath )
%   生成合约所有的指标值
%   TechIndex: 1. Date 2. Time 3. Close 4. 指标值
%   TechIndex_List: 元胞数组, 存放所有的TechIndex

    % 信号个数
    Signal_Num = length(ModelParams);
    
    for itemp = 1:Signal_Num
        ModelParams_temp = ModelParams(itemp);
        
        FileName = [DataPath,ModelParams_temp.TIName,'\',ModelParams_temp.FileName,'\'];
        if ~isdir(FileName)
            mkdir(FileName);
        end            
        FileName = [FileName, Contract,'.mat'];
        
        % 已经有技术指标数据 且 1710之前的数据无需更新
        if exist(FileName,'file') & Contract(end-3:end) < 1710
            load(FileName);      
        else
            [TechIndex,MinData] = TargetOrders.Cal.TechIndex(Contract, ModelParams_temp); 
            save(FileName,'TechIndex');
        end
        
        % 如果为空说明 合约数据缺失. 其它指标亦无法计算, 直接返回空数组
        if isempty(TechIndex)
            TechIndex_List = [];
            continue;  
        % 保存文件            
        else    
            TechIndex_List{itemp} = TechIndex;            
        end    
    end

    disp([Contract,' is finished']);

end

