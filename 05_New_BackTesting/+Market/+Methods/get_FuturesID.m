function FuturesID = get_FuturesID(Commodity,Date)
%   ��ȡĳ�죨Date�������������׵���Ʒ��Commodity����Լ����FuturesID
%   Dateȱʡʱ��Ĭ��Ϊ��ǰ����

if nargin == 1;
    Date = today;
elseif Date > 19000000
    Date = datenum(num2str(Date),'yyyymmdd');
end

ts = actxserver('TSExpert.CoExec');
FuturesID = ts.RemoteCallFunc('GetFuturesID',{Commodity,Date-693960});