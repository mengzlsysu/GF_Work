function save_TargetHolding(obj)

    % 获取日期
    StartDate = 20100101;
    EndDate = 20170929;    
    load('TrdDate.mat')
    DateList = TrdDate(find(TrdDate(:, 1) >= StartDate & TrdDate(:, 1) <= EndDate), :);  
    
    ModelName = obj.ModelNames{1};
    ind = regexp(ModelName,'_');
    H = ModelName(ind(2)+1:end);
    saveFolderName = [obj.DataPath, 'CompoundSignals_', H, '\TargetHolding\'];
    if ~isdir(saveFolderName)
        mkdir(saveFolderName);
    end
    
    for ii = 1:length(DateList)
        
        % 获取日期
        Date = DateList(ii, 1);
        % 生成TargetHolding
        TargetHolding = obj.generate_TargetHolding(Date);
        if ~isempty(TargetHolding)
            save([saveFolderName, num2str(Date), '.mat'], 'TargetHolding')
        end   
    end
    
end