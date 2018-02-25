function  plot_NetValue( ModelFolderName, H, CommodityList, DateList, Stats )
%   ���ݽ��������ֵ�ͱ�ļ۸����ƶԱ�ͼ, �����ú���, ����������
%   DateList ��һ�� �������� �ڶ��� MATLAB����

%   (�������ڵ�Ʒ�ֻز�)
    if length(CommodityList) ~= 1
        return;
    else
        Commodity = CommodityList{1};
    end

%% 0. ����û��������Լ������
    load(['..\00_DataBase\MarketData\MCContainer\',Commodity,'.mat']);
    
    NoClose = [];
    MCDateList = DateList;
    for itemp = 1:length(DateList)
        Date = DateList(itemp,1);
        if MCContainer.isKey(Date) == 0
            NoClose = [NoClose,itemp];
        else
            continue;
        end    
    end 
    MCDateList(NoClose,:) = [];
    
%% 1. ����������Լ���̼�����ͼ
    
    CloseStats = zeros(size(MCDateList,1),1);
    for itemp = 1:size(MCDateList,1)
        Date = MCDateList(itemp,1);
        
        if  itemp == 1 | strcmp(MCContainer(Date), Contract) == 0
            Contract = MCContainer(Date);
            load(['..\00_DataBase\MarketData\DayData\',Commodity,'\byContract\',Contract,'.mat'])
        end
        
        [ind,~] = find(DayData(:,1) == Date);
        if isempty(ind) == 0 
            CloseStats(itemp) = DayData(ind,6); 
        else %������Լȱ�۸�, ���������̼ۼ���
            CloseStats(itemp) = CloseStats(itemp - 1);
        end
    end

%% 2. �ҳ����н����������׵�����(��������Լ����)

    % �ҳ����TargetHolding���ļ���
    ModelFolderName = [ModelFolderName,'TargetHolding\'];
    
%     load('TrdDate.mat')
%     DateList = TrdDate(find(TrdDate(:, 1) >= StartDate & TrdDate(:, 1) <= EndDate), :);  
    PlotList{1,1} = 0; PlotList{1,2} = 0; ind = 1;
    
    for ii = 1:H:length(DateList)
       Date = DateList(ii);
       if exist([ModelFolderName,num2str(Date),'.mat']) == 0
           continue;
       else
        % ��ȡTargetHolding   
           load([ModelFolderName,num2str(Date),'.mat']);
        % long��Ϊ+1   
           if TargetHolding{:,2} > 0 && PlotList{ind,2} ~= 1 
               ind = ind + 1;
               PlotList{ind,1} = ii;
               PlotList{ind,2} = 1;
        % short��Ϊ-1
           elseif TargetHolding{:,2} < 0 && PlotList{ind,2} ~= -1 
               ind = ind + 1;
               PlotList{ind,1} = ii;
               PlotList{ind,2} = -1;
        % flat ��Ϊ0
           elseif TargetHolding{:,2} == 0 && PlotList{ind,2} ~= 0
               ind = ind + 1;
               PlotList{ind,1} = ii;
               PlotList{ind,2} = 0;
           end
       end
    end

%%  3. ��ͼ    
    NetValue = Stats(:,4);

    subplot(2,1,1);   
    [H,~,~] = plotyy(MCDateList(:,2), NetValue( end-size(MCDateList,1)+1:end ),MCDateList(:,2),CloseStats);
    d1=get(H(1),'ylabel');
    set(d1,'string','NetValue'); 
    set(H(1),'xlim',[MCDateList(1,2), MCDateList(end,2)]);
    d2=get(H(2),'ylabel');    
    set(d2,'string','Close');
    title('��ֵ����/���̼�����');  
    set(H(2),'xlim',[MCDateList(1,2), MCDateList(end,2)]);
    dateaxis('x',2);  

    subplot(2,1,2);
    plot(MCDateList(:,2),CloseStats,'Color','b');
    hold on; 
    for ktemp = 2:size(PlotList,1)
       itemp = MCDateList(PlotList{ktemp, 1} - size(DateList,1) + size(MCDateList,1),2);
       jtemp = PlotList{ktemp, 1} - size(DateList,1) + size(MCDateList,1);
       if PlotList{ktemp, 2} == 1
           stem(itemp,CloseStats(jtemp),'Marker','none','Color','r');
           hold on;
       elseif PlotList{ktemp, 2} == -1
           stem(itemp,CloseStats(jtemp),'Marker','none','Color','g');
           hold on;          
       elseif PlotList{ktemp, 2} == 0
           stem(itemp,CloseStats(jtemp),'Marker','none','Color','k');
           hold on;                     
       end
    end
    dateaxis('x',2);        
    title('�۸�����/�µ�ʱ��');
    axis tight;       
    
%     subplot(3,1,3);
%     plot(1:length(MCDateList),NetValue(end-length(MCDateList)+1:end),'Color','b');
%     hold on; 
%     for ktemp = 2:size(PlotList,1)
%        itemp = PlotList{ktemp, 1}-length(DateList)+length(MCDateList);
%        if PlotList{ktemp, 2} == 1
%            stem(itemp,Stats(itemp+length(DateList)-length(MCDateList),4),'Marker','none','Color','r');
%            hold on;
%        elseif PlotList{ktemp, 2} == -1
%            stem(itemp,Stats(itemp+length(DateList)-length(MCDateList),4),'Marker','none','Color','g');
%            hold on;          
%        elseif PlotList{ktemp, 2} == 0
%            stem(itemp,Stats(itemp+length(DateList)-length(MCDateList),4),'Marker','none','Color','k');
%            hold on;                     
%        end
%     end
%     title('��ֵ����/�µ�ʱ��');
%     axis tight;   
    
end

