#!/bin/bash
# TradingAgents-Astock Web UI 一键启动脚本（Git Bash）
# 用法：双击 或 ./start_web.sh
# 退出：Ctrl+C 停止 Streamlit，或直接关闭终端窗口

# 定位到项目根目录（无论从哪里调用）
cd "$(dirname "$0")" || exit 1

# 检查虚拟环境是否存在
if [ ! -f "venv/Scripts/activate" ]; then
    echo "=============================================="
    echo "❌ 未找到虚拟环境 venv/"
    echo "   请先执行以下命令完成首次安装："
    echo ""
    echo "   python -m venv venv"
    echo "   source venv/Scripts/activate"
    echo "   pip install -e ."
    echo "=============================================="
    read -r -p "按回车键退出..."
    exit 1
fi

# 检查 .env 是否存在
if [ ! -f ".env" ]; then
    echo "=============================================="
    echo "⚠️  未找到 .env 配置文件！"
    echo "   请执行：cp .env.example .env"
    echo "   然后编辑 .env 填入你的 DEEPSEEK_API_KEY"
    echo "=============================================="
    read -r -p "按回车键退出..."
    exit 1
fi

# 检查 .env 中是否已配置 SSL_VERIFY
if ! grep -q "^SSL_VERIFY" .env 2>/dev/null; then
    echo "=============================================="
    echo "⚠️  .env 未配置 SSL_VERIFY"
    echo "   若遇到 SSL 证书错误（Watt Toolkit 拦截），"
    echo "   请在 .env 末尾添加：SSL_VERIFY=false"
    echo "=============================================="
fi

# 激活虚拟环境
source venv/Scripts/activate

echo ""
echo "🚀 启动 TradingAgents-Astock Web UI..."
echo "   浏览器访问: http://localhost:8501"
echo "   按 Ctrl+C 停止服务，或直接关闭此窗口"
echo ""

# 启动 Web UI（python -m 方式，避免 PATH 里找不到 streamlit）
python -m streamlit run web/app.py

echo ""
echo "服务已停止。"
