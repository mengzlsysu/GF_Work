function Multiplier = get_Multiplier(Contract, ts)

ts_quest = ['Multiplier = ts.RemoteExecute(''SetSysParam(Pn_Stock(),"', Contract, '"); return base(703007);'');'];
eval(ts_quest);