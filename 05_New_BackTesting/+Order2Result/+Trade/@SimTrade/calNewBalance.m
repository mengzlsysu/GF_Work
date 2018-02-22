%% calNewBalance: 根据昨日持仓和今日交易数据，计算今日持仓
%     balance: 最后行:  1.'', 2.当日交易市值, 3.日终持仓市值, 4.日终权益, 5.''
%                     其它行:  1.合约代码， 2.持仓数量(+/-)， 3.当日结算价， 4.当日结算市值,  5.持仓成本
%     trades: 1.序号， 2.合约代码，3.买/卖，4.开/平，5.数量 
function [newBalance] = calNewBalance(obj, balance, trades, trsCost, dataMap, msgHead)
        MultiplierMap = obj.MultiplierMap;
        if isempty(trades)
            pos=[];
            tvr = 0;
        else
            % 提取合约乘数
            lots = zeros(size(trades,1),1);
            for itemp = 1:size(trades,1)
                if MultiplierMap.isKey(trades{itemp,2})
                    lots(itemp,1) = MultiplierMap(trades{itemp,2});
                elseif strcmp(regexp(trades{itemp,2},'\D+','match'),'IF')
                    lots(itemp,1) = 300;
                elseif strcmp(regexp(trades{itemp,2},'\D+','match'),'IH')
                    lots(itemp,1) = 300;
                elseif strcmp(regexp(trades{itemp,2},'\D+','match'),'IC')
                    lots(itemp,1) = 200;    
                end
            end

            % 计算交易成本
            %   买入成本 = 数量 * 价格 * 乘数 * (1 + trsCost)
            %   卖出成本 = 数量 * 价格 * 乘数 * (1 - trsCost)
            isBuy = ismember([trades{:,3}], '买');   
            isSell = ~isBuy;
            pos = cell2mat(trades(:,5:6)); 
            tvr = sum(pos(:,1).*pos(:,2).*lots(:,1));
            pos(isSell,1) = -pos(isSell,1);
            pos(isBuy,3) = pos(isBuy,1).*pos(isBuy,2).*lots(isBuy,1) * (1 + trsCost);
            pos(isSell,3) = pos(isSell,1).*pos(isSell,2).*lots(isSell,1) * (1 - trsCost);
        end
        
        % 昨日持仓 与 今日交易 的合约代码汇总
        blcLen = size(balance,1)-1;
        
        if blcLen==0 && isempty(trades) % 既无昨日持仓又无当日交易，直接返回
            newBalance = {'', tvr, 0, balance{1,4}}; return;
        elseif blcLen==0  % 无昨日持仓但有当日交易
            newBalance = union([], trades(:,2));
        else % 有昨日持仓
            trades(end+1:end+blcLen,2) = balance(1:blcLen,1);
            pos(end+1:end+blcLen,:) = cell2mat(balance(1:blcLen,2:4));
            newBalance = union(balance(1:blcLen,1), trades(:,2));            
        end
        
        % 计算今日日终持仓和盈亏
        newPos = nan(size(newBalance,1),3);
        newPnl = 0;
        for i = 1:size(newBalance,1)  
            msk = ismember(trades(:,2), newBalance{i, 1});
            newPos(i,[1,4]) = sum(pos(msk,[1,3]),1);  % 1. 最新持仓 3. 持仓成本
            newPos(i,2) = obj.getSttlPrice(dataMap, newBalance{i,1}, 145900); % 2. 结算价
            if isnan(newPos(i,2))
                error([msgHead, ' 交易品种:', newBalance{i,1}, ' 无结算价数据, 烦请补齐.']);
            end
 
            if MultiplierMap.isKey(newBalance{i,1})
                sttlVal = newPos(i,1) * newPos(i,2)*MultiplierMap(newBalance{i,1});
            elseif strcmp(regexp(newBalance{i,1},'\D+','match'),'IF')
                sttlVal = newPos(i,1) * newPos(i,2)*300;
            elseif strcmp(regexp(newBalance{i,1},'\D+','match'),'IH')
                sttlVal = newPos(i,1) * newPos(i,2)*300;
            elseif strcmp(regexp(newBalance{i,1},'\D+','match'),'IC')
                sttlVal = newPos(i,1) * newPos(i,2)*200;    
            end  
            
            newPnl = newPnl + sttlVal - newPos(i,4);    % pnl = 今日结算市值 - （昨日结算市值 + 今日交易成本 ).
            newPos(i,3) = sttlVal;
        end
        newBalance(:,2:5) = num2cell(newPos);
        zMsk= newPos(:,1)==0;   % 删除持仓为0的头寸；
        newBalance(zMsk,:) = [];
        newBalance(end+1,:) = {'', tvr, sumabs(newPos(:,3)),  balance{end,4}+newPnl, ''};   % 更新模型资金余额
end

