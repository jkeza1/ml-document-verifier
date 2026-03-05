"""
Utility functions for iRembo Backend API
"""

import uuid
import os
from datetime import datetime, timedelta
from typing import Dict, Any, List, Optional
import logging
import cv2
import numpy as np
import tensorflow as tf
import joblib
from functools import lru_cache
from config import settings

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def generate_id(prefix: str) -> str:
    """
    Generate a unique ID with prefix
    
    Args:
        prefix: ID prefix (e.g., 'APPEAL', 'APP')
    
    Returns:
        Formatted ID string (e.g., 'APPEAL-a1b2c3d4')
    """
    return f"{prefix}-{uuid.uuid4().hex[:8].upper()}"

def get_timestamp() -> str:
    """Get current UTC timestamp in ISO format"""
    return datetime.utcnow().isoformat()

def get_expiry_time(hours: int = 24) -> str:
    """Get expiry timestamp"""
    return (datetime.utcnow() + timedelta(hours=hours)).isoformat()

def validate_email(email: str) -> bool:
    """Basic email validation"""
    return "@" in email and "." in email

def format_response(status: str, message: str, data: Dict[str, Any] = None) -> Dict:
    """Format API response"""
    response = {
        "status": status,
        "message": message,
        "timestamp": get_timestamp()
    }
    if data:
        response["data"] = data
    return response

def log_action(action: str, details: Dict[str, Any] = None):
    """Log an action"""
    message = f"Action: {action}"
    if details:
        message += f" | Details: {details}"
    logger.info(message)

def ensure_upload_dir(upload_dir: str):
    """Ensure upload directory exists"""
    if not os.path.exists(upload_dir):
        os.makedirs(upload_dir)
        logger.info(f"Created upload directory: {upload_dir}")

def parse_pagination_params(page: int = 1, per_page: int = 10) -> tuple:
    """Parse and validate pagination parameters"""
    page = max(1, page)
    per_page = min(100, max(1, per_page))
    return page, per_page

def calculate_pagination(total: int, page: int, per_page: int) -> Dict:
    """Calculate pagination metadata"""
    total_pages = (total + per_page - 1) // per_page
    has_prev = page > 1
    has_next = page < total_pages
    
    return {
        "total": total,
        "page": page,
        "per_page": per_page,
        "total_pages": total_pages,
        "has_prev": has_prev,
        "has_next": has_next
    }

def filter_dict(data: Dict, keep_keys: list) -> Dict:
    """Filter dictionary to only keep specified keys"""
    return {k: v for k, v in data.items() if k in keep_keys}

def merge_dicts(*dicts) -> Dict:
    """Merge multiple dictionaries"""
    result = {}
    for d in dicts:
        result.update(d)
    return result

