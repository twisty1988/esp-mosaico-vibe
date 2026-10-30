# 仓库管理与上游更新

本工作区以各子仓库的具体提交记录可重现的应用与依赖组合。
`origin` 用于个人仓库的提交推送，`upstream` 用于读取官方变更。

| 本地位置 | origin | 官方 upstream | 日常分支 |
| --- | --- | --- | --- |
| 工作区 | `twisty1988/esp-mosaico-vibe` | `esp-mosaico/esp-mosaico-vibe` | `main` |
| `projects/wbd_mcu_simulator` | `twisty1988/wbd_mcu_simulator`（私有） | 原创应用，无官方上游 | `main` |
| `projects/weather_window` | `twisty1988/weather_window`（私有） | 原创应用，无官方上游 | `main` |
| `projects/codex_companion` | `twisty1988/mosaico_codex_companion`（私有） | 原创应用，无官方上游 | `main` |
| `projects/esp_mosaico_claw` | `twisty1988/esp_mosaico_claw`（私有） | `esp-mosaico/esp-mosaico-claw` | `main` |
| `projects/esp_mosaico_claw/third-party/esp-claw` | `twisty1988/esp-claw`（私有） | `espressif/esp-claw` | `main` |
| Claw 组件锁中的 BSP | `twisty1988/esp-mosaico-bsp` | `esp-mosaico/esp-mosaico-bsp` | `codex/claw-camera-save` |
| `submodule/esp-mosaico-bsp` | `twisty1988/esp-mosaico-bsp` | `esp-mosaico/esp-mosaico-bsp` | `codex/weather-window-fixes` |
| `submodule/raylib-lite-engine` | `twisty1988/raylib-lite-engine` | `espressif2022/raylib-lite-engine` | `codex/weather-window-fixes` |
| `submodule/esp-mosaico-utils` | `esp-mosaico/esp-mosaico-utils` | 直接使用官方仓库 | 工作区固定提交 |
| 外部固定 ESP-IDF SDK | `twisty1988/esp-idf` | `espressif/esp-idf` | `codex/mosaico-7b9cc1a-fixes` |

应用自己的素材、测试、设计资料和历史设备记录位于应用私有仓库内。
工作区保存公共说明、配置、子模块 URL 和提交号。未纳入共享管理的
`hello_mosaico` 验证工程和本机 `DEVELOPMENT_CN.md` 保留在本地。
`build/`、`managed_components/`、运行日志、Gateway 状态及凭据均不提交。

Claw 的 BSP 组件由应用 manifest 和 `dependencies.lock` 固定，基于该应用原有
官方版本增加相机帧复用接口，使用独立的 `codex/claw-camera-save` 维护分支。
工作区 BSP 子模块由 `codex_companion` 和 `wbd_mcu_simulator` 的本地组件引用使用。
`weather_window` 使用 Raylib Lite Engine 自带的 Board Manager adapter，不编入
该 BSP；天气窗的构建或运行结果不能作为工作区 BSP 升级的验证证据。
接收 BSP 更新时分别核对应用锁定版本、编译数据库中的实际组件路径和有效配置，
不要仅根据工作区子模块 HEAD 推断应用采用了相同版本。

### 固定 ESP-IDF 与补丁来源

ESP-IDF 的构建基线继续固定为 `7b9cc1ac79f865983f59bb8ff3ff43eb74ff1dbe`。
本机 SDK 位于 `/Users/twisty/esp/esp-idf-7b9cc1a`，HEAD 保持该基线，
其 4 个文件的工作树差异已逐字记录到个人 SDK fork 的维护分支：

| 提交 | 范围与来源 |
| --- | --- |
| `864f32439dc049ee029dd886e56f63f8b51d653a` | BTDM 外部接口补齐 `btdm_user_cfg.h`，1 个文件 |
| `cefb3108ee0a611ad30d83071d689faab14ae916` | DVP 帧尾隔离、FIFO 重置与完整帧检查，3 个文件；与 BSP 的 `esp-idf-dvp-frame-capture-stability.patch` 一致 |

完整源码位于 [个人 SDK 维护分支](https://github.com/twisty1988/esp-idf/tree/codex/mosaico-7b9cc1a-fixes)。
本机 `origin` 指向个人 fork，`upstream` 保留官方仓库。维护提交用于保存和审查
固定基线上的补丁；构建 SDK 继续检出固定基线并应用已核验的差异。
因此本机显示上述 4 个修改文件是已应用补丁的预期状态，源码已有对应的远端提交。

新 SDK 副本应先核对基线，再从维护提交导出所需差异，并以 `git apply --check`
核对后应用；已有补丁使用 `git apply --reverse --check` 确认。
BSP 配置会幂等应用 DVP 补丁，按两个提交分别核查可避免混合状态下重复应用。
维护分支若继续增加修复，须先审查并验证后再采用新的补丁提交。

本次归档复用了 DVP 补丁的既有相机真机验收，并使用 Claw 的实际编译参数检查
BTDM、DVP 实现及其头文件，三个 C 翻译单元检查通过；未新增蓝牙功能验收。
从 GitHub 新检出维护分支后，4 个文件与本机内容逐字节一致。
SDK 原始 HEAD 与 4 个文件内容保持不变；没有新增固件部署。

## 从其他机器检出

```sh
git clone https://github.com/twisty1988/esp-mosaico-vibe.git
cd esp-mosaico-vibe
git submodule update --init submodule/esp-mosaico-utils submodule/esp-mosaico-bsp submodule/raylib-lite-engine projects/weather_window
git submodule update --init projects/esp_mosaico_claw projects/wbd_mcu_simulator
git -C projects/esp_mosaico_claw submodule update --init third-party/esp-claw third-party/esp-mosaico-utils
```

读取 MCU Simulator、Weather Window、Claw 及其 ESP-Claw fork 需要有对应私有仓库权限的 GitHub 身份。公共工作区 CI
仅初始化自身测试所需的公开依赖，不读取私有应用。
Git 的附加 remote 是本机配置，首次克隆后恢复官方入口：

```sh
git remote add upstream https://github.com/esp-mosaico/esp-mosaico-vibe.git
git -C submodule/esp-mosaico-bsp remote add upstream https://github.com/esp-mosaico/esp-mosaico-bsp.git
git -C submodule/raylib-lite-engine remote add upstream https://github.com/espressif2022/raylib-lite-engine.git
git -C projects/esp_mosaico_claw remote add upstream https://github.com/esp-mosaico/esp-mosaico-claw.git
git -C projects/esp_mosaico_claw/third-party/esp-claw remote add upstream https://github.com/espressif/esp-claw.git
```

普通子模块检出使用 detached HEAD，这是按提交复现的正常状态。开始修改前
切换到相应开发分支；新任务使用 `codex/` 前缀分支。

## 提交和推送

完成当前授权任务并验证后，默认把相关改动提交并推送到配置好的个人 `origin`。
用户明确要求只在本地修改、不提交、不推送、保留草稿或指定其他交付方式时遵从用户要求。
每个任务使用 `codex/` 分支，提交信息使用中文；仅暂存本任务涉及的内容，保留其他已有改动。
未指定其他分支或 PR 交付方式时，将已验证的改动纳入对应的集成/维护分支。

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
推送后核对远程分支提交和子模块可获取性；首次建仓或更换 URL 后验证全新检出。
交付时报告仓库、分支、提交及剩余状态。本规则不代表部署、设备写入、正式发布、
公开私有应用或向官方 `upstream` 推送的授权。

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
