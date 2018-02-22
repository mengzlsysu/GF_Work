function display_Commodity(kpi, nav)
       
    fprintf('\n%20s%21s%16s%15s%16s%13s%18s%18s%15s%15s%15s%10s%10s%10s', 'from', 'to', 'return', 'turnover', 'sharp', 'drawdown', 'ddstart', 'ddend',...
        'perwin', 'up_days', 'up_weeks', 'up_mths', 'days');
    for i=1 : length(kpi)
        if i==length(kpi)  ||  i==1
            fprintf('\n');  
        end
        fprintf('%15d%15d%15.4f%15.4f%15.4f%15.4f%15d%15d%15.4f%15d%15d%15d%15d\n', kpi{i}.from, kpi{i}.to, kpi{i}.return, kpi{i}.turnover, kpi{i}.sharp, kpi{i}.drawdown,...
            kpi{i}.ddstart, kpi{i}.ddend, kpi{i}.perwin, kpi{i}.upDays, kpi{i}.upWeeks, kpi{i}.upMonths, kpi{i}.days);
    end

    
    trdDate =nav(:,1:2);
    nav = nav(:,3);
    plot(nav(2:end));
    xtick = [0, find(year(trdDate(1:end-1, 2))'~=year(trdDate(2:end,2))')]+1;
    set(gca, 'XTick', xtick);
    set(gca, 'XTickLabel', datestr(trdDate(xtick, 2), 'yyyy'));
    set(gca, 'XGrid', 'on');
    set(gca, 'YGrid', 'on');
end