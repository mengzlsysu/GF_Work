function DataMap = get_DataMap(obj, CommodityList)
%%  ��ȡָ��ֵ

    % ָ��洢λ��
    SignalPath = obj.SignalPath;
    
    ModelParams = obj.ModelParams;    
    EndDate = ModelParams(1).EndDate;
    % ��ʼ���б�, ��ȡRB.mat�Ի�þ����С
    load([SignalPath,'RB.mat']) 
    DataMap = zeros(size(MultiSignal,1),length(CommodityList)+1);
    DataMap(:,end) =  MultiSignal(:,1);
        
    % ��������Ʒ��CommodityList   
    for iCommodityList = 1:length(CommodityList)
        Commodity = CommodityList{iCommodityList};
        % ���δ���ɸ�Ʒ��ָ��ֵ, ����Ĭ��Ϊ0
        if ~exist([SignalPath,Commodity,'.mat'])
            continue
        end
        load([SignalPath,Commodity,'.mat'])
        % ��ЩƷ��ȱĳЩʱ���ֵ
        DeltaSize = size(DataMap,1)-size(MultiSignal,1);
        if ~DeltaSize 
            DataMap(:,iCommodityList) = MultiSignal(:,end);
        % ȱʡֵ����
        else
            if MultiSignal(end,1) >= EndDate 
                MultiSignal_temp = MultiSignal(:,end);
                DataMap(:,iCommodityList) = [zeros(DeltaSize,1);MultiSignal_temp];
            else
                MultiSignal_temp = MultiSignal(:,end);             
                DataMap(:,iCommodityList) = [MultiSignal_temp;zeros(DeltaSize,1)];
            end
        end
    end

    
end