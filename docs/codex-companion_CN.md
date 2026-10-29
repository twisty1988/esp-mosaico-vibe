# Codex Companion：Mac 只读桥接

[English](codex-companion.md) | [文档索引](README_CN.md)

`projects/codex_companion` 是 Codex 状态伴侣的私有应用仓库。当前阶段只做
Mac 桥接；设备 UI、固件工程创建和真机安装在数据通路验收后继续。

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
[验收记录](../projects/codex_companion/docs/acceptance.md)。快照、日志和原始验收证据
保留在本机，不进入提交。
