@DataMap: 
    �� ����������Ŀǰ�ɶ�ȡ���ߺͷ������ݣ�

+Asset: �������������ʲ��䶯״��:
    �� Asset�ṹ��������������
    1��Holding �ֲ�
    2��Cash �ֽ�
    3��Total ���ʲ� = Holding�ı�֤����+Cash
    �� Asset = update_Asset(Asset, TradeResult, TrsParam)
    ���½��׺�Asset�ı仯���
    �� Asset = settle_Asset(Asset, DataMap, DateTime,TrsParam)
    ���̽����Asset�ı仯���
    �� totalAsset = cal_totalAsset(Asset,TrsParam)
    ��Assetֻ��Holding��Cash��������ʱ������Total��ֵ

+Setting: ��ʼ������
    �� initial_TrsParam

+Trade: 
    �� TradePlan = generate_TradePlan(Asset, DataMap, TargetHolding, DateTime, TrsParam)
    ���ݵ�ǰ�ʲ���Ŀ��ֲֺͽ������ݣ����㽻�׽��
        - TradePlan�����У�����Ϊ��Լ�����ɽ���������ɽ�ʱ��
    �� TradeResult = generate_TradeResult(DataMap, TradePlan, TrsParam)
    ����TradePlan�´�ָ����ؽ��׽��TradeResult
    

