"""
Data Models for iRembo Document Verification System
"""

from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional, List

# Appeals Models
class AppealCreate(BaseModel):
    """Model for creating a new appeal"""
    application_id: str = Field(..., description="ID of the application being appealed")
    reason: str = Field(..., description="Reason for appeal")
    additional_documents: Optional[str] = Field(None, description="Additional supporting documents")
    
    class Config:
        json_schema_extra = {
            "example": {
                "application_id": "APP-001",
                "reason": "Document verification was incorrect",
                "additional_documents": "Additional proof document"
            }
        }

class Appeal(AppealCreate):
    """Appeal model with system fields"""
    appeal_id: str
    status: str = Field(default="pending", description="Status: pending, approved, rejected")
    created_at: datetime
    updated_at: datetime
    citizen_id: str
    
    class Config:
        json_schema_extra = {
            "example": {
                "appeal_id": "APPEAL-001",
                "application_id": "APP-001",
                "citizen_id": "CITIZEN-123",
                "reason": "Document verification was incorrect",
                "status": "pending",
                "created_at": "2026-02-09T10:00:00",
                "updated_at": "2026-02-09T10:00:00"
            }
        }

class AppealUpdate(BaseModel):
    """Model for updating an appeal"""
    status: Optional[str] = None
    notes: Optional[str] = None

# Application Models
class ApplicationCreate(BaseModel):
    """Model for creating an application"""
    citizen_id: str
    document_type: str
    submission_date: datetime
    
class Application(ApplicationCreate):
    """Application model"""
    application_id: str
    status: str = "submitted"
    created_at: datetime
    
# Verification Models
class VerificationData(BaseModel):
    """Model for verification decision"""
    application_id: str
    officer_id: str
    decision: str = Field(..., description="approved or rejected")
    feedback: Optional[str] = None
    verification_type: str = Field(default="manual", description="manual or ai-assisted")

class Verification(VerificationData):
    """Verification record"""
    verification_id: str
    verified_at: datetime
    
# AI Review Models
class AIReviewData(BaseModel):
    """Model for AI review submission"""
    application_id: str
    officer_id: str
    ai_recommendation: Optional[str] = None
    officer_decision: Optional[str] = None
    confidence_score: Optional[float] = None
    review_notes: Optional[str] = None

class AIReview(AIReviewData):
    """AI Review record"""
    review_id: str
    reviewed_at: datetime
    
# Document Models
class DocumentUpload(BaseModel):
    """Model for document upload"""
    application_id: str
    document_type: str
    file_name: str
    file_size: int

class DocumentRequest(BaseModel):
    """Model for requesting documents from iRembo"""
    document_type: str = Field(..., description="Type of document being requested")
    citizen_name: str = Field(..., description="Full name of citizen")
    citizen_id: str = Field(..., description="National ID of citizen")
    citizen_phone: str = Field(..., description="Phone number of citizen")
    reason: Optional[str] = Field(None, description="Reason for requesting document")
    requested_at: Optional[str] = Field(None, description="Timestamp of request")

# Response Models
class SuccessResponse(BaseModel):
    """Generic success response"""
    status: str = "success"
    message: str
    data: Optional[dict] = None
    timestamp: datetime = Field(default_factory=datetime.utcnow)

class ErrorResponse(BaseModel):
    """Generic error response"""
    status: str = "error"
    error_code: str
    message: str
    timestamp: datetime = Field(default_factory=datetime.utcnow)

class PaginatedResponse(BaseModel):
    """Paginated response model"""
    status: str = "success"
    total: int
    page: int
    per_page: int
    data: List[dict]
    message: str = "Success"
    timestamp: datetime = Field(default_factory=datetime.utcnow)
