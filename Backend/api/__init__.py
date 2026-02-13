"""
iRembo Document Verification - Backend API Package
"""

__version__ = "1.0.0"
__author__ = "iRembo Team"
__description__ = "FastAPI backend for document verification and appeals management"

from .main import app
from .models import Appeal, Verification, AIReview
from .config import settings

__all__ = ["app", "Appeal", "Verification", "AIReview", "settings"]
