function TechIndex_List = TIs( Contract, ModelParams, DataPath )
%   ���ɸú�Լ���е�ָ��ֵ
%   TechIndex: 1. Date 2. Time 3. Close 4. ָ��ֵ
%   TechIndex_List: Ԫ������, ������е�TechIndex

    % �źŸ���
    Signal_Num = length(ModelParams);
    
    for itemp = 1:Signal_Num
        ModelParams_temp = ModelParams(itemp);
        
        FileName = [DataPath,ModelParams_temp.TIName,'\',ModelParams_temp.FileName,'\'];
        if ~isdir(FileName)
            mkdir(FileName);
        end            
        FileName = [FileName, Contract,'.mat'];
        
        % �Ѿ��м���ָ������ �� 1710֮ǰ�������������
        if exist(FileName,'file') & Contract(end-3:end) < 1710
            load(FileName);      
        else
            TechIndex = Signal.Execute.TechIndex(Contract, ModelParams_temp); 
            save(FileName,'TechIndex');
        end
        
        % ���Ϊ��˵�� ��Լ����ȱʧ. ����ָ�����޷�����, ֱ�ӷ��ؿ�����
        if isempty(TechIndex)
            TechIndex_List = [];
            continue;  
        % �����ļ�            
        else    
            TechIndex_List{itemp} = TechIndex;            
        end    
    end

    disp([Contract,' is finished']);

end

