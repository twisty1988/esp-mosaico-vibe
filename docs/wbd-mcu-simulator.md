# 下位机模拟器 / MCU Simulator

维护应用位于 `projects/wbd_mcu_simulator`，源码、协议资料、设计和验收证据由
[私有应用仓库](https://github.com/twisty1988/wbd_mcu_simulator)维护。
工作区仅固定其提交；克隆需要相应私有仓库权限。

```sh
git submodule update --init submodule/esp-mosaico-utils submodule/esp-mosaico-bsp projects/wbd_mcu_simulator
python3 mosaico.py project sim --project projects/wbd_mcu_simulator --interactive
```

应用提供 480×480 原生 GSP 页面与共享 C TCP 协议核心。使用步骤和网络接入条件见
[应用说明](../projects/wbd_mcu_simulator/README.md)。开发交付包含原生预览、协议测试
与 ESP32-S31 构建；设备安装和现场网络验收单独按设备工作流执行。

The private application owns its source, protocol references, assets and validation
records. The workspace pins its exact commit. Preview runs the same portable C UI
and protocol core as the device. Device installation remains a separate operation.

## 本机上位机客户端

应用同时提供复用 Android 原控制库的可视化联调客户端：

```sh
python3 projects/wbd_mcu_simulator/tools/local_client/launch.py
```

浏览器打开命令输出的本机地址，连接原生模拟器或 Mosaico 的局域网 IP。
依赖、指令范围与使用方法见[客户端说明](../projects/wbd_mcu_simulator/tools/local_client/README.md)。
