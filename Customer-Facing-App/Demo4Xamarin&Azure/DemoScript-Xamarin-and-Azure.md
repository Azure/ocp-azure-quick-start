# 使用Xamarin和Azure web服务构建跨平台应用体验

在本实验中，你可以学习并体验到如何使用Xamarin开发iOS和Android的应用，并且集成Azure PaaS平台的能力，包括：通知中心、

## 特别说明：

- 本实验介绍的是在Windows平台上，用Visual Studio 2017和Xamarin Workload来开发跨平台的应用（不是游戏），其可以通过Xamarin Live Player进行开发调试。
- 关于在Mac平台上使用Visual Studio Code进行iOS, MacOS和Android的开发，请浏览 [http://developer.xamarin.com](http://developer.xamarin.com)



## 内容安排

- 必备条件
- 配置本实验开发环境
- 准备Xamarin Demo工程
- 部署展示Xamarin Demo应用
  - 使用APK文件进行安装
  - 使用VS进行编译并真机部署
  - 使用Xamarin Live Player进行部署（待更新）
- 整合Azure高级服务
  - 应用服务
  - 推送服务
  - 媒体服务（待更新）
  - 认知服务（待更新）

## 必备条件

为了实现Xamarin跨平台应用开发，并部署服务在Azure上，需要以下的开发工具和环境，才能完成本实验的内容。

- 操作系统：Windows 10 15063版本
- 开发工具：Visual Studio 2017 15.3.3版本以上， [下载链接](https://www.visualstudio.com/vs/preview/)
- 手机设备：Android手机并开启开发者调试模式
- Azure账号：激活的Azure订阅账号



## 配置本实验开发环境

1. 安装VS工作项 – Azure Development，如下图所示

![图片](/images/Customer-Facing-App/01.png)

1. 安装VS工作项 – Mobile development with .NET，如下图所示

![图片](/images/Customer-Facing-App/02.png)

1. 安装VS工作项 – .NET desktop development，如下图所示

![图片](/images/Customer-Facing-App/03.png)

## 准备Xamarin Demo工程

1. 下载Xamarin Demo压缩文件(AXMobile.zip)，解压缩后可以看到文件列表如下

![图片](/images/Customer-Facing-App/04.png)

1. 双击AXMobile.sln文件，用VS打开工程文件，右键点击工程根目录，点击选择&#39;Clean Solution&#39;，如下图所示

![图片](/images/Customer-Facing-App/05.png)

1. 再次右键点击工程根目录，点击选择&#39;Build Solution&#39;，如下图所示

![图片](/images/Customer-Facing-App/06.png)

1. 恢复Nuget安装包，右键点击工程根目录，点击选择&#39;Restore NuGet Packages&#39;，如下图所示

![图片](/images/Customer-Facing-App/07.png)

1. 截至当前，如无任何错误信息提示，则表明Demo的工程文件准备完毕。

## 部署展示Xamarin Demo应用

方法一，使用APK文件安装到安卓手机（文件名为：Xamarin-Demo-AXMobile-v1.apk）

1. 此方法可以快速为客户进行展示。安装成功后，在手机上会出现名字为&#39;AX&#39;的应用图标。

1. 打开AX应用后，可以浏览 点击 会议 和 新闻 进行浏览

![图片](/images/Customer-Facing-App/08.png) ![图片](/images/Customer-Facing-App/09.png)

1. 在新闻列表中，点击第二条新闻，即微软云媒体服务介绍，可以用于展示Azure Media Service能力

![图片](/images/Customer-Facing-App/10.png) ![图片](/images/Customer-Facing-App/11.png)

方法二，使用VS进行编译并真机部署

1. 通过USB线连接安卓手机与电脑，在安卓手机设置中，需要开启开发者模式并运行通过USB进行调试，正确连接后，会显示可以的安卓设备

![图片](/images/Customer-Facing-App/12.png)

1. 右键选择工程文件中的&#39;AXMobile.Droid&#39;，点击选择&#39;Set as StartUp Project&#39;，如下图所示

![图片](/images/Customer-Facing-App/13.png)

1. 选择要部署的安卓设备，启动Debug进行部署和调试，部署成功后，在手机上会出现名字为&#39;AX&#39;的应用图标，同上述的方法一

方法三，使用Xamarin Live Player进行部署（待更新）

说明：Xamarin Live Player可以让开发者直接在iOS或者Android设备上持续部署、测试和调试应用，目前该功能只在VS017 Preview版本中支持，我们后续会进行更新。



## 整合Azure高级服务

通过使用Azure高级服务，可以帮助显著提升Xamarin开发的应用体验和开发效率。目前，通用的Azure高级服务包括：应用服务，推送服务，媒体服务，认知服务等。该Demo中已经使用了应用服务，推送服务和媒体服务，展示如下。

1. 应用服务。本Demo中的会议和新闻的信息均通过Azure应用服务提供，用.NET开发的后端服务直接部署成Azure的应用服务，点击NewsService.cs文件，可以考虑服务端API信息如下。

![图片](/images/Customer-Facing-App/14.png)

说明：我们在更新该后端服务，后续会提供源代码和配置文件，方便演示人员部署到自己的Azure订阅中

1. 推送服务。Azure的推送服务可以把信息推送到iOS和Android的设备上。打开Demo中的AppConstants.cs文件，可以考虑推送服务的配置信息如下图所示

![图片](/images/Customer-Facing-App/15.png)