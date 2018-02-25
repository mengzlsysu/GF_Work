function Yield = update_Yield(Commodity)
%% 每天更新Yield矩阵

    %% 1
    FolderName = '..\00_DataBase\Edited_Factor\Yield\';
    load([FolderName,Commodity,'.mat'],'Yield')
    load(['..\00_DataBase\MarketData\MainContract\',Commodity,'.mat'])
    
    StartDate = Yield(end,1);
    DateList = cell2mat(MainContract(:,1));
    StartDateIndex = find(DateList > StartDate,1,'first');

    jj = size(Yield,1)+1;

    %% 2
    for ii = StartDateIndex:length(DateList)
        Contract = MainContract{ii,2};        

        % load DayData
        if ~exist('DayData','var')
            load(['..\00_DataBase\MarketData\DayData\',Commodity,'\byContract\',Contract,'.mat']) % first time
            index = find(DayData(:,1) == DateList(ii));
        elseif ~strcmp(MainContract{ii,2},MainContract{ii-1,2})
            load(['..\00_DataBase\MarketData\DayData\',Commodity,'\byContract\',Contract,'.mat']) % MainContract has been changed    
            index = find(DayData(:,1) == DateList(ii));
        end

        if index > 1
            try
                Yield(jj,2) = log(DayData(index,6)) - log(DayData(index-1,6));
            catch
                Yield(jj:end,:) = [];
                break
            end
        else
            Yield(jj,2) = 0;
        end
        Yield(jj,1) = DateList(ii);

        index = index + 1;
        jj = jj + 1;

    end

    %% 3
    SaveFolderName = '..\00_DataBase\Edited_Factor\Yield\';
    if ~isdir(SaveFolderName)
        mkdir(SaveFolderName);
    end

    save([SaveFolderName,Commodity,'.mat'],'Yield')

end
    

    
    