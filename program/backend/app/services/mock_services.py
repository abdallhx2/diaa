"""
Mock implementations for external services.
Used when USE_MOCKS=true in .env — allows the backend to run
without real Firebase, Azure, or OpenAI credentials.
"""

import hashlib
from typing import Optional


# ─── Mock Firebase Auth ─────────────────────────────────────────────

class MockFirebaseAuth:
    """Drop-in mock for firebase_admin.auth functions."""

    @staticmethod
    def verify_id_token(token: str) -> dict:
        """Parse a mock token and return a fake decoded dict.
        Token format: "mock_role_name"  e.g. "mock_student_طالب"
        Falls back to role=student, name=MockUser if format doesn't match.
        """
        parts = token.split("_", 2)  # ["mock", "role", "name"]
        if len(parts) >= 3 and parts[0] == "mock":
            role = parts[1]
            name = parts[2]
        elif len(parts) == 2 and parts[0] == "mock":
            role = parts[1]
            name = "MockUser"
        else:
            role = "student"
            name = "MockUser"

        uid = hashlib.md5(token.encode("utf-8")).hexdigest()

        return {
            "uid": uid,
            "email": f"{uid[:8]}@mock.edu",
            "name": name,
            "role": role,
        }

    @staticmethod
    def create_user(
        email: Optional[str] = None,
        display_name: Optional[str] = None,
        **kwargs,
    ):
        """Return a fake user object with uid, email, display_name."""
        seed = (email or "no-email") + (display_name or "no-name")
        uid = hashlib.md5(seed.encode("utf-8")).hexdigest()

        class _FakeUser:
            pass

        user = _FakeUser()
        user.uid = uid
        user.email = email or f"{uid[:8]}@mock.edu"
        user.display_name = display_name or "MockUser"
        return user


# ─── Mock OCR (EasyOCR) ─────────────────────────────────────────────

class MockOCR:
    """Drop-in mock for easyocr.Reader — implements readtext()."""

    def readtext(self, image_array):
        """Return two hardcoded Arabic OCR results.
        Each result is a tuple: (bbox, text, confidence).
        bbox is a list of 4 corner points [[x1,y1],[x2,y2],[x3,y3],[x4,y4]].
        """
        return [
            (
                [[10, 10], [200, 10], [200, 50], [10, 50]],
                "بسم الله الرحمن الرحيم",
                0.95,
            ),
            (
                [[10, 60], [200, 60], [200, 100], [10, 100]],
                "الدرس الأول: مقدمة في العلوم",
                0.88,
            ),
        ]


# ─── Mock TTS (Azure Speech) ────────────────────────────────────────

class MockTTS:
    """Mock for Azure Text-to-Speech — returns a deterministic fake URL."""

    @staticmethod
    def convert(text: str) -> str:
        """Return a fake audio URL based on md5 of the input text."""
        text_hash = hashlib.md5(text.encode("utf-8")).hexdigest()
        return f"https://mock-storage.example.com/audio/{text_hash}.mp3"


# ─── Mock OpenAI Chat ───────────────────────────────────────────────

class MockOpenAI:
    """Mock for OpenAI GPT chat completions."""

    @staticmethod
    def get_answer(question: str, lesson_text: str = "") -> str:
        """Return a contextual Arabic response.
        If lesson_text is empty, returns the off-topic message.
        Otherwise returns a simple mock answer referencing the question.
        """
        if not lesson_text:
            return "هذا السؤال خارج محتوى الدرس الحالي."

        return (
            f"سؤال جيد! بناءً على محتوى الدرس، "
            f"الإجابة هي أن هذا الموضوع مهم جداً للتعلم. "
            f"تابع القراءة وستفهم أكثر."
        )


# ─── Mock Firebase Storage ──────────────────────────────────────────

class MockFirebaseStorage:
    """In-memory mock for Firebase Storage operations."""

    _store: dict = {}

    @classmethod
    def upload(cls, file_bytes: bytes, path: str) -> str:
        """Store bytes in memory and return a fake public URL."""
        cls._store[path] = file_bytes
        path_hash = hashlib.md5(path.encode("utf-8")).hexdigest()
        return f"https://mock-storage.example.com/{path_hash}/{path}"

    @classmethod
    def get_url(cls, path: str) -> Optional[str]:
        """Return fake URL if path exists in memory store, else None."""
        if path in cls._store:
            path_hash = hashlib.md5(path.encode("utf-8")).hexdigest()
            return f"https://mock-storage.example.com/{path_hash}/{path}"
        return None

    @classmethod
    def delete(cls, path: str) -> bool:
        """Remove path from memory store. Returns True if existed."""
        if path in cls._store:
            del cls._store[path]
            return True
        return False
