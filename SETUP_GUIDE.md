# Setup Guide

## Environment Setup Instructions

### Prerequisites
- Python 3.8 or higher
- pip package manager
- Virtual environment tool (venv)
- Node.js 14+ (optional, for frontend development)

### Step 1: Create Virtual Environment
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### Step 2: Install Python Dependencies
```bash
pip install -r requirements.txt
```

### Step 3: Download Datasets and Models
```bash
bash download_datasets.sh
```

### Step 4: Configure Environment Variables
Create a `.env` file in the root directory:
```
FLASK_ENV=development
DATABASE_URL=sqlite:///app.db
MODEL_PATH=Assets/models/
DEBUG=True
```

### Step 5: Start the Application

#### Backend
```bash
python -m flask run
# or
python verify_document.py
```

#### Frontend
Open `Frontend/index.html` in your web browser or serve with a local server:
```bash
python -m http.server 8000
```

### Step 6: Run Tests
```bash
python -m pytest tests/
```

## Troubleshooting

### Issue: Module not found
**Solution:** Ensure virtual environment is activated and dependencies are installed
```bash
pip install -r requirements.txt
```

### Issue: Port already in use
**Solution:** Change the port in configuration or kill the process using the port
```bash
lsof -ti:5000 | xargs kill -9  # On macOS/Linux
```

### Issue: Model files not found
**Solution:** Run the dataset download script
```bash
bash download_datasets.sh
```

## Development Workflow
1. Create a new branch for features
2. Make changes and test locally
3. Commit changes with descriptive messages
4. Submit pull request for review
5. Deploy after approval
