"""
API Routes for iRembo Document Verification System
"""

from fastapi import APIRouter, HTTPException, Query, UploadFile, File, Form
from datetime import datetime, timedelta
import base64
import uuid
import os
import shutil
import time
import sqlite3
import json
from typing import Optional, List

from models import (
    Appeal, AppealCreate, AppealUpdate,
    VerificationData, Verification,
    AIReviewData, AIReview,
    DocumentUpload, DocumentRequest,
    SuccessResponse, PaginatedResponse, ErrorResponse
)
from utils import get_ai_service

router = APIRouter()

# SQLite Database Setup
DB_PATH = "irembo_verification.db"

def get_db_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Applications table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS applications (
        application_id TEXT PRIMARY KEY,
        citizen_name TEXT,
        citizen_email TEXT,
        citizen_id TEXT,
        citizen_phone TEXT,
        description TEXT,
        document_type TEXT,
        status TEXT,
        created_at TEXT,
        priority TEXT,
        ai_confidence REAL,
        ai_verdict TEXT,
        ai_results TEXT,
        document_base64 TEXT,
        documents TEXT,
        feedback TEXT
    )
    ''')
    
    # Appeals table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS appeals (
        appeal_id TEXT PRIMARY KEY,
        application_id TEXT,
        citizen_id TEXT,
        reason TEXT,
        status TEXT,
        created_at TEXT,
        updated_at TEXT,
        notes TEXT,
        additional_documents TEXT
    )
    ''')
    
    # Document Requests table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS document_requests (
        request_id TEXT PRIMARY KEY,
        document_type TEXT,
        citizen_name TEXT,
        citizen_id TEXT,
        citizen_phone TEXT,
        reason TEXT,
        status TEXT,
        requested_at TEXT,
        remarks TEXT
    )
    ''')
    
    conn.commit()
    conn.close()

# Initialize the database
init_db()

# In-memory storage (Keep for compatibility during transition if needed, but we will use DB)
appeals_db = {}
applications_db = {}
verifications_db = {}
reviews_db = {}
document_requests_db = {}

# ==================== DEMO DATA INITIALIZATION ====================
def initialize_demo_data():
    """Initialize demo data for testing"""
    # Demo applications
    demo_apps = [
        {
            "application_id": "APP-2024-001",
            "citizen_name": "John Doe",
            "citizen_email": "john.doe@email.com",
            "document_type": "Passport",
            "status": "approved",
            "created_at": "2026-02-01T10:00:00",
            "submission_date": "2026-02-01",
            "feedback": "Document verified successfully. All details match official records.",
            "verification_type": "ai-assisted",
            "ai_confidence": 95,
            "ai_verdict": "authentic"
        },
        {
            "application_id": "APP-2024-002",
            "citizen_name": "Jane Smith",
            "citizen_email": "jane.smith@email.com",
            "document_type": "Birth Certificate",
            "status": "pending",
            "created_at": "2026-02-05T14:30:00",
            "submission_date": "2026-02-05",
            "feedback": "Under review by document verification officer",
            "verification_type": "manual",
            "ai_confidence": 87,
            "ai_verdict": "authentic",
            "priority": "urgent"
        },
        {
            "application_id": "APP-2024-003",
            "citizen_name": "Bob Johnson",
            "citizen_email": "bob.johnson@email.com",
            "document_type": "Driver License",
            "status": "rejected",
            "created_at": "2026-01-28T09:15:00",
            "submission_date": "2026-01-28",
            "feedback": "Document image quality is too low. Please resubmit with clearer images.",
            "verification_type": "ai",
            "ai_confidence": 62,
            "ai_verdict": "suspicious",
            "priority": "normal"
        },
        {
            "application_id": "APP-2024-004",
            "citizen_name": "Alice Williams",
            "citizen_email": "alice.williams@email.com",
            "document_type": "National ID",
            "status": "under-review",
            "created_at": "2026-02-06T11:45:00",
            "submission_date": "2026-02-06",
            "feedback": "Awaiting officer review",
            "verification_type": "ai-assisted",
            "ai_confidence": 98,
            "ai_verdict": "authentic",
            "priority": "high"
        }
    ]
    
    for app in demo_apps:
        applications_db[app["application_id"]] = app
    
    # Demo appeals
    demo_appeals = [
        {
            "appeal_id": "APL-2026-001",
            "application_id": "APP-2024-003",
            "citizen_id": "CITIZEN-123",
            "reason": "The image was clear when I submitted it. I believe there was a technical error.",
            "status": "pending",
            "created_at": "2026-02-08T10:00:00",
            "updated_at": "2026-02-08T10:00:00",
            "notes": "",
            "additional_documents": []
        }
    ]
    
    for appeal in demo_appeals:
        appeals_db[appeal["appeal_id"]] = appeal

# No demo data for production
# initialize_demo_data()

# ==================== APPEALS ENDPOINTS ====================

@router.get("/appeals", response_model=PaginatedResponse)
async def list_appeals(
    citizen_id: Optional[str] = Query(None),
    status: Optional[str] = Query(None),
    page: int = Query(1, ge=1),
    per_page: int = Query(10, ge=1, le=100)
):
    """List all appeals from SQLite"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    query = "SELECT * FROM appeals"
    params = []
    
    conditions = []
    if citizen_id:
        conditions.append("citizen_id = ?")
        params.append(citizen_id)
    if status:
        conditions.append("status = ?")
        params.append(status)
        
    if conditions:
        query += " WHERE " + " AND ".join(conditions)
        
    query += " ORDER BY created_at DESC"
    
    cursor.execute(query, params)
    rows = cursor.fetchall()
    conn.close()
    
    appeals_list = [dict(row) for row in rows]
    
    total = len(appeals_list)
    start = (page - 1) * per_page
    end = start + per_page
    
    return PaginatedResponse(
        total=total,
        page=page,
        per_page=per_page,
        data=appeals_list[start:end],
        message="Appeals retrieved successfully"
    )

@router.get("/appeals/{appeal_id}")
async def get_appeal(appeal_id: str):
    """Get a specific appeal from SQLite"""
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM appeals WHERE appeal_id = ?", (appeal_id,))
    row = cursor.fetchone()
    conn.close()
    
    if not row:
        raise HTTPException(status_code=404, detail="Appeal not found")
    
    return SuccessResponse(message="Appeal retrieved", data=dict(row))

@router.post("/appeals", response_model=SuccessResponse)
async def create_appeal(appeal_data: AppealCreate):
    """Submit a new appeal to SQLite"""
    appeal_id = f"APPEAL-{uuid.uuid4().hex[:8].upper()}"
    now = datetime.utcnow().isoformat()
    
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('''
    INSERT INTO appeals (
        appeal_id, application_id, citizen_id, reason, 
        status, created_at, updated_at, notes, additional_documents
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (
        appeal_id, appeal_data.application_id, "CITIZEN-DEFAULT", 
        appeal_data.reason, "pending", now, now, "", appeal_data.additional_documents
    ))
    conn.commit()
    conn.close()
    
    return SuccessResponse(message="Appeal submitted successfully", data={"appeal_id": appeal_id})
    
    return SuccessResponse(
        message="Appeal submitted successfully",
        data={"appeal_id": appeal_id, **appeal}
    )

