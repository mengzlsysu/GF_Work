function [Kpi, Nav] = reapStats_Commodity(modelPath, modelName, DailyStats)
        [Kpi, Nav] = Order2Result.Stats.calStats_Commodity(DailyStats);
        save([modelPath,modelName,'\DailyStats.mat'], 'DailyStats');
        save([modelPath,modelName,'\Kpi.mat'], 'Kpi');
        save([modelPath,modelName,'\Nav.mat'], 'Nav');
end