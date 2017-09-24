# 大数据和数据仓库

主要是介绍Azure Mooncake 上的数据存储和SQL 数据仓库功能(SQL SERVER DataWarehouse)、大数据分析平台HDInsight 以及相关分析服务R Server。

Azure SQL 数据仓库是基于 SQL 的完全托管 PB 级云数据仓库。它极具弹性，用户可在几分钟内完成设置并在数秒内缩放容量。可单独缩放计算和存储，针对复杂的分析工作负荷进行突发计算，或者为归档场景减少仓库，并根据使用的内容进行支付，而不拘泥于预定义的群集配置 - 与传统数据仓库解决方案相比，可获得更高的成本效率。

HDInsight 将 Hadoop 和 Spark 的丰富生产力套件与你喜欢的开发环境（例如 Visual Studio 和 Eclipse）结合使用，并支持 IntelliJ for Scala、Python、R、Java 和 .NET。数据科学家可合并代码、统计方程和可视化内容，将 Jupyter 和 Zeppelin 这两种最广泛使用的笔记本进行集成，提炼有关数据的信息。HDInsight 也是唯一与 Microsoft R Server 集成的托管云 Hadoop 解决方案。与开源 R 相比，R Server 中的多线程数学库和透明并行能够多处理达 1000 倍的数据并且处理速度也能加快至 50 倍，从而帮助你定型更准确的模型以获得比之前更好的预测。

主要包括以下内容：

+ SQL 数据仓库的介绍幻灯片
+ HDInsight 的介绍幻灯片
+ 使用Azure SQL DW 数据仓库进行欺诈分析实验手册
+ 欺诈分析服务的构建PowerShell 脚本和分析SQL 脚本

进行欺诈分析实验，主要是FraudAnalysisDemoMC 文件夹下的三个文件：

+ 实验手册文件 FaudAnalysisDemoManual.md
+ 部署脚本文件 OneClickDeploy.ps1 需要您在文件中添加相应账户信息才可执行
+ 分析脚本文件 FraudAnalysisData.dsql

