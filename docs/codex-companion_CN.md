# Codex Companion：Mac 桥接与 Mosaico 显示

[English](codex-companion.md) | [文档索引](README_CN.md)

`projects/codex_companion` 是 Codex 状态伴侣的私有应用仓库，包含 Mac 只读桥接
和 Mosaico 固定 480×480 方屏的原生 GSP 应用：总览、任务详情、额度与用户的
Peace 动画。原生模拟器和设备共用 C 控制器与场景。

```sh
git submodule update --init projects/codex_companion
projects/codex_companion/bridge serve
```

打开程序打印的本机回环 URL。需要 Python 3.10+ 和已安装、登录的 Codex 桌面应用，
无需额外 Python 依赖。`bridge snapshot` 输出一次 JSON 快照。

额度来自官方 Codex CLI App Server；当前桌面任务和未读状态来自本机状态文件
的只读、按版本验证的适配。这不是稳定的公开桌面查询 API。应用说明中列出
已验证版本、覆盖边界，以及未知、过期和严格只读的语义。

具体用法、接口和进度见应用的 [README](../projects/codex_companion/README.md)、
[协议](../projects/codex_companion/docs/protocol.md) 和
[验收记录](../projects/codex_companion/docs/acceptance.md)。配对、构建与安装见
[设备说明](../projects/codex_companion/docs/device.md)。设备使用单独配对的 TLS 端点，
诊断页保持回环访问，Mac 桥接需持续运行。
快照、原始日志与配对凭据保留本机；应用设计与验收记录归其私有仓库维护。
