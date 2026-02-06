# iRembo Document Verification - Backend API
# This directory contains all backend API endpoints and business logic

## Structure
- **routes.py** - API endpoint definitions
- **models.py** - Database models and data structures
- **services.py** - Business logic and service layer
- **utils.py** - Utility functions and helpers
- **config.py** - Configuration settings

## Endpoints

### Document Upload
- POST `/api/upload` - Upload document for verification

### AI Processing
- POST `/api/ai-process` - Process documents with AI model
- GET `/api/ai-predictions/:id` - Get AI prediction results

### Applications
- GET `/api/applications` - List all applications
- GET `/api/applications/:id` - Get specific application
- POST `/api/applications` - Create new application

### Appeals
- GET `/api/appeals` - List appeals
- POST `/api/appeals` - Submit new appeal
- PUT `/api/appeals/:id` - Update appeal status

### Verification
- POST `/api/verify` - Officer verification decision
- GET `/api/verification/:id` - Get verification status

### AI Review
- POST `/api/ai-review` - Submit officer review of AI results
- GET `/api/ai-review/:id` - Get review details