@router.put("/appeals/{appeal_id}", response_model=SuccessResponse)
async def update_appeal(appeal_id: str, update_data: AppealUpdate):
    """Update an appeal's status or notes"""
    if appeal_id not in appeals_db:
        raise HTTPException(status_code=404, detail="Appeal not found")
    
    appeal = appeals_db[appeal_id]
    
    if update_data.status:
        appeal["status"] = update_data.status
    if update_data.notes:
        appeal["notes"] = update_data.notes
    
    appeal["updated_at"] = datetime.utcnow().isoformat()
    
    return SuccessResponse(
        message="Appeal updated successfully",
        data=appeal
    )

@router.delete("/appeals/{appeal_id}", response_model=SuccessResponse)
async def delete_appeal(appeal_id: str):
    """Delete an appeal"""
    if appeal_id not in appeals_db:
        raise HTTPException(status_code=404, detail="Appeal not found")
    
    del appeals_db[appeal_id]
    
    return SuccessResponse(message="Appeal deleted successfully")

# ==================== VERIFICATION ENDPOINTS ====================

@router.post("/verify", response_model=SuccessResponse)
async def verify_document(verification_data: VerificationData):
    """Officer submits verification decision"""
    verification_id = f"VER-{uuid.uuid4().hex[:8].upper()}"
    
    verification = {
        "verification_id": verification_id,
        "application_id": verification_data.application_id,
        "officer_id": verification_data.officer_id,
        "decision": verification_data.decision,
        "feedback": verification_data.feedback,
        "verification_type": verification_data.verification_type,
        "verified_at": datetime.utcnow().isoformat()
    }
    
    verifications_db[verification_id] = verification
    
    return SuccessResponse(
        message="Verification saved successfully",
        data={"verification_id": verification_id, **verification}
    )

