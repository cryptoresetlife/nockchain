#!/bin/bash

set -e  # 出错就停止脚本

echo "🔄 更新 macOS 安装器（使用 brew，不是 apt）..."
if ! command -v brew &>/dev/null; then
  echo "📦 正在安装 Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew 已安装"
fi

echo "🔧 安装必要工具：curl 和 gcc..."
brew install curl gcc

echo "🦀 安装 Rust..."
if ! command -v rustc &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
else
  echo "✅ Rust 已安装"
fi

echo "🔁 更新环境变量..."
if [ -f "$HOME/.profile" ]; then
  source "$HOME/.profile"
fi
if [ -f "$HOME/.zprofile" ]; then
  source "$HOME/.zprofile"
fi
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

echo "🔽 克隆 nockchain 仓库..."
git clone https://github.com/zorp-corp/nockchain.git || {
  echo "❌ 无法克隆仓库，可能不存在或私有。请检查链接。"
  exit 1
}

cd nockchain

echo "⚙️ 编译 choo..."
make install-choo

echo "⚙️ 编译 Hoon 代码..."
make build-hoon-all

echo "⚙️ 编译 Nockchain..."
make build

echo "🧪 运行测试套件..."
make test

echo "✅ 准备完毕！等你到 5.19 再运行节点："
echo "👉 make run-nockchain-follower"

