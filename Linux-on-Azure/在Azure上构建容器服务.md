# 在 Azure 上构建容器服务

在本实验中，你将学习如何在微软的公有云平台 Azure 上设置一个 Kubernetes 群集。借助于 Azure 容器服务的支持，任何人都可以通过 Kubernetes 容器编排引擎轻松创建容器服务。

内容安排：

- **必备条件**
- **使用ARM模板创建群集**
- **创建你的第一个 Kubernetes 服务**
- **通过 Kubernetes Web UI 使用 Azure 容器服务**

我们同时支持使用 Web 管理门户网站和命令行在 Azure 上创建 Kubernetes 群集。

## 必备条件

在 Azure 上创建 Kubernetes 群集，需要使用到以下几个组件，只有在预先安装完成之后才能正式开始Kubernetes群集的创建。

1. 下载和安装Azure CLI 2.0

具体步骤请参考，这里不再赘述：

[https://docs.microsoft.com/zh-cn/cli/azure/install-azure-cli](https://docs.microsoft.com/zh-cn/cli/azure/install-azure-cli)

1. 下载和安装acs-engine 用来生成用于部署的ARM 模板

下载地址如下：

- [OSX](https://github.com/Azure/acs-engine/releases/download/v0.4.0/acs-engine-v0.4.0-darwin-amd64.tar.gz)
- [Linux 64bit](https://github.com/Azure/acs-engine/releases/download/v0.4.0/acs-engine-v0.4.0-linux-amd64.tar.gz)
- [Windows 64bit](https://github.com/Azure/acs-engine/releases/download/v0.4.0/acs-engine-v0.4.0-windows-amd64.zip)

## 使用ARM模板创建群集

Azure 快速入门模板可用于在 Azure 容器服务中部署一个群集。你可以修改系统提供的快速入门模板，以包含额外或高级的 Azure 配置。要使用 Azure 快速入门模板创建 Azure 容器服务群集，需要一个 Azure 订阅。

请按照以下步骤，使用模板和 Azure CLI 2.0 来部署一个群集。要部署 Kubernetes 群集，从 GitHub 中选择一个可用的 Kubernetes 模板。下面给出了部分可用模板的清单。除了默认 Orchestrator 选择之外，DC/OS 和 Swarm 模板是相同的。

-
  - [Kubernetes 模板](https://github.com/Azure/azure-quickstart-templates/tree/master/101-acs-kubernetes)

1. 打开Windows 命令控制台，输入下面命令来登录 Azure，并按命令行的提示在Windows上打开一个浏览器，然后访问命令行提示给出的URL地址，再输入命令行提示给出的访问码。在跳转到登录页面之后，再输入用户名和密码进行登录。
```
az cloud set --name AzureChinaCloud

az login -u <你的Azure账户登录名> -p <你的Azure 账户密码>

az account show
```
登录成功后，你会得到订阅信息，请注意你的订阅Id（也就是第二行的id的值）
```
[

  {

    “cloudName“: “AzureCloud“,

    “id“: “e06d665d-88f4-4e6b-831c-cf4dfb9f3c88“,

    “isDefault“: true,

    “name“: “Microsoft Azure Internal Consumption“,

    “state“: “Enabled“,

    “tenantId“: “72f988bf-86f1-41af-91ab-2d7cd011db47“,

    “user“: {

      “name“: “micl@microsoft.com“,

      “type“: “user“

    }

  }

]
```
1. 选择当前订阅。
```
az account set --subscription “e06d665d-88f4-4e6b-831c-cf4dfb9f3c88“
```
1. 在此订阅下创建一个自定义资源组，资源组的名称请自行指定。
```
az group create -n “<你自己指定的资源组名称>“ -l “chinanorth“
```
1. 获得服务主体的信息
```
az ad sp create-for-rbac --role=“Contributor“ --scopes=“/subscriptions/e06d665d-88f4-4e6b-831c-cf4dfb9f3c88/resourceGroups/<你的资源组名称>“
```
你将获取如下的服务主体信息：
```
{

  “appId“: “2412dfb2-983b-4d19-aec1-91ed894ce9ab“,

  “displayName“: “azure-cli-2017-05-29-05-32-22“,

  “name“: “http://azure-cli-2017-05-29-05-32-22“,

  “password“: “2ad760da-b05b-498e-81c0-01e7d3c931b8“,

  “tenant“: “72f988bf-86f1-41af-91ab-2d7cd011db47“

}
```
    在接下来的操作中，会用到 appId 和password信息。

1. 下面跳转到acs-engine 所在目录下，对目录下的kubernetes.json 文件进行编辑。如果目录下没有这个文件，您可以打开一个文本编辑器，将下面文本保存为kubernetes.json文件。
```
{

  “apiVersion“: “vlabs“,

  “location“: “chinanorth“,

  “properties“: {

    “orchestratorProfile“: {

      “orchestratorType“: “Kubernetes“

    },

    “masterProfile“: {

      “count“: 1,

      “dnsPrefix“: “<你自定义的DNS名称，也就是k8s实例名称>“,

      “vmSize“: “Standard\_A2“

    },

    “agentPoolProfiles“: [

      {

        “name“: “agentpool1“,

        “count“: 3,

        “vmSize“: “Standard\_A2“,

        “availabilityProfile“: “AvailabilitySet“

      }

    ],

    “linuxProfile“: {

      “adminUsername“: “azureuser“,

      “ssh“: {

        “publicKeys“: [

          {

            “keyData“: “ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDW1NWH65/eTJaFKavYyF+MonEcUwM4sp2ESyrKVRdAtlzScYf531Kbt7quVDXaqgE/0gjF+MHHbmscxdEprY+CmxUwgDNhBp6SXR+BxzjLPr+4r2NW+bEkmeQKyoISdu3wQqZDReJ/ewUWp0ZhvAfeAZkzmN+1hv41V37qe4gtz3o1fcSPjoJoEJzLJYrmavnn4qU1IMWJxEetH97Mo639MYokwq8LjebQ6x3qoM2Xh38ECLvC2gLSpcLcfBWVuhFG5chYuVxZ1Q3ttg5nWXkvSmz6/7FWMrBTpvArLEeXFozQ3A0UlcSbQpr/svt2KYtyJMf4mG+Z57YI3v4LXGiv“

          }

        ]

      }

    },

    “servicePrincipalProfile“: {

      “servicePrincipalClientID“: “<上一步骤中生成的appId>“,

      “servicePrincipalClientSecret“: “<上一步骤中生成的password>“

    }

  }

}
```
该文件需要被保存到acs-engine 命令所在目录中。其中带有<>标注的部分需要自行填写。

在完成对kubernetes.json 文件的编辑之后，可利用acs-engine 命令生成针对Kubernetes 部署的Azure ARM 资源模板文件。
```
cd acs-engine/  #跳转到acs-engine 根目录

./acs-engine generate ./kubernetes.json

ls ./\_output/<群集DNS名称>/ #此时，该目录下有一系列的文件生成。
```
1. 使用以下命令传递部署参数文件，以创建一个容器服务群集，其中：

- **RESOURCE\_GROUP**  是前面步骤中创建的资源组的名称。
- **DEPLOYMENT\_NAME** （可选）是为部署指定的名称。
- **TEMPLATE\_FILE**  是部署文件 azuredeploy.json的位置。
- **PARAMETERS**  **要在路径前面加一个@符号** 。
```
az group deployment create --name “<自定义部署名称>“ --resource-group “<你的资源组名称>“ --template-file “./\_output/<DNS名称>/azuredeploy.json“ --parameters @“./\_output/<DNS 名称>/azuredeploy.parameters.json“
```
群集的创建执行需要较长的时间，需要耐心等待。待出现命令提示行之后，即代表部署操作结束。这一过程将持续约20分钟左右。



## 创建你的第一个 Kubernetes 服务

完成此练习后，你将知道如何：

- 部署一个 Docker 应用程序并向全世界公开它。
- 使用 kubectl exec 在容器中运行命令。
- 访问 Kubernetes 仪表板。

在使用 kubernetes 之前，需要安装命令行工具 kubectl，可通过以下命令来安装它：（在这个软件所在文件夹下运行命令）
```
az acs kubernetes install-cli
```
然后，运行以下命令将主 Kubernetes 群集配置复制到 ~/.kube/config 文件。其中，id\_rsa 文件是含有SSH 公钥和私钥的秘钥文件，可以通过下面的链接下载获得：

[https://github.com/micli/learning/blob/master/src/IoT-C-SDK/id\_rsa](https://github.com/micli/learning/blob/master/src/IoT-C-SDK/id_rsa)

文件的密码为：P@ssw0rd!@# 会在执行scp 命令时用到。文件需要保存在一个已知的路径下，作为-i 参数的值提供给scp 命令。
```
ssh-keygen –R acstestmicl.chinanorth.cloudapp.chinacloudapi.cn

scp -i ~/.ssh/id\_rsa azureuser@acstestmicl.chinanorth.cloudapp.chinacloudapi.cn:.kube/config $HOME/.kube/config
```
启动容器

可通过运行以下命令来运行一个容器（在本例中是 Nginx Web 服务器）：
```
kubectl run nginx --image nginx
```
此命令在一个节点上的 Pod 中启动 Nginx Docker 容器。

要查看正在运行的容器，可运行：
```
kubectl get pods
```
你将看到以下信息：
```
NAME                    READY     STATUS              RESTARTS   AGE

nginx-701339712-hvtl2   0/1       ContainerCreating   0          16s
```
向全世界公开此服务

要向全世界公开此服务，需创建一个 LoadBalancer类型的 Kubernetes 服务：
```
kubectl expose deployments nginx --port=80 --type=LoadBalancer
```
此命令将使得 Kubernetes 创建一个应用于公有 IP 地址的 Azure 负载平衡器规则。此变更需要几分钟时间传播到负载平衡器。有关更多信息，请参阅  [Azure 容器服务的 Kubernetes 群集中的负载平衡容器](https://docs.microsoft.com/en-us/azure/container-service/container-service-kubernetes-load-balancing)。

运行以下命令，可观察到服务从 pending 状态更改为显示一个外部 IP 地址：
```
kubectl get svc

101-acs-kubernetes> kubectl get svc

NAME         CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE

kubernetes   10.0.0.1       <none>         443/TCP        18m

nginx        10.0.150.193   13.75.119.37   80:32257/TCP   4m
```
看到外部 IP 地址后，可以在浏览器中打开该地址：

![图片](/images/Linux-on-Azure/01.png)

浏览 Kubernetes UI

要查看 Kubernetes Web 界面，可以使用：
```
kubectl proxy
```
此命令在本地主机上运行一个经过身份验证的代理，你可以用它来查看在  [http://localhost:8001/ui](http://localhost:8001/ui) 上运行的 Kubernetes Web UI。有关更多信息，请参阅 [通过 Kubernetes Web UI 使用 Azure 容器服务](https://docs.microsoft.com/en-us/azure/container-service/container-service-kubernetes-ui)。

 ![图片](/images/Linux-on-Azure/02.png)
容器内的远程会话

Kubernetes 允许在群集内运行的远程 Docker 容器中运行命令。


```
kubectl get pods
```
使用你的 Pod 名称，可以在你的 Pod 上运行一个远程命令。例如：
```
kubectl exec <pod name> date
```
也可以使用 -it 标志来获取一个完全交互式的会话：
```
kubectl exec <pod name> -it bash
```
 ![图片](/images/Linux-on-Azure/03.png)

通过 Kubernetes Web UI 使用 Azure 容器服务

单击 **Workloads** ，UI 显示已部署的服务的视图：

 ![图片](/images/Linux-on-Azure/04.png)

单击正在运行 Pod 项。在 **Pods** 视图中，可以看到 Pod 中的容器相关信息，以及这些容器所使用的 CPU 和内存资源：

 ![图片](/images/Linux-on-Azure/05.png)

如果没有看到资源信息，可能需要等待几分钟，以便监控数据传播过来。

要查看容器的日志，单击 **View logs** 。

 ![图片](/images/Linux-on-Azure/06.png)

**查看你的服务**

除了运行容器之外，Kubernetes UI 还创建了一个外部服务，它通过配置一个负载平衡器将流量分配给群集中的容器。

在左侧的导航窗格中，单击 **Services** 来查看所有服务（应该只有一个）。

 ![图片](/images/Linux-on-Azure/07.png)