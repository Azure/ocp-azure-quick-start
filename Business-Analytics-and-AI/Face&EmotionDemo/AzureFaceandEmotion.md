# 今天你开心吗？(认知服务人脸识别和情绪识别服务) 

## 认识Azure
 微软在全球42个区域，打造了上百个数据中心，为客户提供Azure服务。Azure是一个不断增长的集成云服务集合，助您加快发展步伐，提高工作效率，节省运营成本。

[https://www.azure.cn/home/features/what-is-azure/](https://www.azure.cn/home/features/what-is-azure/)

 Microsoft Azure 官网： [https://www.azure.com](https://www.azure.com)

 Microsoft Azure 管理门户： [https://portal.azure.com](https://portal.azure.com)

由世纪互联运营的Microsoft Azure官网： [https://www.azure.cn/](https://www.azure.cn/)

由世纪互联运营的Microsoft Azure管理门户： [https://portal.azure.cn](https://portal.azure.cn)

Azure School:

[https://school.azure.cn/](https://school.azure.cn/)

微软智能云Azure为用户提供了业界领先的人工智能（AI）服务，基于Azure服务可以亲手快速搭建一个懂你的AI应用，希望这个小应用让你今天开心！

《今天你开心吗？》应用部署手册见附录。

## 如何获得Azure测试账号？

[https://www.azure.cn/pricing/1rmb-trial-full/?form-type=identityauth](https://www.azure.cn/pricing/1rmb-trial-full/?form-type=identityauth)

## 参考文档：

1. Azure解决方案： [https://azure.microsoft.com/zh-cn/solutions/](https://azure.microsoft.com/zh-cn/solutions/)
2. Azure用户手册： [https://docs.azure.cn/zh-cn/articles/azure-Iaas-user-manual-part1](https://docs.azure.cn/zh-cn/articles/azure-Iaas-user-manual-part1)
3. Azure开发人员指南： [https://azure.microsoft.com/zh-cn/campaigns/developer-guide/](https://azure.microsoft.com/zh-cn/campaigns/developer-guide/)
4. Azure常用操作指南 - 技术支持常见问题与解答： [https://docs.azure.cn/zh-cn/articles/](https://docs.azure.cn/zh-cn/articles/)
5. Azure常见问题：https://www.azure.cn/support/faq/



**【**** 附录】**

# 今天你开心吗？

基于微软智能云Azure亲手搭建和体验人脸情绪识别示例。

![图片](/images/Business-Analytics-and-AI/01.png)

**部署步骤**

1. 注册Azure账号（ [1元试用账号申请](https://www.azure.cn/pricing/1rmb-trial-full/)）
2. 创建认知服务APIs
3. 创建VM （Ubuntu Server 16.04LTS）
4. 部署应用（Node.js + Git）

**\*** 【 **创建认知服务APIs】**

本例使用Azure认知服务中的人脸识别API以及情绪识别的API。需要创建两个认知服务，获得这两个服务的key。

1. 1)使用Azure账号登录Azure门户
2. 2)登录后， 选择新建-&gt;Data+Analytics-&gt; 认知服务APIs
3. 3)设置账户名称，API类型（人脸API）以及定价层，新建资源组 rg-csface，点击创建。

![图片](/images/Business-Analytics-and-AI/02.png)

1. 4)创建成功后，可以在所有资源列表中（或仪表板中）看到刚刚创建的认知服务，点击进入到概述界面
2. 5)点击&quot;密钥&quot;，可以看到有两个密钥，记下其中一个。

![图片](/images/Business-Analytics-and-AI/03.png)

1. 6)回到Azure Portal的首页， 选择新建-&gt;Data+Analytics-&gt; 认知服务APIs
2. 7)设置账户名称，API类型（情绪API）以及定价层，点击创建即可。

![图片](/images/Business-Analytics-and-AI/04.png)

1. 8)创建成功后，可以在所有资源列表中（或仪表板中）看到刚刚创建的认知服务，点击进入到概述界面。
2. 9)点击&quot;密钥&quot;，可以看到有两个密钥，记下其中一个。

![图片](/images/Business-Analytics-and-AI/05.png)

\*【 **创建VM（Ubuntu Server 16.04LTS）** 】

1. 1)使用Azure账号登录Azure门户
2. 2)登录后， 选择新建-&gt;虚拟机，选择Ubuntu Server 16.04 LTS

![图片](/images/Business-Analytics-and-AI/06.png)

1. 3)指定虚拟机名称等，用户名： user01 密码: MSLoveLinux!

![图片](/images/Business-Analytics-and-AI/07.png)

![图片](/images/Business-Analytics-and-AI/08.png)
1. 4)配置可选功能，使用默认选项

![图片](/images/Business-Analytics-and-AI/09.png)

![图片](/images/Business-Analytics-and-AI/10.png)

1. 5)创建完毕后，记录虚拟机公共IP地址。

![图片](/images/Business-Analytics-and-AI/11.png)

1. 6)调整虚拟机网络安全组，添加入站访问安全规则，打开80端口

![图片](/images/Business-Analytics-and-AI/12.png)
![图片](/images/Business-Analytics-and-AI/13.png)

![图片](/images/Business-Analytics-and-AI/14.png)

**\*【部署应用】**

**ssh 远程连接到虚拟机**

