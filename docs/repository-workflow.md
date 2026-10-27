# 仓库管理与上游更新

本工作区以各子仓库的具体提交记录可重现的应用与依赖组合。
`origin` 用于个人仓库的提交推送，`upstream` 用于读取官方变更。

| 本地位置 | origin | 官方 upstream | 日常分支 |
| --- | --- | --- | --- |
| 工作区 | `twisty1988/esp-mosaico-vibe` | `esp-mosaico/esp-mosaico-vibe` | `main` |
| `projects/weather_window` | `twisty1988/weather_window`（私有） | 原创应用，无官方上游 | `main` |
| `submodule/esp-mosaico-bsp` | `twisty1988/esp-mosaico-bsp` | `esp-mosaico/esp-mosaico-bsp` | `codex/weather-window-fixes` |
| `submodule/raylib-lite-engine` | `twisty1988/raylib-lite-engine` | `espressif2022/raylib-lite-engine` | `codex/weather-window-fixes` |
| `submodule/esp-mosaico-utils` | `esp-mosaico/esp-mosaico-utils` | 直接使用官方仓库 | 工作区固定提交 |

应用自己的素材、测试、设计资料和历史设备记录位于应用私有仓库内。
工作区保存公共说明、配置、子模块 URL 和提交号。未纳入共享管理的
`hello_mosaico` 验证工程和本机 `DEVELOPMENT_CN.md` 保留在本地。
`build/`、`managed_components/`、运行日志、Gateway 状态及凭据均不提交。

## 从其他机器检出

```sh
git clone https://github.com/twisty1988/esp-mosaico-vibe.git
cd esp-mosaico-vibe
git submodule update --init submodule/esp-mosaico-utils submodule/esp-mosaico-bsp submodule/raylib-lite-engine projects/weather_window
```

读取 Weather Window 需要有该私有仓库权限的 GitHub 身份。公共工作区 CI
仅初始化自身测试所需的公开依赖，不读取私有应用。
Git 的附加 remote 是本机配置，首次克隆后恢复官方入口：

```sh
git remote add upstream https://github.com/esp-mosaico/esp-mosaico-vibe.git
git -C submodule/esp-mosaico-bsp remote add upstream https://github.com/esp-mosaico/esp-mosaico-bsp.git
git -C submodule/raylib-lite-engine remote add upstream https://github.com/espressif2022/raylib-lite-engine.git
```

普通子模块检出使用 detached HEAD，这是按提交复现的正常状态。开始修改前
切换到相应开发分支；新任务使用 `codex/` 前缀分支。

## 提交和推送

先在有改动的应用或依赖仓库中提交并推送，再在工作区提交新的子模块引用。
例如，提交并推送 Weather Window 后，在根目录执行：

```sh
git add projects/weather_window
git commit -m '更新天气窗应用版本'
git push --recurse-submodules=check origin main
```

`--recurse-submodules=check` 用于发现未推送的子模块提交。
工作区引用的提交还必须能从 `.gitmodules` 配置的目标仓库获取。
修改过的 BSP/Engine 提交就是修复来源；应用的 `.patch` 文件保留为迁入过程的辅助记录。

## 接收官方更新

1. 将现有修改提交并推送，保留当前可用组合。
2. 从 `upstream` fetch，选择准备升级的提交，检查其 SDK 与 API 要求。
3. 从包含本地修复的分支另建升级分支，合并选定的官方提交。
4. 在相应子仓库内解决冲突；核对官方是否已包含等价修复，避免重复实现。
5. 完成受影响应用的构建、模拟器和必要的硬件验证。
6. 先推送子仓库的新提交，再更新并推送工作区引用。

已被工作区引用并共享的修复分支优先用 merge 保留历史。
普通 `git submodule update --init` 恢复工作区固定版本；
`--remote` 会选择子模块远程分支版本，仅在明确升级时使用。
ESP-IDF 仍固定在 `7b9cc1ac79f865983f59bb8ff3ff43eb74ff1dbe`，不随子模块更新自动升级。
