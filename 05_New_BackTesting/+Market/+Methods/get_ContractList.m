function ContractList = get_ContractList(Commodity)
%   ��ȡ���д�����Ʒ�ڻ���Լ�Ĵ����б�ContractList
    
%% �����Ӧ�ĳ���    
    global ts
    if isempty(ts)
        ts = actxserver('TSExpert.CoExec');
    end

    if nargin == 1
        ContractList = ts.RemoteExecute(['r:= sselect thisrow from getbk(''������Ʒ�ڻ�'') where thisrow like ''^',Commodity,''' end;; return r;']);
        index = find(~cellfun('isempty',regexpi(ContractList,[Commodity,'\d+'],'match')));
        ContractList = ContractList(index,:);
    else
        ContractList = ts.RemoteExecute('r:= sselect thisrow from getbk(''������Ʒ�ڻ�'') end; return r;');
    end


end
