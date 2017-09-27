# DevOps 持续集成与持续部署

## 背景介绍

我们的动手实验将引用一个样例应用叫做Parts Unlimited。Parts Unlimited是在一本叫做《凤凰项目：一个IT运维的传奇故事》（(The Phoenix Project)）的书里31-35章中提到的一个虚拟的用于培训的电商网站

这个样例程序，由三部分构成： 使用.Net Core的电子商务网站， 使用开源的Java和MongoDB的生产管理系统以及中间件系统

全部源代码可以通过微软官方的GitHub下载，地址：https://github.com/Microsoft/PartsUnlimited

在这一部分动手实验里面，您将完成产品从代码到上线的发布管道的建立。我们将借助TFS所提供的持续集成引擎和Release Management功能构建一条全自动的发布管道，您将可以在完成代码编写后一键发布新版本到生产环境，并在这个过程中通过测试环境完成产品功能的验证和上线审批。



## 必要条件

- 需要有已激活的Visual Studio team service
- 本地安装Git for Windows
- 一台Windows 10 设备

![图片](/images/DevOps-and-Dev-Test/01.png)

## Exercise 1: 为你的项目添加持续集成能力

**时长** : 30分钟

## 实验步骤

- 把源码导入到你的VSTS（Visual Studio Team Services）账户中： 在这个步骤里头，你会链接你自己的VSTS账户，下载PartsUnlimited的源码，并且将代码推送到你的VSTS账户里头。有两种方式，一种是使用Git命令行，另外一种是使用Visual Studio
- 创建持续集成的生成构建：在这个步骤，你会创建一个生成定义，当有代码推送到VSTS中的仓库的时候会自动出发生成的操作。
- 在VSTS中测试CI的触发器

TFS使用  **生成定义**  来管理项目的持续集成配置，在每一个  **团队项目**  中，可以配置多个  **生成定义**  分别对应不同的代码分支，测试环境或者团队。在这个实验中，我们只对如何配置  **生成定义**  进行描述.

### Task 1: 使用Git导入源代码到VSTS账户中来

为了使用VSTS生成功能，我们会将应用程序代码推送到Visual Studio团队服务帐户中。

如果还没创建项目，请创建项目，使用Git来管理代码。

![图片](/images/DevOps-and-Dev-Test/02.png)

![图片](/images/DevOps-and-Dev-Test/03.png)

![图片](/images/DevOps-and-Dev-Test/04.png)

- 本地创建目录，并将示例代码克隆到本地目录

在你的本地计算机创建一个目录，比如你可以创建以下目录

## C:\Source\Repos

打开命令行或者Powershell，然后进入到该目录下。

输入以下命令来克隆我们的示例程序

## git clone https://github.com/Microsoft/PartsUnlimited.git HOL

大概需要几分钟的时间将代码克隆下来。

![图片](/images/DevOps-and-Dev-Test/05.png)

你可以使用下面的命令进入到目录下

## cd HOL

- 移除GitHub的链接

你克隆下来的目录中包含了指向GitHub远端仓库的链接名称origin，移除它。

## git remote remove origin

- 找到VSTS的仓库URL

记得你刚才创建的账户名称和项目名称，默认的Git仓库地址如下所示：

## https://&lt;account&gt;.visualstudio.com\\_git\&lt;project&gt;

或者你可以直接上项目的首页，就可以看到这个链接。

![图片](/images/DevOps-and-Dev-Test/06.png)

- 添加VSTS的仓库URL

输入以下命令：

## git remote add origin https://&lt;account&gt;.visualstudio.com\&lt;project&gt;\\_git\&lt;project&gt;

现在你可以向仓库里头添加代码了。

输入以下命令即可将代码推送到远端仓库：

## git push -u origin --all

你应该可以在VSTS里头看到代码啦！

![图片](/images/DevOps-and-Dev-Test/07.png)

![图片](/images/DevOps-and-Dev-Test/08.png)

### Task 2: 创建下持续集成的生成构建

- 进入VSTS网站，点击项目，点击&quot;Build&amp;Release&quot;

![图片](/images/DevOps-and-Dev-Test/09.png)
- 点击&quot;
###
**New Definition**&quot;

![图片](/images/DevOps-and-Dev-Test/10.png)

