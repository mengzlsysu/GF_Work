function Orders = Orders(Orders_Raw, DateList, ModelParams)
%%  ��DailyOrders��������
%   DailyOrders: 1. ʱ�� 2. ��Լ 3. ��/�� 4. 0/1 5. ����

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
        Orders = Orders_Raw{1};
        for itemp = 2:ss_temp    
            LastContract = unique(Orders_Raw{itemp-1}); NowContract = unique(Orders_Raw{itemp});
            Orders = [Orders;Orders_Raw{itemp}];
        end
        return;
    end
    
end

function ReplaceOrder = MCReplace(LSOrder, Date, ModelParams)
%   ���ݿ���LSOrder���ɸ���Date�Ļ���ReplaceOrder

    Str = {'��','��'};    
    Contract = LSOrder{2};
    
    ind = regexp(Contract, '\D');
    Commodity = Contract(ind);
    load(['..\00_DataBase\MarketData\MinData\ByContract\',Commodity,'\',ModelParams(1).TrsType,'\',Contract,'.mat'])
    index = find(MinData(:,1) <= Date, 1, 'last');

    ReplaceOrders{1, 1} = MinData(index,1)*1e6 + MinData(index,2);
    ReplaceOrders{1, 2} = Contract;
    ReplaceOrders{1, 3} = Str(~ismember(Str, LSOrder{3}));
    ReplaceOrders{1, 4} = 0;
    ReplaceOrders{1, 5} = LSOrder{index2,5};       

end