function Yield = generate_Yield(Commodity)
%% 首次生成Yield矩阵（单列）
    
    %% 1.初始化
    load(['..\00_DataBase\MarketData\MainContract\',Commodity,'.mat'])
    
    StartDate = 20090101;
    DateList = cell2mat(MainContract(:,1));
    StartDateIndex = find(DateList > StartDate,1,'first');

    Yield = zeros(length(DateList)-StartDateIndex+1,2);
    jj = 1;

    %% 2.循环
    for ii = StartDateIndex:length(DateList)
        Contract = MainContract{ii,2};        
        Commodity1 = Contract(1:end-4);

        % load DayData
        if ~exist('DayData','var')
            load(['..\00_DataBase\MarketData\DayData\',Commodity1,'\byContract\',Contract,'.mat']) % first time
            index = find(DayData(:,1) == DateList(ii));
        elseif ~strcmp(MainContract{ii,2},MainContract{ii-1,2})
            load(['..\00_DataBase\MarketData\DayData\',Commodity1,'\byContract\',Contract,'.mat']) % MainContract has been changed   
            if ~isempty(DayData)
                index = find(DayData(:,1) == DateList(ii));
            else
                Yield(jj,2) = 0;
                Yield(jj,1) = DateList(ii);
                continue
            end
        end

        if index > 1
            try
                Yield(jj,2) = log(DayData(index,6)) - log(DayData(index-1,6));
            catch
                Yield(jj:end,:) = [];
            end
        elseif ~isempty(index)
            Yield(jj,2) = log(DayData(index,6)) - log(DayData(index,3));
        else
            Yield(jj,2) = 0;
        end
        Yield(jj,1) = DateList(ii);

        index = index + 1;
        jj = jj + 1;

    end

    %% 3.保存
    SaveFolderName = '..\00_DataBase\Edited_Factor\Yield\';
    if ~isdir(SaveFolderName)
        mkdir(SaveFolderName);
    end

    save([SaveFolderName,Commodity,'.mat'],'Yield')

end