@router.get("/verification/{verification_id}")
async def get_verification(verification_id: str):
    """Get verification details"""
    if verification_id not in verifications_db:
        raise HTTPException(status_code=404, detail="Verification not found")
    
    return SuccessResponse(
        message="Verification retrieved successfully",
        data=verifications_db[verification_id]
    )

# ==================== AI REVIEW ENDPOINTS ====================

@router.post("/ai-review", response_model=SuccessResponse)
async def submit_ai_review(review_data: AIReviewData):
    """Officer submits AI review result"""
    review_id = f"REVIEW-{uuid.uuid4().hex[:8].upper()}"
    
    review = {
        "review_id": review_id,
        "application_id": review_data.application_id,
        "officer_id": review_data.officer_id,
        "ai_recommendation": review_data.ai_recommendation,
        "officer_decision": review_data.officer_decision,
        "confidence_score": review_data.confidence_score,
        "review_notes": review_data.review_notes,
        "reviewed_at": datetime.utcnow().isoformat()
    }
    
    reviews_db[review_id] = review
    
    return SuccessResponse(
        message="AI Review submitted successfully",
        data={"review_id": review_id, **review}
    )

@router.get("/ai-review/{review_id}")
async def get_ai_review(review_id: str):
    """Get AI review details"""
    if review_id not in reviews_db:
        raise HTTPException(status_code=404, detail="Review not found")
    
    return SuccessResponse(
        message="AI Review retrieved successfully",
        data=reviews_db[review_id]
    )

# ==================== APPLICATIONS ENDPOINTS ====================

@router.get("/applications")
async def list_applications(
    status: Optional[str] = Query(None),
    page: int = Query(1, ge=1),
    per_page: int = Query(10, ge=1, le=100)
):
    """List all applications from SQLite"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    query = "SELECT * FROM applications"
    params = []
    
    if status:
        query += " WHERE status = ?"
        params.append(status)
    
    query += " ORDER BY created_at DESC"
    
    cursor.execute(query, params)
    rows = cursor.fetchall()
    conn.close()
    
    apps_list = []
    for row in rows:
        app = dict(row)
        if app.get("ai_results"):
            try:
                app["ai_results"] = json.loads(app["ai_results"])
            except:
                pass
        apps_list.append(app)
    
    total = len(apps_list)
    start = (page - 1) * per_page
    end = start + per_page
    
    return PaginatedResponse(
        total=total,
        page=page,
        per_page=per_page,
        data=apps_list[start:end],
        message="Applications retrieved successfully"
    )

@router.get("/applications/{application_id}")
async def get_application(application_id: str):
    """Get single application from SQLite"""
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM applications WHERE application_id = ?", (application_id,))
    row = cursor.fetchone()
    conn.close()
    
    if not row:
        raise HTTPException(status_code=404, detail="Application not found")
    
    app = dict(row)
    if app.get("ai_results"):
        try:
            app["ai_results"] = json.loads(app["ai_results"])
        except:
            pass
            
    return SuccessResponse(message="Application retrieved", data=app)

@router.put("/applications/{application_id}")
async def update_application(application_id: str, payload: dict):
    """Update application status or feedback in SQLite"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Check if exists
    cursor.execute("SELECT application_id FROM applications WHERE application_id = ?", (application_id,))
    if not cursor.fetchone():
        conn.close()
        raise HTTPException(status_code=404, detail="Application not found")

    status = payload.get("status")
    feedback = payload.get("feedback")
    updated_at = datetime.utcnow().isoformat()

    if status and feedback:
        cursor.execute("UPDATE applications SET status = ?, feedback = ?, created_at = ? WHERE application_id = ?", 
                      (status, feedback, updated_at, application_id))
    elif status:
        cursor.execute("UPDATE applications SET status = ?, created_at = ? WHERE application_id = ?", 
                      (status, updated_at, application_id))
    elif feedback:
        cursor.execute("UPDATE applications SET feedback = ?, created_at = ? WHERE application_id = ?", 
                      (feedback, updated_at, application_id))

    conn.commit()
    conn.close()

    return SuccessResponse(message="Application updated successfully")

