#!/bin/bash

# iRembo Document Verification - Backend Startup Script (macOS/Linux)

echo ""
echo "======================================"
echo "iRembo Backend API - Startup Script"
echo "======================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed"
    echo "Please install Python 3.8+ from https://www.python.org/"
    exit 1
fi

python3 --version

echo "[1/4] Python version check... OK"

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "[2/4] Creating virtual environment..."
    python3 -m venv venv
    echo "Virtual environment created"
else
    echo "[2/4] Virtual environment already exists"
fi

# Activate virtual environment
echo "[3/4] Activating virtual environment..."
source venv/bin/activate

# Install/upgrade dependencies
echo "[4/4] Installing dependencies..."
pip install -q -r requirements.txt

# Start the server
echo ""
echo "======================================"
echo "Starting FastAPI Server..."
echo "======================================"
echo ""
echo "API Documentation available at:"
echo "  - Swagger UI: http://localhost:5000/docs"
echo "  - ReDoc: http://localhost:5000/redoc"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

python main.py
