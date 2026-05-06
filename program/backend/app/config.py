from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    DATABASE_URL: str
    FIREBASE_CREDENTIALS_PATH: str
    FIREBASE_STORAGE_BUCKET: str

    # OpenRouter — single provider for all AI services
    OPENROUTER_API_KEY: str
    CHAT_MODEL: str = "google/gemini-3.1-flash-lite-preview"
    VISION_MODEL: str = "anthropic/claude-sonnet-4.5"
    TTS_MODEL: str = "openai/gpt-audio-mini"
    TTS_VOICE: str = "alloy"

    APP_ENV: str = "development"
    PORT: int = 8000
    CORS_ORIGINS: str = "http://localhost:3000,http://localhost:8080"
    USE_MOCKS: bool = False
    MOCK_AI: bool = True  # When False, uses real OpenRouter even if USE_MOCKS=true

    @property
    def cors_origins_list(self) -> List[str]:
        return [origin.strip() for origin in self.CORS_ORIGINS.split(",")]

    model_config = {
        "env_file": ".env",
        "env_file_encoding": "utf-8",
    }


settings = Settings()
