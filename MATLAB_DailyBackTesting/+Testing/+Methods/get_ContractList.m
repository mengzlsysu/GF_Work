function ContractList = get_ContractList(Commodity)
%   获取所有存续商品期货合约的代码列表ContractList
%   由于没有天软，直接导入Excel数据

    load('..\00_DataBase\get_ContractList.mat');
    
%% 处理程序
%     [~,~,ContractList] = xlsread('..\00_DataBase\get_ContractList.xlsx');
%     ContractList = strrep(ContractList,'''','');  %去除引号方便之后读取文件
%     save('..\00_DataBase\get_ContractList.mat','ContractList');

%% 天软对应的程序    
%     global ts
%     if isempty(ts)
%         ts = actxserver('TSExpert.CoExec');
%     end
% 
%     if nargin == 1
%         ContractList = ts.RemoteExecute(['r:= sselect thisrow from getbk(''国内商品期货'') where thisrow like ''^',Commodity,''' end;; return r;']);
%         index = find(~cellfun('isempty',regexpi(ContractList,[Commodity,'\d+'],'match')));
%         ContractList = ContractList(index,:);
%     else
%         ContractList = ts.RemoteExecute('r:= sselect thisrow from getbk(''国内商品期货'') end; return r;');
%     end


end
