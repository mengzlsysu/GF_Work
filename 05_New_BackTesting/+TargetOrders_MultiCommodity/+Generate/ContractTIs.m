function TechIndex_ContractList = ContractTIs(LastTechIndex_ContractList, Date, LastDate, CommodityList, ModelParams, DataPath, MCContainerList )
%   ���ɸ���������Ʒ������Լ�ļ���ָ��
%   TechIndex: 1. Date 2. Time 3. Close 4. ָ��ֵ
%   TechIndex_ContractList: Ԫ������, ��Commodity����TechIndex

    % ����ָ�����/��Ʒ�б����
    TI_Num = length(ModelParams); Commodity_Num = length(CommodityList);

    for iCommodity = 1:Commodity_Num
        % ��ȡ����Ʒ����Ӧ��Լ
        Commodity = CommodityList{iCommodity};
        MCContainer = MCContainerList{iCommodity};
        Contract = MCContainer(Date);
        % ���������Լδ�仯, �ú�Լ����ָ��ֵ���ֲ���
        if ~isempty(LastDate) && strcmp(Contract,MCContainer(LastDate)) && ~isempty(LastTechIndex_ContractList)
            TechIndex_ContractList{iCommodity} = LastTechIndex_ContractList{iCommodity};
            continue
        end
        
        for iTI = 1:TI_Num
           ModelParams_temp = ModelParams(iTI);
           TechIndex = ContractDailyTIs(Date, Commodity, Contract, ModelParams_temp, DataPath);
           % ���Ϊ��˵�� ��Լ����ȱʧ. ����ָ�����޷�����, ֱ�ӷ��ؿ�����
           if isempty(TechIndex)
                TechIndex_ContractList = [];
                return          
           end               
           TechIndex_Commodity{iTI} = TechIndex;
        end
        TechIndex_ContractList{iCommodity} = TechIndex_Commodity;
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
            [TechIndex,MinData] = TargetOrders_MultiCommodity.Cal.TechIndex(Contract, ModelParams); 
            save(FileName,'TechIndex');
            disp([Contract,': ',ModelParams.TIName,' is finished']);            
        end

end