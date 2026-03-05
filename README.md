# Irembo Document Verification AI System (AIPowered)

##  Project Overview
**AIPowered** is a sophisticated, end-to-end verification platform designed to modernize the authentication of Rwandan state documents. By merging a **PHP-based document management system** with a **Deep Learning (EfficientNetB0) engine**, it provides real-time detection of digital and physical forgeries in National IDs, Birth Certificates, and Marriage Certificates.

---

##  Detailed Project Architecture

The system is built on a **Modular Hybrid Architecture** that separates citizen interaction, administrative review, and AI inference logic.

### 1. Unified Workspace Tree
```text
/
  aipowered/                 # MASTER PHP APPLICATION (XAMPP Core)
    index.php                 # System Entry & Landing
    login.php / signup.php    # Auth Gateways
    userdashboard.php         # Citizen Status Hub
    application*.php          # Dedicated Submission Forms (NIDA, Passport, etc.)
   
     adminsection/          # OFFICER WORKBENCH
       dashboard.php         # Verification Queue & Stats
       *info.php             # Detailed Document Review Screens
       passports/            # Upload Storage: Passports
       nationalid/           # Upload Storage: National IDs
       goodconduct/          # Upload Storage: Good Conduct
   
     backendcodes/           # SYSTEM LOGIC
       connection.php        # DB Handshake
       sendapplication*.php  # Form Handling & API Routing
   
     database/              # SCHEMA STORAGE
        iremboaipowered.sql   # MySQL System Database

  ML Core & Research         # AI ENGINE (Python 3.10+)
    Document_Verification_ML_Model version 2.ipynb  # Neural Network Pipeline
    verify_document.py        # Independent CLI Inference Tool

  Datasets                   # DATA SOURCES
    sample_documents/         # Validated Valid/Tampered Samples
    synthetic_documents/      # 6,000+ AI-Generated Training Assets

  Output & API Bridge         # AI SERVICE LAYER
    output/app.py             # FastAPI Server (AI <-> PHP Interface)
    output/models/            # Serialized NN Weights (.keras / .h5)
    output/plots/             # Performance Analytics (ROC, Accuracy)

  Design Resources           # UI/UX BLUEPRINTS
     figma/                    # Design Modules for all 9 core screens
```

### 2. Functional Workflow
- **Citizen Tier:** Users submit documents via specialized PHP forms. These are stored locally and the metadata is sent to the MySQL database.
- **AI Service Tier:** The PHP backend makes an asynchronous call to the **FastAPI bridge** (`output/app.py`). The AI analyzes the document pixels for forensic inconsistencies.
- **Officer Tier:** Verification results (Confidence Scores) are flagged in the **Admin Workbench**, allowing officers to prioritize "High Risk" (Tampered) documents for manual audit.

---

##  Product Demo (5-Minute Video)
**[ Watch the AIPowered Core Demo](https://drive.google.com/file/d/1Eq6ialKbqsFojsWMcKY46L46i2K2deEn/view?usp=sharing)**

*This video highlights:*
- **Real-time AI Feedback:** Watching the system reject a tampered National ID.
- **Verification Queue:** How AI scores help officers manage 100+ documents in minutes.
- **System Impact:** Reducing manual review labor by 70%.

---

##  Step-by-Step Installation

### Phase 1: Web Server (XAMPP)
1. Move the `/aipowered/` folder to `C:\xampp\htdocs\`.
2. Launch XAMPP Control Panel and start **Apache** and **MySQL**.
3. Access `http://localhost/phpmyadmin`, create a database `aipowered`, and import `/aipowered/database/iremboaipowered.sql`.

### Phase 2: AI Brain (Python)
1. **Prepare Env:**
   ```bash
   python -m venv venv
   source venv/bin/activate  # Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```
2. **Launch AI Bridge:**
   ```bash
   python output/app.py
   ```
   *Bridge running at `http://localhost:8001`.*

---

##  Impact & Deployment
- **Deployment:** [View Live Deployment Guide](DEPLOYMENT_PLAN.md)
- **Scale:** Engineered for deployment on Contabo VPS with Docker.
- **Performance:** 96.3% Accuracy on the Rwandan Document Forensic Dataset.

---
**Repository:** [ml-document-verifier](https://github.com/jkeza1/ml-document-verifier)

