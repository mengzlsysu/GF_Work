function TechIndex_List = DailyTIs( Date, CommodityList, ModelParams, DataPath, MCContainerList )
%   ���ɸ���������Ʒ�ļ���ָ��
%   TechIndex: 1. Date 2. Time 3. Close 4. ָ��ֵ
%   TechIndex_List: Ԫ������, ��Commodity����TechIndex

    % ����ָ�����/��Ʒ�б����
    TI_Num = length(ModelParams); Commodity_Num = length(CommodityList);

    for iCommodity = 1:Commodity_Num
        % ��ȡ����Ʒ����Ӧ��Լ
        Commodity = CommodityList{iCommodity};
        MCContainer = MCContainerList{iCommodity};
        Contract = MCContainer(Date);
        
        for iTI = 1:TI_Num
           ModelParams_temp = ModelParams(iTI);
           TechIndex = ContractDailyTIs(Date, Commodity, Contract, ModelParams_temp, DataPath);
           % ���Ϊ��˵�� ��Լ����ȱʧ. ����ָ�����޷�����, ֱ�ӷ��ؿ�����
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
% ���ɸ��ոú�Լ����Ӧ�ļ���ָ��

        FileName = [DataPath,Commodity,'\',ModelParams.TIName,'\',ModelParams.FileName,'\'];
        if ~isdir(FileName)
            mkdir(FileName);
        end            
        FileName = [FileName, Contract,'.mat'];
        
        % �Ѿ��м���ָ������ �� 1710֮ǰ�������������
        if exist(FileName,'file') & Contract(end-3:end) < 1710
            load(FileName);      
        else
            [TechIndex,MinData] = TargetOrders.Cal.TechIndex(Contract, ModelParams); 
            save(FileName,'TechIndex');
            disp([Contract,': ',ModelParams.TIName,' is finished']);            
        end
        % ��ȡ���յļ���ָ��
        TechIndex = TechIndex((TechIndex(:,1)==Date),:);

end