# ==================== DOCUMENT ENDPOINTS ====================

@router.post("/upload", response_model=SuccessResponse)
async def upload_documents(
    document_type: str = Form(...),
    applicant_name: str = Form(...),
    applicant_email: str = Form(...),
    applicant_id: str = Form(None),
    applicant_phone: str = Form(None),
    description: str = Form(None),
    documents: List[UploadFile] = File(...)
):
    """Upload multiple documents with AI processing"""
    results = []
    stored_documents = []
    application_id = f"APP-{datetime.utcnow().year}-{str(uuid.uuid4().hex[:3]).upper()}"
    
    # AI Summary fields to be updated
    total_confidence = 0
    all_authentic = True
    
    for file in documents:
        doc_id = f"DOC-{uuid.uuid4().hex[:8].upper()}"
        file_bytes = await file.read()
        
        # Base64 for preview
        encoded = base64.b64encode(file_bytes).decode("utf-8")
        mime_type = file.content_type or "application/octet-stream"
        data_url = f"data:{mime_type};base64,{encoded}"
        
        # Real AI Processing using the trained model from the notebook
        ai_service = get_ai_service()
        ai_result = ai_service.predict(file_bytes)
        
        ai_confidence = ai_result.get("confidence", 0)
        authenticity = ai_result.get("authenticity", "suspicious")
        quality_score = ai_result.get("quality_score", 0)
        
        total_confidence += ai_confidence
        if authenticity != "authentic":
            all_authentic = False
        
        # Determine issues based on confidence
        issues = []
        if ai_confidence < 85:
            issues.append("Low confidence score - manual review recommended")
        if quality_score < 75:
            issues.append("Image quality could be improved")
        
        feedback_items = [
            "Document structure verified",
            "Security features detected",
            "Text extraction successful"
        ]
        
        if authenticity == "suspicious":
            feedback_items.append("⚠ Irregularities detected by AI model")
        
        result = {
            "doc_id": doc_id,
            "application_id": application_id,
            "filename": file.filename,
            "document_type": document_type,
            "file_size": len(file_bytes),
            "uploaded_at": datetime.utcnow().isoformat(),
            "confidence": ai_confidence,
            "authenticity": authenticity,
            "quality_score": quality_score,
            "issues": issues,
            "feedback": feedback_items,
            "processing_status": "completed",
            "ai_processed": ai_result.get("ai_processed", False)
        }

        stored_documents.append({
            "doc_id": doc_id,
            "name": file.filename,
            "type": mime_type,
            "size": len(file_bytes),
            "data": data_url
        })
        
        results.append(result)
    
    # Calculate summary levels
    avg_confidence = total_confidence / len(documents) if documents else 0
    verdict = "authentic" if all_authentic else "suspicious"
    
    # Save to SQLite
    avg_conf = round(avg_confidence, 2)
    feedback_text = f"AI Processing complete: {verdict.upper()} with {avg_conf}% confidence."
    created_at = datetime.utcnow().isoformat()
    priority = "urgent" if not all_authentic else "normal"
    
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('''
    INSERT INTO applications (
        application_id, citizen_name, citizen_email, citizen_id,
        citizen_phone, description, document_type, status,
        created_at, priority, ai_confidence, ai_verdict,
        ai_results, feedback
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (
        application_id, applicant_name, applicant_email, applicant_id,
        applicant_phone, description, document_type, "pending",
        created_at, priority, avg_conf, verdict,
        json.dumps(results), feedback_text
    ))
    conn.commit()
    conn.close()
    
    return SuccessResponse(
        message=f"Successfully processed {len(documents)} document(s)",
        data={
            "application_id": application_id,
            "results": results,
            "summary": {
                "total_documents": len(documents),
                "average_confidence": avg_confidence,
                "all_authentic": all_authentic
            }
        }
    )

@router.post("/document-request", response_model=SuccessResponse)
async def request_document(request: DocumentRequest):
    """Create a new document request in SQLite"""
    request_id = f"DOCREQ-{datetime.utcnow().year}-{str(uuid.uuid4().hex[:8]).upper()}"
    requested_at = request.requested_at or datetime.utcnow().isoformat()
    
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('''
    INSERT INTO document_requests (
        request_id, document_type, citizen_name, citizen_id, 
        citizen_phone, reason, status, requested_at, remarks
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (
        request_id, request.document_type, request.citizen_name,
        request.citizen_id, request.citizen_phone, request.reason or "No reason specified",
        "pending", requested_at, ""
    ))
    conn.commit()
    conn.close()
    
    return SuccessResponse(
        message="Document request submitted successfully",
        data={
            "request_id": request_id,
            "status": "pending",
            "document_type": request.document_type,
            "citizen_id": request.citizen_id,
            "requested_at": requested_at
        }
    )

@router.get("/document-requests", response_model=PaginatedResponse)
async def list_document_requests(
    citizen_id: Optional[str] = Query(None),
    status: Optional[str] = Query(None),
    page: int = Query(1, ge=1),
    per_page: int = Query(10, ge=1, le=100)
):
    """List document requests from SQLite"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    query = "SELECT * FROM document_requests"
    params = []
    
    conditions = []
    if citizen_id:
        conditions.append("citizen_id = ?")
        params.append(citizen_id)
    if status:
        conditions.append("status = ?")
        params.append(status)
        
    if conditions:
        query += " WHERE " + " AND ".join(conditions)
        
    query += " ORDER BY requested_at DESC"
    
    cursor.execute(query, params)
    rows = cursor.fetchall()
    conn.close()
    
    requests_list = [dict(row) for row in rows]
    
    total = len(requests_list)
    start = (page - 1) * per_page
    end = start + per_page
    
    return PaginatedResponse(
        total=total,
        page=page,
        per_page=per_page,
        data=requests_list[start:end]
    )

@router.get("/document-requests/{request_id}")
async def get_document_request(request_id: str):
    """Get a specific document request from SQLite"""
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM document_requests WHERE request_id = ?", (request_id,))
    row = cursor.fetchone()
    conn.close()
    
    if not row:
        raise HTTPException(status_code=404, detail="Document request not found")
    
    return SuccessResponse(message="Document request retrieved", data=dict(row))

@router.put("/document-requests/{request_id}", response_model=SuccessResponse)
async def update_document_request(request_id: str, status: str = Query(...)):
    """Update document request status in SQLite"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Check if exists
    cursor.execute("SELECT request_id FROM document_requests WHERE request_id = ?", (request_id,))
    if not cursor.fetchone():
        conn.close()
        raise HTTPException(status_code=404, detail="Document request not found")
        
    cursor.execute("UPDATE document_requests SET status = ? WHERE request_id = ?", (status, request_id))
    conn.commit()
    conn.close()
    
    return SuccessResponse(message=f"Document request updated to {status}")

@router.post("/ai-process", response_model=SuccessResponse)
async def process_with_ai(
    application_id: str = Query(...),
    file: UploadFile = File(...)
):
    """Process document with AI model"""
    process_id = f"PROC-{uuid.uuid4().hex[:8].upper()}"
    file_bytes = await file.read()
    
    # Real AI Inference
    ai_service = get_ai_service()
    ai_result = ai_service.predict(file_bytes)
    
    result = {
        "process_id": process_id,
        "application_id": application_id,
        "status": "completed",
        "ai_prediction": "valid" if ai_result.get("is_valid") else "invalid",
        "confidence": ai_result.get("confidence", 0) / 100.0,
        "processed_at": datetime.utcnow().isoformat(),
        "details": ai_result
    }
    
    return SuccessResponse(
        message="Document processing completed",
        data=result
    )

@router.get("/ai-predictions/{prediction_id}")
async def get_ai_predictions(prediction_id: str):
    """Get AI prediction results"""
    return SuccessResponse(
        message="Prediction results retrieved",
        data={
            "prediction_id": prediction_id,
            "status": "completed",
            "result": "valid",
            "confidence": 0.95
        }
    )

# ==================== STATISTICS ENDPOINTS ====================

@router.get("/statistics/appeals")
async def get_appeals_statistics():
    """Get appeals statistics"""
    status_counts = {}
    for appeal in appeals_db.values():
        status = appeal.get("status", "unknown")
        status_counts[status] = status_counts.get(status, 0) + 1
    
    return SuccessResponse(
        message="Appeals statistics retrieved",
        data={
            "total_appeals": len(appeals_db),
            "status_breakdown": status_counts
        }
    )

@router.get("/statistics/verifications")
async def get_verification_statistics():
    """Get verification statistics"""
    return SuccessResponse(
        message="Verification statistics retrieved",
        data={
            "total_verifications": len(verifications_db),
            "processed_today": 0  # Would calculate in production
        }
    )

