function loadMainContract(obj,Contract)

    Commodity = Contract(1:end-4);    
    load([obj.DataPath,'MainContract\',Commodity,'.mat']);   % ��ȡ����: MainContract 
    
    index = find(~strcmp(MainContract(2:end,2),MainContract(1:end-1,2)))+1; % �����յ����

    TempMat = MainContract(index,:);        

    [~,b] = unique(TempMat(:,2));
    TempMat = TempMat(b,:);
    
    Mat{1,1} = cell2mat(TempMat(:,1));
    Mat{1,2} = TempMat(:,2);
    
    eval(['obj.MainContract(''',Commodity,''') = Mat;']);
    
    
    
end
