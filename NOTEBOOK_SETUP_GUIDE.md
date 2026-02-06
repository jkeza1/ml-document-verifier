# Notebook Setup Guide

## Dataset Preparation

### Overview
This guide covers how to set up and prepare datasets for the ML model training and validation.

### Step 1: Download Datasets
Use the provided script to download datasets:
```bash
bash download_datasets.sh
```

This will:
- Download training datasets
- Extract to appropriate directories
- Verify dataset integrity

### Step 2: Dataset Structure
```
data/
├── training/
│   ├── authentic/
│   ├── forged/
│   └── metadata.csv
├── validation/
│   ├── authentic/
│   ├── forged/
│   └── metadata.csv
└── test/
    ├── authentic/
    ├── forged/
    └── metadata.csv
```

### Step 3: Prepare Data in Notebook
1. Open `ML_Model_Notebook.ipynb`
2. Run data preparation cells
3. Verify data loading and preprocessing

### Step 4: Data Validation
- Check for missing values
- Verify image sizes and formats
- Ensure class balance
- Review sample data

### Step 5: Feature Engineering
The notebook includes cells for:
- Image preprocessing
- Feature extraction
- Data augmentation
- Train/validation split

## Dataset Details

### Training Set
- **Size:** ~5000 images per class
- **Format:** JPEG, PNG, PDF
- **Resolution:** 300x300 pixels minimum

### Validation Set
- **Size:** ~1000 images per class
- **Purpose:** Model validation and hyperparameter tuning

### Test Set
- **Size:** ~500 images per class
- **Purpose:** Final model evaluation

## Data Privacy
- All sensitive information is redacted
- No personal data in feature sets
- GDPR compliant data handling

## References
- Dataset documentation in `data/README.md`
- Feature engineering techniques in notebook
- Model architecture details
