from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    DATABASE_URL: str
    FIREBASE_CREDENTIALS_PATH: str
    AZURE_SPEECH_KEY: str
    AZURE_SPEECH_REGION: str
    GEMINI_API_KEY: str = ""
    OPENAI_MODEL: str = "gpt-4o-mini"
    FIREBASE_STORAGE_BUCKET: str = ""
    APP_ENV: str = "development"
    CORS_ORIGINS: List[str] = ["http://localhost:3000", "http://localhost:5173"]

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


settings = Settings()