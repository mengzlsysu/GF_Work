function [kpi, nav] = calStats_Commodity(dailyStats)
    dt = dailyStats(2:end,1);
    dt = [dt, datenum(int2str(dt), 'yyyymmdd')];
    ret = dailyStats(2:end,4) ./ dailyStats(1:end-1,4) -1;
    tvr = dailyStats(2:end,2) ./ dailyStats(1:end-1,4) /2;
    hld= dailyStats(2:end,3) ./ dailyStats(2:end,4);
    sYr = floor(dt(1,1)/10000);
    eYr = floor(dt(end,1)/10000);
    yr_si = 1;
    for yr = sYr : eYr
        yr_ei = find(dt(:,1)<(yr+1)*10000, 1, 'last');
        kpi{yr-sYr+1} = calPfmc(dt(yr_si:yr_ei,:),ret(yr_si:yr_ei), tvr(yr_si:yr_ei), hld(yr_si:yr_ei));
        yr_si = yr_ei+1;
    end
    kpi{eYr-sYr+2} = calPfmc(dt, ret, tvr, hld);
    kpi{eYr-sYr+2}.return = (1+kpi{eYr-sYr+2}.return) ^(252/size(dt,1))-1;
    nav = [dailyStats(1,1),datenum(int2str(dailyStats(1,1)), 'yyyymmdd'),1;...
                 dt(:,1), dt(:,2), cumprod(1+ret)];
end

function rst = calPfmc(dt, ret, tvr, hld)
    rst.from= dt(1,1);
    rst.to = dt(end, 1);
    nav = [1; cumprod(ret+1)];
    rst.return = nav(end)-1;
    rst.turnover = mean(tvr);
    rst.sharp = mean(ret)/std(ret)*sqrt(252);
    [rst.drawdown, rst.ddstart, rst.ddend] = cal_drawdown(nav);
    if rst.drawdown~=0
        rst.ddstart = dt(rst.ddstart-1, 1);
        rst.ddend = dt(rst.ddend-1,1);
    end
    rst.maxHld = max(hld);
    rst.days = sum(hld~=0 | tvr ~=0);
    rst.upDays = sum(ret>0);
    rst.perwin = rst.upDays / rst.days;
    wn = weeknum(dt(:,2));
%     we = [true, wn(1:end-1)~=wn(2:end),true];
    we = [true; wn(1:end-1)~=wn(2:end);true];
    weNav = nav(we);
    rst.upWeeks = sum(weNav(2:end)>weNav(1:end-1));
    mth = month(dt(:,2));
    me = [true; mth(1:end-1)~=mth(2:end); true];
    meNav = nav(me);
    rst.upMonths = sum(meNav(2:end)>meNav(1:end-1));
end


function [dd, dds, dde] = cal_drawdown(nav)
    max = nav(1);
    max_i = 1;
    dd = 1;
    dds = 0;
    dde = 0;
    for i = 2 : length(nav)
        if nav(i) > max
            max = nav(i);
            max_i = i;
        elseif nav(i) / max < dd
            dd = nav(i) / max;
            dds = max_i+1;
            dde = i;
        end
    end
    dd = dd-1;
end