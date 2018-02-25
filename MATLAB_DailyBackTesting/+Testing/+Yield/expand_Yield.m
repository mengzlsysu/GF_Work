function Yield = expand_Yield(Commodity)
%% 将Yield矩阵扩展为多天对数收益率

    FolderName = '..\00_DataBase\Edited_Factor\Yield\';
    load([FolderName,Commodity,'.mat'],'Yield')

    StartDate = 20100101;

    StartDateIndex = find(Yield(:,1) >= StartDate,1,'first');

    Step = 5;
    ColLimit = 22;

    for ii = StartDateIndex:size(Yield,1)
        
        if Yield(ii,2) == sum(Yield(ii,2:end))
            Col = 3;
            
            while Col <= ColLimit
                 NumOfDays = (Col-2)*Step;
                 try
                     Yield(ii,Col) = sum(Yield(ii-NumOfDays+1:ii,2));
                     Col = Col + 1;
                 catch
                     Col = 100;
                 end
            end
            
        end
        
    end

    save([FolderName,Commodity,'.mat'],'Yield')

end