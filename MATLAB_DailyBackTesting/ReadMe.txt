类似原来的日线回测系统

initial_ModelParams
所有的参数放在ModelParams结构体变量中, 请自行设置
每次运行前先运行 initial_ModelParams.mat


+Signal/
1. +TI
计算日线技术指标的函数, 根据自行需要补充
2. +Signal
根据选取的技术指标, 综合计算最终指标的方式, 例如取符号加总, 根据需要自行补充


+Testing/+Factors/@Temp/generate_TargetHolding
根据指标值确定各品种的仓位和方向, 根据需要自行补充
Version 1.0中将补充一些常用方式供选择, 这里设置的是 指标为正做多, 指标为负做空


BackTesting
输入CommodityList: 进行操作的品种, 放在一个元胞数组中 