**1、** 使用putty， 下载putty： [http://www.putty.org/](http://www.putty.org/)

**2、** 或者Linux ssh命令行等其它工具

![图片](/images/Business-Analytics-and-AI/15.png)

![图片](/images/Business-Analytics-and-AI/16.png)

**运行如下脚本安装部署应用：**
```
user01@vm-myvm01:~$ sudo apt-get update

user01@vm-myvm01:~$ sudo apt-get install nodejs

user01@vm-myvm01:~$ sudo apt install nodejs-legacy

user01@vm-myvm01:~$ sudo apt-get install npm

user01@vm-myvm01:~$ git init

user01@vm-myvm01:~$ git clone [https://github.com/cheneyszp/FastStartEmotionDemo.git](https://github.com/cheneyszp/FastStartEmotionDemo.git)

user01@vm-myvm01:~$ vi /home/user01/FastStartEmotionDemo/public/javascripts/main.js

--用上面记录的keys，分别给YOUR\_FACE\_API\_KEY、YOUR\_EMOTION\_API\_KEY赋值，然后保存。

user01@vm-myvm01:~$ cd /home/user01/FastStartEmotionDemo/

user01@vm-myvm01:~/FastStartEmotionDemo$ nohup sudo npm start &amp;
```


部署完毕，请用手机浏览器访问 [http://YOURIP](http://YOURIP)，请一定要转发到微信群中分享哦！

**今天你开心吗？**
Rendered
认识Azure
微软在全球42个区域，打造了上百个数据中心，为客户提供Azure服务。Azure是一个不断增长的集成云服务集合，助您加快发展步伐，提高工作效率，节省运营成本。

https://www.azure.cn/home/features/what-is-azure/

Microsoft Azure 官网： https://www.azure.com

Microsoft Azure 管理门户： https://portal.azure.com

由世纪互联运营的Microsoft Azure官网： https://www.azure.cn/

由世纪互联运营的Microsoft Azure管理门户： https://portal.azure.cn

Azure School:

https://school.azure.cn/

微软智能云Azure为用户提供了业界领先的人工智能（AI）服务，基于Azure服务可以亲手快速搭建一个懂你的AI应用，希望这个小应用让你今天开心！

《今天你开心吗？》应用部署手册见附录。

如何获得Azure测试账号？
https://www.azure.cn/pricing/1rmb-trial-full/?form-type=identityauth

参考文档：
Azure解决方案： https://azure.microsoft.com/zh-cn/solutions/
Azure用户手册： https://docs.azure.cn/zh-cn/articles/azure-Iaas-user-manual-part1
Azure开发人员指南： https://azure.microsoft.com/zh-cn/campaigns/developer-guide/
Azure常用操作指南 - 技术支持常见问题与解答： https://docs.azure.cn/zh-cn/articles/
Azure常见问题：https://www.azure.cn/support/faq/
【** 附录】**

今天你开心吗？
基于微软智能云Azure亲手搭建和体验人脸情绪识别示例。



部署步骤

注册Azure账号（ 1元试用账号申请）
创建认知服务APIs
创建VM （Ubuntu Server 16.04LTS）
部署应用（Node.js + Git）
\* 【 创建认知服务APIs】

本例使用Azure认知服务中的人脸识别API以及情绪识别的API。需要创建两个认知服务，获得这两个服务的key。

1)使用Azure账号登录Azure门户
2)登录后， 选择新建->Data+Analytics-> 认知服务APIs
3)设置账户名称，API类型（人脸API）以及定价层，新建资源组 rg-csface，点击创建。



4)创建成功后，可以在所有资源列表中（或仪表板中）看到刚刚创建的认知服务，点击进入到概述界面

5)点击"密钥"，可以看到有两个密钥，记下其中一个。



6)回到Azure Portal的首页， 选择新建->Data+Analytics-> 认知服务APIs

7)设置账户名称，API类型（情绪API）以及定价层，点击创建即可。



8)创建成功后，可以在所有资源列表中（或仪表板中）看到刚刚创建的认知服务，点击进入到概述界面。

9)点击"密钥"，可以看到有两个密钥，记下其中一个。



*【 创建VM（Ubuntu Server 16.04LTS） 】

1)使用Azure账号登录Azure门户
2)登录后， 选择新建->虚拟机，选择Ubuntu Server 16.04 LTS



3)指定虚拟机名称等，用户名： user01 密码: MSLoveLinux!





4)配置可选功能，使用默认选项





5)创建完毕后，记录虚拟机公共IP地址。



6)调整虚拟机网络安全组，添加入站访问安全规则，打开80端口







*【部署应用】

ssh 远程连接到虚拟机

1、 使用putty， 下载putty： http://www.putty.org/

2、 或者Linux ssh命令行等其它工具





运行如下脚本安装部署应用：
```
user01@vm-myvm01:~$ sudo apt-get update

user01@vm-myvm01:~$ sudo apt-get install nodejs

user01@vm-myvm01:~$ sudo apt install nodejs-legacy

user01@vm-myvm01:~$ sudo apt-get install npm

user01@vm-myvm01:~$ git init

user01@vm-myvm01:~$ git clone https://github.com/cheneyszp/FastStartEmotionDemo.git

user01@vm-myvm01:~$ vi /home/user01/FastStartEmotionDemo/public/javascripts/main.js
```
--用上面记录的keys，分别给YOUR_FACE_API_KEY、YOUR_EMOTION_API_KEY赋值，然后保存。
```
user01@vm-myvm01:~$ cd /home/user01/FastStartEmotionDemo/

user01@vm-myvm01:~/FastStartEmotionDemo$ nohup sudo npm start &
```
部署完毕，请用手机浏览器访问 http://YOURIP，请一定要转发到微信群中分享哦！

今天你开心吗？

