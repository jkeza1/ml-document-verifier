"""
Configuration settings for iRembo Backend API
"""

from pydantic_settings import BaseSettings
from typing import List, Optional
import os

class Settings(BaseSettings):
    """Application settings"""
    
    # Server
    host: str = os.getenv("HOST", "0.0.0.0")
    port: int = int(os.getenv("PORT", 5000))
    debug: bool = os.getenv("DEBUG", "True").lower() == "true"
    reload: bool = os.getenv("RELOAD", "True").lower() == "true"
    
    # API
    api_prefix: str = os.getenv("API_PREFIX", "/api")
    api_version: str = os.getenv("API_VERSION", "1.0.0")
    
    # Database
    database_url: str = os.getenv("DATABASE_URL", "sqlite:///./irembo.db")
    
    # Security
    secret_key: str = os.getenv("SECRET_KEY", "change-me-in-production")
    algorithm: str = os.getenv("ALGORITHM", "HS256")
    access_token_expire_minutes: int = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 30))
    
    # CORS
    cors_origins: List[str] = [
        "http://localhost:3000",
        "http://localhost:8000",
        "http://localhost:8080",
        "http://localhost",
    ]
    
    # AI Model
    model_path: str = os.getenv("MODEL_PATH", "../../output/models/best_model.keras")
    poly_path: str = os.getenv("POLY_PATH", "../../output/models/feature_poly.pkl")
    scaler_path: str = os.getenv("SCALER_PATH", "../../output/models/feature_scaler.pkl")
    confidence_threshold: float = float(os.getenv("CONFIDENCE_THRESHOLD", 0.84))
    
    # File Upload
    max_file_size: int = int(os.getenv("MAX_FILE_SIZE", 10485760))  # 10MB
    upload_dir: str = os.getenv("UPLOAD_DIR", "./uploads")
    
    # Logging
    log_level: str = os.getenv("LOG_LEVEL", "info")
    
    class Config:
        env_file = ".env"
        case_sensitive = False

# Initialize settings
settings = Settings()
