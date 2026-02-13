# iRembo Document Verification - Backend API

FastAPI-based backend for the iRembo Document Verification System. This API handles all business logic for document verification, appeals management, and officer verification workflows.

## Setup & Installation

### Prerequisites
- Python 3.8+
- pip (Python package manager)
- Virtual environment (recommended)

### Installation Steps

1. **Create virtual environment** (Windows):
```bash
python -m venv venv
venv\Scripts\activate
```

2. **Create virtual environment** (macOS/Linux):
```bash
python -m venv venv
source venv/bin/activate
```

3. **Install dependencies**:
```bash
pip install -r requirements.txt
```

4. **Configure environment**:
- Copy `.env.example` to `.env` (if exists) or use the existing `.env`
- Update settings in `.env` as needed for your environment

### Running the Server

**Start the development server**:
```bash
python main.py
```

Or using uvicorn directly:
```bash
uvicorn main:app --host 0.0.0.0 --port 5000 --reload
```

**Production server**:
```bash
uvicorn main:app --host 0.0.0.0 --port 5000 --workers 4
```

The API will be available at `http://localhost:5000`

## API Documentation

Once running, access interactive API documentation:
- **Swagger UI**: http://localhost:5000/docs
- **ReDoc**: http://localhost:5000/redoc

## Project Structure

```
api/
├── main.py              # FastAPI app entry point
├── routes.py            # API endpoint definitions
├── models.py            # Pydantic data models
├── config.py            # Configuration settings
├── requirements.txt     # Python dependencies
├── .env                 # Environment variables
└── README.md           # This file
```

## Endpoints

### Appeals Management
- `GET /api/appeals` - List all appeals (with pagination, filtering)
- `GET /api/appeals/{appeal_id}` - Get specific appeal
- `POST /api/appeals` - Submit new appeal
- `PUT /api/appeals/{appeal_id}` - Update appeal status
- `DELETE /api/appeals/{appeal_id}` - Delete appeal

### Document Verification
- `POST /api/verify` - Officer submits verification decision
- `GET /api/verification/{verification_id}` - Get verification details

### AI Review
- `POST /api/ai-review` - Submit officer review of AI results
- `GET /api/ai-review/{review_id}` - Get review details

### Applications
- `GET /api/applications` - List all applications (paginated)
- `GET /api/applications/{application_id}` - Get application details

### Document Upload & Processing
- `POST /api/upload` - Upload document for verification
- `POST /api/ai-process` - Process documents with AI model
- `GET /api/ai-predictions/{prediction_id}` - Get AI prediction results

### Statistics
- `GET /api/statistics/appeals` - Get appeals statistics
- `GET /api/statistics/verifications` - Get verification statistics

## Request/Response Format

### Successful Response
```json
{
  "status": "success",
  "message": "Operation completed successfully",
  "data": {},
  "timestamp": "2026-02-09T10:00:00"
}
```

### Error Response
```json
{
  "status": "error",
  "error_code": "VALIDATION_ERROR",
  "message": "Invalid input",
  "timestamp": "2026-02-09T10:00:00"
}
```

## Features

✅ RESTful API endpoints
✅ CORS support (frontend communication)
✅ Pydantic data validation
✅ Pagination support
✅ Error handling
✅ In-memory database (for demo)
✅ Auto-generated API documentation
✅ Configuration management

## Future Enhancements

- [ ] PostgreSQL/MongoDB database integration
- [ ] User authentication & authorization
- [ ] File upload handling with storage
- [ ] AI model integration
- [ ] Database transactions
- [ ] Logging & monitoring
- [ ] Rate limiting
- [ ] Caching strategy
- [ ] API versioning

## Environment Variables

See `.env` file for all configurable settings:
- `HOST` - Server host
- `PORT` - Server port
- `DEBUG` - Debug mode
- `SECRET_KEY` - JWT secret key
- `DATABASE_URL` - Database connection string
- `CORS_ORIGINS` - Allowed CORS origins

## Troubleshooting

**Port already in use**:
```bash
netstat -ano | findstr :5000  # Windows
# Kill the process and try again
```

**Module not found**:
```bash
pip install -r requirements.txt
```

**CORS errors**:
- Update `CORS_ORIGINS` in `.env` with your frontend URL

## Support

For issues or questions, check the main README in the project root.
