function FuturesID = get_FuturesID(Commodity,Date)
%   获取某天（Date）所有正常交易的商品（Commodity）合约代码FuturesID
%   Date缺省时，默认为当前日期

if nargin == 1;
    Date = today;
elseif Date > 19000000
    Date = datenum(num2str(Date),'yyyymmdd');
end

ts = actxserver('TSExpert.CoExec');
FuturesID = ts.RemoteCallFunc('GetFuturesID',{Commodity,Date-693960});