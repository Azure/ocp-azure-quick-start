# 创建和使用IoT Hub 服务

## 前置条件

在进行本实验之前，需要您在计算机中安装以下组件：

- Node.js 下载地址： [https://nodejs.org/zh-cn/](https://nodejs.org/zh-cn/)
- Git 客户端 下载地址： [https://git-scm.com/downloads](https://git-scm.com/downloads)

## 创建IoT Hub 服务

    在正式向IoT Hub 注册服务之前，必须要先创建一个位于Azure 上的IoT Hub 服务资源。首先，需要用Azure账号登录portal.azure.cn。 在门户网站上点击"+"号，选择物联网-> IoT Hub, 创建一个IoT Hub 服务。在测试阶段，可以在服务级别中选择S1-标准，并新建一个名为"IoTDemo"的资源组，用于开发和测试。 如下图所示：

 ![图片](/images/Internet-of-Things/01.png)

    待创建完成后，在IoT Hub 服务中选择"共享访问策略"->"iothubowner"->"连接字符串 - 主密钥" 进行复制。如图所示：

 ![图片](/images/Internet-of-Things/02.png)

   复制出来的内容就是IoT服务连接字符串，将会在下面的操作中用到。

## 安装和使用IoT Hub Explorer 工具

   IoT SDK 内含一个用Node.js 开发的命令行工具来帮助开发人员在命令行下管理Azure IoT Hub 服务。 这个命令行工具名为iothub-explorer，安装方法如下：

npm install -g iothub-explorer

    在一切就绪后，可以通过下面的命令创建IoT Hub 设备连接字符串：
```
iothub-explorer login "[IoT Hub 服务连接字符串]"

iothub-explorer create <设备ID> --connection-string
```
![图片](/images/Internet-of-Things/03.png)

上图中高亮的connectionString 的值需要复制到样例项目中，作为connectionString 字符串指针的值。 重新构建之后，样例程序即可上送消息到IoT Hub 服务中。

## 获取和使用Node.js 版本的IoT 设备客户端模拟程序

   IoT Hub 提供了各种语言版本的设备客户端模拟程序，用来模拟一个设备向IoT Hub 服务发送数据。下面，将通过Git 客户端获取Node.js 版本的IoT Device SDK，然后通过Node.js 版本的客户端模拟程序向服务端发送数据。

   请通过以下命令将Node.js 版本的Azure IoT SDK 复制到本地：

git clone https://github.com/Azure/azure-iot-sdk-node.git

   然后跳转到azure-iot-sdk-node/device/samples 文件夹，用文本编辑器打开simple\_sample\_device.js 文件。把在安装和使用Iot Hub Explorer 工具一节中创建的设备连接串赋值给connectionString变量，在源代码的第17行，然后保存并退出。如下图所示：

![图片](/images/Internet-of-Things/04.png)

在命令行下使用npm 安装azure-iot-device 和azure-iot-device-mqtt 两个Node.js 组件：
```
npm install azure-iot-device-mqtt
npm install azure-iot-device
```
然后在Node.js 环境中运行simple\_sample\_device.js 文件，命令如下：

node simple\_sample\_device.js

Node.js 设备客户端模拟程序会持续地向IoT Hub 发送测试数据。您可以通过Ctrl + C 停止这个程序。

## 利用IoT Hub Explorer 监控由设备发送到IoT Hub 的消息

在确保Node.js 设备客户端模拟程序持续向IoT Hub 发送测试数据的同时，可以利用IoT Hub Explorer 工具监控设备实时发来的数据。

   您需要打开另一个命令行窗口，然后输入以下命令：
```
iothub-explorer monitor-events <设备ID，比如Device-1> --login "[IoT Hub 服务连接字符串]"
```
   然后您会收到类似下面，由设备发送来的数据：
```
Monitoring events from device Device-1...

==== From: Device-1 ====

{

  "deviceId": "myFirstDevice",

  "windSpeed": 10.223160492583531,

  "temperature": 27.026194859899142,

  "humidity": 79.49728640991773

}

---- properties ----

{

  "temperatureAlert": "false"

}

====================
```
   您可以通过Ctrl + C 停止这个程序。

   同时，您可以通过portal.azure.cn 网站上，IoT Hub 服务的首页，了解服务端收到的消息数量，如下图所示：

![图片](/images/Internet-of-Things/05.png)