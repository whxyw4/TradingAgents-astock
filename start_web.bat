@echo off
rem ==============================================
rem  TradingAgents-Astock Web UI launcher (Windows)
rem  Double-click to start. Stop: close the window
rem  or press Ctrl+C in this window.
rem ==============================================

cd /d "%~dp0"

rem Check virtual environment exists
if not exist "venv\Scripts\activate.bat" (
    echo ==============================================
    echo [ERROR] venv not found!
    echo Run these once to set up:
    echo.
    echo    python -m venv venv
    echo    venv\Scripts\activate
    echo    pip install -e .
    echo ==============================================
    pause
    exit /b 1
)

rem Check .env exists
if not exist ".env" (
    echo ==============================================
    echo [WARNING] .env not found!
    echo Run: copy .env.example .env
    echo Then edit .env and fill in DEEPSEEK_API_KEY
    echo ==============================================
    pause
    exit /b 1
)

rem Activate virtual environment
call venv\Scripts\activate.bat

echo.
echo Starting TradingAgents-Astock Web UI...
echo Open browser: http://localhost:8501
echo Stop: press Ctrl+C or close this window.
echo.

rem Start Web UI
python -m streamlit run web/app.py

echo.
echo Service stopped.
pause