- 选择&quot;空白&quot;的模板，点击&quot;Apply&quot;按钮。其实你可以看到，这里可以支持很多种模板，包括Android、iOS、Node.js等等。

![图片](/images/DevOps-and-Dev-Test/11.png)

- 设置&quot;Hosted&quot;模式，设置resource是本项目的master，然后点击&quot;Save&amp;queue&quot;。
- 点击&quot;Add Task&quot;，选择&quot;Utility&quot;，选择PowerShell，点击&quot;Add&quot;。

![图片](/images/DevOps-and-Dev-Test/12.png)

- 依然在本页面，选择&quot;Test&quot;，选择&quot;Publish Test Result&quot;，点击&quot;Add&quot;。

![图片](/images/DevOps-and-Dev-/13.png)

- 依然在本页面，选择&quot;Utility&quot;，选择&quot;Copy and Publish Artifacts&quot;，点击&quot;Add&quot;。

![图片](/images/DevOps-and-Dev-Test/14.png)

- 这样，我们就已经添加了3个任务。

![图片](/images/DevOps-and-Dev-Test/15.png)

- 点击&quot;PowerShell Script&quot;，更新脚本名称为&quot;dotnet restore, build, test and publish&quot;，Type的话选&quot;File Path&quot;，Script Path的话输入 &quot;build.ps1&quot; ，Arguments 属性的话输入 $(BuildConfiguration) $(build.stagingDirectory)

![图片](/images/DevOps-and-Dev-Test/16.png)

-
点击&quot; **Publish Test Results**&quot;任务，更新Test Result Format为&quot; **XUnit**&quot;， **Test Results File** 更改为&quot; **\*\*/testresults.xml**&quot;。 ![图片](/images/DevOps-and-Dev-Test/17.png)
- 点击&quot;  **Copy Publish Artifact**&quot;，更新 **Copy Root** 为&quot;**$(build.stagingDirectory)**&quot;， **Contents** 的填入&quot; **\*\*\\*.zip**&quot;，
###
**Artifact Name** 的话输入 &quot; **drop**  &quot; ， **Artifact Type** 属性的话选 **Server**

![图片](/images/DevOps-and-Dev-Test/17.png)

- 点击&quot;Variables&quot;，点击&quot;Add&quot;，添加新的变量参数

![图片](/images/DevOps-and-Dev-Test/18.png)

- 输入&quot;BuildConfiguration&quot;，值为&quot;release&quot;，这个值我们在build.ps1中会用到。

![图片](/images/DevOps-and-Dev-Test/19.png)

- 点击&quot;Triggers&quot;，把&quot;Continuous Integration&quot;选项打开，确保我们可以在每次更改的时候触发生成操作。

![图片](/images/DevOps-and-Dev-Test/20.png)

- 点击右上角的&quot;Save&quot;按钮，保存我们的修改

![图片](/images/DevOps-and-Dev-Test/21.png)

### Task 3: 在VSTS中测试CI的触发器

我们现在将测试持续集成生成(CI)对的功能，我们通过使用VSTS在&quot;PartsUnlimited&quot;中更改代码来测试。

- 选择Code 这个tab，然后选择咱们的代码仓库 HOL

![图片](/images/DevOps-and-Dev-Test/22.png)

- 切到文件/src/PartsUnlimitedWebsite/Controllers/HomeController.cs，点击&quot;Edit&quot;

![图片](/images/DevOps-and-Dev-Test/23.png)

- 随便加入一行代码，比如加入一行注释&quot;//This is a test of CI&quot;，点击&quot;Commit&quot;

![图片](/images/DevOps-and-Dev-Test/24.png)

![图片](/images/DevOps-and-Dev-Test/25.png)

- 点击&quot;Build and Realease&quot;，你应该可以看到已经出发的生成操作

![图片](/images/DevOps-and-Dev-Test/26.png)

- 点击生成号码&quot;#2&quot;，可以看到详细的生成过程，还有日志信息等。

![图片](/images/DevOps-and-Dev-Test/27.png)

- 点击&quot;Build 2&quot;，可以看到生成的报告，比如生成失败会有相应的错误信息。

![图片](/images/DevOps-and-Dev-Test/28.png)