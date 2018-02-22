function TrdDate = loadDate(obj)
%% 读取交易时间
        load('TrdDate.mat');

%%  没有天软略去

%     if exist('TrdDate.mat','file')
%         load('TrdDate.mat')
%         if TrdDate(end,2) == today
%             return
%         end
%     end
%     clear TrdDate
% 
%     ts_quest = ['Mat = obj.ts.RemoteExecute(''',...
%         'SetSysParam(pn_cycle(),cy_day()); ',...
%         'BegT := inttodate(19900101); ',...
%         'EndT := inttodate(',datestr(today,'yyyymmdd'),'); ',...
%         'return MarketTradeDayQk(BegT,EndT);'');'];
%     
%     eval(ts_quest);
%     
%     TrdDate(:,2) = cell2mat(Mat) + 693960;   
%     TrdDate(:,1) = str2num(datestr(TrdDate(:,2),'yyyymmdd'));
%     
%     save('TrdDate.mat','TrdDate')
    
end