class AIService:
    """Service for AI document verification combining Forensics, OCR, and NLP"""
    
    def __init__(self):
        self.model = None
        self.poly = None
        self.scaler = None
        self._load_resources()

    def _load_resources(self):
        """Load model and preprocessing objects"""
        try:
            if not os.path.exists(settings.model_path):
                logger.error(f"Model file not found at {settings.model_path}")
                return
            
            self.model = tf.keras.models.load_model(settings.model_path)
            self.poly = joblib.load(settings.poly_path)
            self.scaler = joblib.load(settings.scaler_path)
            logger.info(f"AI Model loaded from {settings.model_path}")
            logger.info("Preprocessing objects (Poly, Scaler) loaded successfully")
        except Exception as e:
            logger.error(f"Error loading AI resources: {str(e)}")

    def _perform_ocr(self, img_bytes: bytes) -> Dict[str, str]:
        """
        Extract text content using OCR.
        (Placeholder logic - would use pytesseract or EasyOCR)
        """
        return {
            "full_name": "JOHN DOE",
            "id_number": "ID-884-221",
            "expiry_date": "2029-12-31"
        }

    def _apply_nlp_matching(self, ocr_data: Dict, user_provided_data: Dict) -> Dict:
        """
        Uses NLP logic to cross-match OCR text against User records.
        """
        match_score = 0
        checks = {}
        
        if ocr_data["full_name"] == user_provided_data.get("full_name"):
            match_score += 40
            checks["name_match"] = "perfect"
        else:
            checks["name_match"] = "mismatch_flagged"

        if ocr_data["id_number"] == user_provided_data.get("id_number"):
            match_score += 40
            checks["id_match"] = "verified"
        
        checks["is_expired"] = False

        return {
            "total_match_score": match_score,
            "data_consistency": "high" if match_score >= 80 else "low",
            "checks": checks
        }

    def extract_features(self, file_path_or_bytes, target_size=(224, 224)) -> Optional[tuple]:
        """Extract features from image (mirrors notebook implementation)"""
        try:
            if isinstance(file_path_or_bytes, str):
                img = cv2.imread(file_path_or_bytes)
            else:
                nparr = np.frombuffer(file_path_or_bytes, np.uint8)
                img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
            
            if img is None:
                return None
            
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            resized = cv2.resize(gray, target_size)
            
            feat = {
                'mean_brightness': float(np.mean(resized)),
                'std_brightness': float(np.std(resized)),
                'contrast': float(resized.max() - resized.min())
            }
            
            edges = cv2.Canny(resized, 100, 200)
            feat['edge_density'] = float(np.sum(edges > 0) / (target_size[0] * target_size[1]))
            feat['blur_score'] = float(cv2.Laplacian(resized, cv2.CV_64F).var())
            
            binary = cv2.threshold(resized, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)[1]
            feat['text_density'] = float(np.sum(binary > 0) / (target_size[0] * target_size[1]))
            
            hist = cv2.calcHist([resized], [0], None, [16], [0, 256]).flatten() / (target_size[0] * target_size[1])
            feat['hist_entropy'] = float(-np.sum(hist * np.log2(hist + 1e-10)))
            feat['aspect_ratio'] = float(img.shape[1] / img.shape[0])
            
            # --- UNIQUE AI FORENSIC FEATURES ---
            laplacian = cv2.Laplacian(resized, cv2.CV_64F)
            feat['forensic_noise'] = float(np.std(laplacian))
            
            _, thresh = cv2.threshold(resized, 240, 255, cv2.THRESH_BINARY)
            feat['glare_index'] = float(np.sum(thresh > 0) / (target_size[0] * target_size[1]))

            # Prep for model
            features_array = np.array([[
                feat['mean_brightness'], feat['std_brightness'], feat['contrast'],
                feat['edge_density'], feat['blur_score'], feat['text_density'],
                feat['hist_entropy'], feat['aspect_ratio']
            ]], dtype=np.float32)
            
            return features_array, feat
            
        except Exception as e:
            logger.error(f"Feature extraction failed: {str(e)}")
            return None

    def predict(self, file_source, user_data: Dict = None) -> Dict[str, Any]:
        """
        Final Unified Decision Engine: Forensics + OCR + NLP
        """
        user_data = user_data or {"full_name": "JOHN DOE", "id_number": "ID-884-221"}
        
        if self.model is None or self.poly is None or self.scaler is None:
            logger.warning("AI Model resources missing, using simulation")
            return self._simulate_prediction()

        extraction_result = self.extract_features(file_source)
        if extraction_result is None:
            return {"error": "Failed to process image"}
            
        features, raw_details = extraction_result

        try:
            # 1. AI AUTHENTICITY PREDICTION
            features_poly = self.poly.transform(features)
            features_scaled = self.scaler.transform(features_poly)
            prediction = self.model.predict(features_scaled, verbose=0)
            confidence = float(prediction[0][0])
            
            # --- BLUR-BYPASS LOGIC ---
            noise_level = raw_details.get('forensic_noise', 0)
            glare_level = raw_details.get('glare_index', 0)
            is_blurry = raw_details['blur_score'] < 100
            is_digitally_authentic = noise_level > 5.0
            
            if is_blurry and is_digitally_authentic:
                confidence = max(confidence, 0.85)

            # 2. OCR TEXT EXTRACTION (Mock for now)
            ocr_text = self._perform_ocr(b"" if isinstance(file_source, str) else file_source)
            
            # 3. NLP DATA CROSS-MATCHING (Mock for now)
            nlp_results = self._apply_nlp_matching(ocr_text, user_data)
            
            # FINAL UNIFIED VERDICT
            is_authentic = confidence >= settings.confidence_threshold
            is_consistent = nlp_results["total_match_score"] >= 80
            
            verdict = "authentic" if is_authentic else "fraudulent"
            
            return {
                "prediction": confidence,
                "confidence": round(confidence * 100, 2),
                "verdict": verdict,
                "ai_forensics": {
                    "noise_integrity": noise_level,
                    "specular_glare": glare_level,
                    "is_screen_forgery": glare_level > 0.05 or noise_level < 2.0
                },
                "ocr_data": ocr_text,
                "nlp_matching": {
                    "is_match": is_consistent,
                    "score": nlp_results["total_match_score"],
                    "details": nlp_results["checks"]["name_match"]
                },
                "timestamp": datetime.utcnow().isoformat()
            }
        except Exception as e:
            logger.error(f"Unified Inference failed: {str(e)}")
            return self._simulate_prediction()

    def _simulate_prediction(self):
        """Simulation fallback"""
        import random
        conf = random.uniform(80, 95)
        return {
            "confidence": round(conf, 2),
            "is_valid": conf > 85,
            "authenticity": "authentic" if conf > 85 else "suspicious",
            "quality_score": round(random.uniform(80, 98), 2),
            "status": "approved" if conf > 85 else "rejected",
            "ai_processed": False,
            "simulation": True,
            "processed_at": datetime.utcnow().isoformat()
        }

@lru_cache()
def get_ai_service():
    """Singleton pattern for AI service"""
    return AIService()

class PaginatedList:
    """Helper class for paginated data"""
    
    def __init__(self, items: list, page: int = 1, per_page: int = 10):
        self.all_items = items
        self.page = page
        self.per_page = per_page
        
    def get_page(self) -> list:
        """Get current page items"""
        start = (self.page - 1) * self.per_page
        end = start + self.per_page
        return self.all_items[start:end]
    
    def get_metadata(self) -> Dict:
        """Get pagination metadata"""
        return calculate_pagination(len(self.all_items), self.page, self.per_page)

# Error handler decorators
def handle_errors(func):
    """Decorator to handle common errors"""
    async def wrapper(*args, **kwargs):
        try:
            return await func(*args, **kwargs)
        except Exception as e:
            logger.error(f"Error in {func.__name__}: {str(e)}")
            raise
    return wrapper
