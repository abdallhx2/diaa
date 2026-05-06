import pytest
import uuid
from unittest.mock import patch, MagicMock
from sqlalchemy import create_engine, StaticPool
from sqlalchemy.orm import sessionmaker

# Mock settings before importing anything that uses them
mock_settings = MagicMock()
mock_settings.DATABASE_URL = "sqlite://"
mock_settings.FIREBASE_CREDENTIALS_PATH = "/fake/path.json"
mock_settings.OPENROUTER_API_KEY = "fake-key"
mock_settings.CHAT_MODEL = "openai/gpt-4o-mini"
mock_settings.VISION_MODEL = "openai/gpt-4o-mini"
mock_settings.TTS_MODEL = "openai/tts-1"
mock_settings.TTS_VOICE = "alloy"
mock_settings.FIREBASE_STORAGE_BUCKET = "fake-bucket"
mock_settings.APP_ENV = "testing"
mock_settings.CORS_ORIGINS = "http://localhost:3000"
mock_settings.cors_origins_list = ["http://localhost:3000"]
mock_settings.USE_MOCKS = True

# Patch settings and external services before importing the app
with patch("app.config.settings", mock_settings), \
     patch("app.config.Settings", return_value=mock_settings):
    pass


@pytest.fixture
def mock_db():
    """Create a mock database session."""
    session = MagicMock()
    session.query.return_value = session
    session.filter.return_value = session
    session.filter_by.return_value = session
    session.first.return_value = None
    session.all.return_value = []
    session.count.return_value = 0
    return session
