function Orders = Orders(Orders_Raw, MCDuration, ModelParams)
%%  ��MADurationʱ��ζ�ContractOrders��������

%%  0. ��ʼ��
    ss = length(Orders_Raw);
    Orders = {};
    Capital = 1e8;
    Str = {'��','��'};
    % �޶�5��������ƽ��, ��7����Ȼ�ս���
    StopDay = 7;
    
%%  1. ���������Լ���ڽ����л�, ֱ�ӽ���ƴ�Ӽ���    
    if ModelParams(1).MCTrade == 1
        Orders_Raw(~cellfun(@isempty,Orders_Raw ));
        % ��Ч����(�ǿ�)
        ss_temp = length(Orders_Raw);        
        for itemp = 1:ss_temp
            Orders(end+1:end+size(Orders_Raw{itemp},1),:) = Orders_Raw{itemp};
        end
        return;
    end
    
%%  2. ���������Լ���ڼ����ֲ����źŽ���, ����5��ƽ��
    for itemp = 1:ss
        if isempty(Orders_Raw{itemp})
           continue; 
        end
        
        StartDate = max(MCDuration(itemp,1), ModelParams(1).StartDate)*1e6; 
        EndDate = min(MCDuration(itemp,2), ModelParams(1).EndDate)*1e6;
        if StartDate >= EndDate
            continue;
        end
        Order_temp = Orders_Raw{itemp};
        
        % ��һ��Լƽ�ֵ�������Ϊ�ú�Լ��ʼ�µ�������
        if ~isempty(Orders)
           StartDate = max(StartDate, Orders{end,1}); 
        end
        
        % Ѱ���±�
        index1 = find(cell2mat(Order_temp(:,1)) >= StartDate & cell2mat(Order_temp(:,4)) ~= 0, 1, 'first');
        if isempty(index1)
            index1 = 1;
        end    
        index2 = find(cell2mat(Order_temp(:,1)) <= (EndDate + 150000) & cell2mat(Order_temp(:,4)) ~= 0, 1, 'last');
        if isempty(index2)
            continue;      
        end
        
        % �ж�StopDay(7)�����Ƿ�ƽ��
        if Order_temp{index2+1, 1} <= (MCDuration(itemp,2) + StopDay)*1e6
            index2 = index2 + 1;
            Orders = [Orders;Order_temp(index1:index2,:)];
        % 7���ǿ��ƽ��    
        else
            Contract = Order_temp{index2, 2};
            ind = regexp(Contract, '\D');
            Commodity = Contract(ind);
            load(['..\00_DataBase\MarketData\MinData\ByContract\',Commodity,'\',ModelParams(1).TrsType,'\',Contract,'.mat'])
            index_temp = find(MinData(:,1) <= (MCDuration(itemp,2) + StopDay), 1, 'last');
 
            NewOrders{1, 1} = MinData(index_temp,1)*1e6 + MinData(index_temp,2);
            NewOrders{1, 2} = Contract;
            NewOrders{1, 3} = Str(~ismember(Str, Order_temp{index2, 3}));
            NewOrders{1, 4} = 0;
            NewOrders{1, 5} = Order_temp{index2,5};   
            
            Orders = [Orders;Order_temp(index1:index2,:);NewOrders];
        end
        
    end
       
end