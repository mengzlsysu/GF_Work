function [LastTradeDay8,LastTradeDay6] = get_LastTradeDay(Contract)
%   获取指定合约的到期日/最后交易日

ts = actxserver('TSExpert.CoExec');
LastTradeDay6= ts.RemoteCallFunc('qh_LastTradeDay',{Contract}) + 693960;
LastTradeDay8 = str2num(datestr(LastTradeDay6,'yyyymmdd'));
