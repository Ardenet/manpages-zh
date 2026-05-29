# manpages-zh.nix 🇨🇳

这是一个为 [man-pages-zh/manpages-zh](https://github.com/man-pages-zh/manpages-zh)（中文 man 手册页计划）编写的 **Nix packages 与 Flake 封装**。

通过此项目，你可以在 NixOS 或任何安装了 Nix 的 Linux 系统中快速享受全中文的终端 `man` 手册体验。

## ✨ 特性

- **现代构建**：完全基于上游最新的 CMake 构建系统与 OpenCC 简繁转换引擎。
- **参数化定制**：支持通过 Nix 的 `.override` 语法自由开关简体中文、繁体中文以及译者信息（Colophon）的编译。
- **开箱即用**：提供完整的 Flake 导出，完美兼容 NixOS 系统层级与 Home Manager 层级。

---

## 🚀 快速开始

### 1. 独立构建与测试

如果你克隆了本仓库，可以直接在本地进行构建或进入临时开发环境：

```bash
# 编译并生成 result 链接
nix build .#default

# 验证编译产物
./result/share/man/zh_CN/man1/tar.1.gz

# 进入带有该包内容的临时 Shell 
nix shell .#default
```

## 🛠️ 安装与配置

### 方案 A：在 NixOS 系统级别引入 (Flake)

首先，在你的系统 flake.nix 中将本仓库作为 inputs 引入：

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # 引入本仓库
    manpages-zh.url = "github:ardenet/manpages-zh-nix";
  };

  outputs = { self, nixpkgs, manpages-zh, ... }@inputs: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # 必须传递 inputs
      modules = [ ./configuration.nix ];
    };
  };
}
```

接着，在你的 configuration.nix 中启用它，并生成手册索引缓存：

```nix
# configuration.nix
{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = [
    # 安装默认包（包含简繁体与译者信息）
    inputs.manpages-zh.packages.${pkgs.system}.default
    
    # 或者：如果你只想用特定的变体（例如纯简体、无译者信息）
    # inputs.manpages-zh.packages.${pkgs.system}.man-pages-zh-cn-minimal
  ];

  # 极其重要：生成 man 缓存以便正确索引多语言手册
  documentation.man.generateCaches = true;

  # 【可选】为中文 man 绑定一个快捷别名
  environment.shellAliases = {
    cman = "man -L zh_CN";
  };
}
```

### 方案 B：在 Home Manager 中引入

如果你倾向于在用户级别管理环境，可以在 home.nix 中这样配置：

```nix
# home.nix
{ config, pkgs, inputs, ... }:

{
  home.packages = [
    inputs.manpages-zh.packages.${pkgs.system}.default
  ];

  # 允许 Home Manager 索引用户 Profile 下的手册页
  manual.manpages.enable = true;

  # 【可选】配置 Shell 别名
  programs.zsh.shellAliases = {
    cman = "man -L zh_CN";
  };
}
```

## 🎛️ 高级定制 (Override)

本打包提供了三个可选布尔参数：

- `withCn` (默认: `true`): 是否编译简体中文手册。
- `withTw` (默认: `false`): 是否编译繁体中文手册。
- `withColophon` (默认: `true`): 是否在手册末尾追加翻译人员信息。

如果你想在自己的系统配置中即时重写这些编译选项，不需要修改本仓库源码，直接在你的系统配置中使用 `.override` 即可：

## 📝 许可证

本项目自身的 Nix 代码基于 **MIT** 许可证开源。

所编译的 `manpages-zh` 文本内容及成果遵循上游的 **GNU Free Documentation License v1.2 or later (fdl12Plus)** 协议。
