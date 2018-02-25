%% calNewBalance: �������ճֲֺͽ��ս������ݣ�������ճֲ�
%     balance: �����:  1.''�� 2.���ս�����ֵ��3.���ճֲ���ֵ��4.����Ȩ��
%                     ������:  1.��Լ���룬 2.�ֲ�����(+/-)�� 3.���ս���ۣ� 4.���ս�����ֵ
%     trades: 1.��ţ� 2.��Լ���룬3.��/����4.��/ƽ��5.���� 
function [newBalance] = calNewBalance(obj, balance, trades, trsCost, dataMap, msgHead)
        MultiplierMap = obj.MultiplierMap;
        if isempty(trades)
            pos=[];
            tvr = 0;
        else
            % ��ȡ��Լ����
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

            % ���㽻�׳ɱ�
            %   ����ɱ� = ���� * �۸� * ���� * (1 + trsCost)
            %   �����ɱ� = ���� * �۸� * ���� * (1 - trsCost)
            isBuy = ismember([trades{:,3}], '��');   
            isSell = ~isBuy;
            pos = cell2mat(trades(:,5:6)); 
            tvr = sum(pos(:,1).*pos(:,2).*lots(:,1));
            pos(isSell,1) = -pos(isSell,1);
            pos(isBuy,3) = pos(isBuy,1).*pos(isBuy,2).*lots(isBuy,1) * (1 + trsCost);
            pos(isSell,3) = pos(isSell,1).*pos(isSell,2).*lots(isSell,1) * (1 - trsCost);
        end
        
        % ���ճֲ� �� ���ս��� �ĺ�Լ�������
        blcLen = size(balance,1)-1;
        
        if blcLen==0 && isempty(trades) % �������ճֲ����޵��ս��ף�ֱ�ӷ���
            newBalance = {'', tvr, 0, balance{1,4}}; return;
        elseif blcLen==0  % �����ճֲֵ��е��ս���
            newBalance = union([], trades(:,2));
        else % �����ճֲ�
            trades(end+1:end+blcLen,2) = balance(1:blcLen,1);
            pos(end+1:end+blcLen,:) = cell2mat(balance(1:blcLen,2:4));
            newBalance = union(balance(1:blcLen,1), trades(:,2));            
        end
        
        % ����������ճֲֺ�ӯ��
        newPos = nan(size(newBalance,1),3);
        newPnl = 0;
        for i = 1:size(newBalance,1)  
            msk = ismember(trades(:,2), newBalance{i, 1});
            newPos(i,[1,3]) = sum(pos(msk,[1,3]),1);  % 1. ���³ֲ� 3. �ֲֳɱ�
            newPos(i,2) = obj.getSttlPrice(dataMap, newBalance{i,1}, 145900); % 2. �����
            if isnan(newPos(i,2))
                error([msgHead, ' ����Ʒ��:', newBalance{i,1}, ' �޽��������, ���벹��.']);
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
            
            newPnl = newPnl + sttlVal - newPos(i,3);    % pnl = ���ս�����ֵ - �����ս�����ֵ + ���ս��׳ɱ� ).
            newPos(i,3) = sttlVal;
        end
        newBalance(:,2:4) = num2cell(newPos);
        zMsk= newPos(:,1)==0;   % ɾ���ֲ�Ϊ0��ͷ�磻
        newBalance(zMsk,:) = [];
        newBalance(end+1,:) = {'', tvr, sumabs(newPos(:,3)),  balance{end,4}+newPnl};   % ����ģ���ʽ����
end

