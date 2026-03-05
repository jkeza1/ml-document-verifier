@echo off
REM iRembo Document Verification - Backend Startup Script (Windows)

echo.
echo ======================================
echo iRembo Backend API - Startup Script
echo ======================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed or not in PATH
    echo Please install Python 3.8+ from https://www.python.org/
    pause
    exit /b 1
)

echo [1/4] Python version check... OK

REM Check if virtual environment exists
if not exist "venv" (
    echo [2/4] Creating virtual environment...
    python -m venv venv
    echo Virtual environment created
) else (
    echo [2/4] Virtual environment already exists
)

REM Activate virtual environment
echo [3/4] Activating virtual environment...
call venv\Scripts\activate.bat

REM Install/upgrade dependencies
echo [4/4] Installing dependencies...
pip install -q -r requirements.txt

REM Start the server
echo.
echo ======================================
echo Starting FastAPI Server...
echo ======================================
echo.
echo API Documentation available at:
echo  - Swagger UI: http://localhost:5000/docs
echo  - ReDoc: http://localhost:5000/redoc
echo.
echo Press Ctrl+C to stop the server
echo.

python main.py

pause
