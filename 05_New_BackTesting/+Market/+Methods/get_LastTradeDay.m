function [LastTradeDay8,LastTradeDay6] = get_LastTradeDay(Contract)
%   ��ȡָ����Լ�ĵ�����/�������

ts = actxserver('TSExpert.CoExec');
LastTradeDay6= ts.RemoteCallFunc('qh_LastTradeDay',{Contract}) + 693960;
LastTradeDay8 = str2num(datestr(LastTradeDay6,'yyyymmdd'));
