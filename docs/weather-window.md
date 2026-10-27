# Weather Window：应用入口

Weather Window 在独立的私有仓库
[twisty1988/weather_window](https://github.com/twisty1988/weather_window) 中维护，
作为本工作区的 `projects/weather_window` 子模块固定到已验证的提交。
源码、素材、字体授权、测试、设计过程及历史交付记录均随应用仓库管理。

初始化应用和它需要的依赖（GitHub 账号须有应用仓库读取权限）：

```sh
git submodule update --init submodule/esp-mosaico-utils submodule/esp-mosaico-bsp submodule/raylib-lite-engine projects/weather_window
```

本地入口：

- [应用说明](../projects/weather_window/README.md)
- [开发、迁入来源及验证记录](../projects/weather_window/docs/weather-window.md)
- [设计素材与历史预览](../projects/weather_window/docs/design/weather-window/README.md)
- [依赖修复说明](../projects/weather_window/patches/README.md)

固定 ESP-IDF 提交和目标仍以 [AGENTS.md](../AGENTS.md) 为准。
在工作区根目录激活环境，再运行 Host 预览：

```sh
source ./env.sh
python -m venv .tools/weather-window-venv
.tools/weather-window-venv/bin/python -m pip install Pillow numpy fonttools
.tools/weather-window-venv/bin/python mosaico.py game sim --project projects/weather_window
```

首次构建须解析应用声明的 cJSON 组件，并按[游戏开发指南](game-development_CN.md#生成-board-manager-配置)
生成匹配依赖锁版本的 Board Manager 配置。具体命令及验证范围见应用开发记录。
工作区与官方上游的关系见[仓库管理](repository-workflow.md)。
