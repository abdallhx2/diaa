from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from app.services.tts_service import generate_speech
from app.models.user import User
from app.middleware.auth_middleware import get_current_user
from app.utils.helpers import format_response
from app.utils import rate_limiter

router = APIRouter()


class TTSRequest(BaseModel):
    text: str


@router.post("/generate")
async def generate_tts(
    body: TTSRequest,
    current_user: User = Depends(get_current_user),
):
    """Convert Arabic text to speech and return audio URL."""
    if not rate_limiter.check(current_user.firebase_uid, 15):
        raise HTTPException(
            status_code=429,
            detail=format_response(False, None, "تجاوزت الحد المسموح، حاول بعد قليل"),
        )
    try:
        if not body.text or not body.text.strip():
            raise HTTPException(
                status_code=400,
                detail=format_response(False, None, "النص مطلوب"),
            )

        audio_url = generate_speech(body.text)
        return format_response(True, {"audio_url": audio_url}, "تم تحويل النص إلى صوت")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))
