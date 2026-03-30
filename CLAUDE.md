# Myconf - Dotfiles 管理项目

跨平台（macOS/Linux/Windows）开发环境配置文件管理，通过符号链接部署。

## 目录结构约定

```
shared/     跨平台共享配置，按工具名分子目录
macos/      macOS 专属配置
linux/      Linux 专属配置
windows/    Windows 专属配置
scripts/    安装脚本（utils.sh, link.sh, packages.sh）
```

每个工具的配置放在 `<platform>/<tool>/` 子目录下。

## 添加新工具配置的流程

1. **放置配置文件**：判断是跨平台还是平台专属，放入对应目录
   - 跨平台：`shared/<tool>/`
   - 平台专属：`macos/<tool>/`、`linux/<tool>/`、`windows/<tool>/`

2. **添加符号链接映射**：编辑 `scripts/link.sh`
   - 跨平台配置：在 `link_shared()` 函数中添加 `safe_link` 调用
   - 平台专属配置：在 `link_macos()`/`link_linux()`/`link_windows()` 中添加
   - 同时在 `unlink_all()` 中添加对应的 `safe_unlink` 调用

3. **添加包依赖**（如需要）：
   - macOS：更新 `macos/Brewfile`
   - Linux：更新 `linux/packages.txt`
   - Windows：更新 `windows/packages.txt`

4. **处理敏感信息**：
   - API key、token 等**绝对不要**提交到 git
   - 使用 `.local` 文件模式（如 `.gitconfig.local`），在主配置中 include 它
   - 确保 `.gitignore` 已包含相关模式

## 关键文件

- `scripts/link.sh` — 所有符号链接映射，添加新配置必改此文件
- `scripts/packages.sh` — 包安装逻辑
- `scripts/utils.sh` — `detect_os`、`safe_link`、`safe_unlink`、日志函数
- `install.sh` — macOS/Linux 安装入口，支持 `install`/`uninstall`/`link` 三种模式
- `install.ps1` — Windows 安装入口，同样支持三种模式

## 安全规则

- 不提交 API key、token、密码、私钥
- 敏感配置用 `.local` 文件隔离，`.gitignore` 已忽略 `*.local`
- SSH 只管理 `~/.ssh/config`，不管理密钥文件

## 安装命令

```bash
# macOS/Linux - 完整安装
./install.sh

# 仅链接配置（不安装包）
./install.sh link

# 卸载（移除所有符号链接）
./install.sh uninstall
```
