@DataMap: 
    · 数据容器，目前可读取日线和分钟数据；

+Asset: 计算各种情况下资产变动状况:
    · Asset结构包含三个变量：
    1、Holding 持仓
    2、Cash 现金
    3、Total 总资产 = Holding的保证金金额+Cash
    · Asset = update_Asset(Asset, TradeResult, TrsParam)
    更新交易后Asset的变化情况
    · Asset = settle_Asset(Asset, DataMap, DateTime,TrsParam)
    收盘结算后Asset的变化情况
    · totalAsset = cal_totalAsset(Asset,TrsParam)
    在Asset只有Holding和Cash两个变量时，计算Total的值

+Setting: 初始化设置
    · initial_TrsParam

+Trade: 
    · TradePlan = generate_TradePlan(Asset, DataMap, TargetHolding, DateTime, TrsParam)
    根据当前资产、目标持仓和交易数据，计算交易结果
        - TradePlan有三列，依次为合约、待成交数量、拟成交时间
    · TradeResult = generate_TradeResult(DataMap, TradePlan, TrsParam)
    根据TradePlan下达指令，返回交易结果TradeResult
    

