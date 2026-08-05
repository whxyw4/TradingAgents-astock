@echo off
chcp 65001 >nul
rem ==============================================
rem  TradingAgents-Astock Web UI 一键启动（Windows）
rem  用法：双击本文件，或在 cmd 中运行 start_web.bat
rem  退出：按 Ctrl+C 停止 Streamlit，或直接关闭窗口
rem ==============================================

cd /d "%~dp0"

rem 检查虚拟环境是否存在
if not exist "venv\Scripts\activate.bat" (
    echo ==============================================
    echo [错误] 未找到虚拟环境 venv\
    echo        请先执行以下命令完成首次安装：
    echo.
    echo        python -m venv venv
    echo        venv\Scripts\activate
    echo        pip install -e .
    echo ==============================================
    pause
    exit /b 1
)

rem 检查 .env 是否存在
if not exist ".env" (
    echo ==============================================
    echo [警告] 未找到 .env 配置文件！
    echo        请执行：copy .env.example .env
    echo        然后编辑 .env 填入你的 DEEPSEEK_API_KEY
    echo ==============================================
    pause
    exit /b 1
)

rem 激活虚拟环境
call venv\Scripts\activate.bat

echo.
echo 启动 TradingAgents-Astock Web UI...
echo 浏览器访问: http://localhost:8501
echo 按 Ctrl+C 停止服务，或直接关闭此窗口
echo.

rem 启动 Web UI
python -m streamlit run web/app.py

echo.
echo 服务已停止。
pause
