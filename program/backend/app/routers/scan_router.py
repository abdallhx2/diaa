from fastapi import APIRouter, Depends, UploadFile, File, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session
from app.database import get_db
from app.services.ocr_service import extract_text_from_image
from app.services import achievement_service
from app.models.lesson import Lesson
from app.models.user import User
from app.middleware.auth_middleware import get_current_user
from app.utils.helpers import format_response

router = APIRouter()

ALLOWED_TYPES = {"image/jpeg", "image/png", "image/jpg"}
MAX_FILE_SIZE = 10 * 1024 * 1024  # 10 MB


class QRRequest(BaseModel):
    qr_code: str


@router.post("/ocr")
async def ocr_scan(
    image: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
):
    """Extract Arabic text from a camera image using OCR."""
    try:
        if image.content_type not in ALLOWED_TYPES:
            raise HTTPException(
                status_code=400,
                detail=format_response(False, None, "نوع الملف غير مدعوم. استخدم JPEG أو PNG"),
            )

        contents = await image.read()
        if len(contents) > MAX_FILE_SIZE:
            raise HTTPException(
                status_code=413,
                detail=format_response(False, None, "حجم الملف يتجاوز 10 ميجابايت"),
            )

        text = extract_text_from_image(contents)
        return format_response(True, {"extracted_text": text}, "تم استخراج النص بنجاح")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.post("/qr")
async def qr_lookup(
    body: QRRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Look up a lesson by QR code."""
    try:
        lesson = db.query(Lesson).filter(Lesson.qr_code == body.qr_code).first()
        if not lesson:
            raise HTTPException(
                status_code=404,
                detail=format_response(False, None, "الدرس غير موجود"),
            )
        lesson_data = {
            "id": str(lesson.id),
            "title": lesson.title,
            "subject": lesson.subject,
            "grade_level": lesson.grade_level,
            "original_text": lesson.original_text,
            "audio_url": lesson.audio_url,
        }
        return format_response(True, lesson_data, "تم العثور على الدرس")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.post("/upload")
async def upload_image(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Upload an image file and extract Arabic text using OCR."""
    try:
        if file.content_type not in ALLOWED_TYPES:
            raise HTTPException(
                status_code=400,
                detail=format_response(False, None, "نوع الملف غير مدعوم. استخدم JPEG أو PNG"),
            )

        contents = await file.read()
        if len(contents) > MAX_FILE_SIZE:
            raise HTTPException(
                status_code=413,
                detail=format_response(False, None, "حجم الملف يتجاوز 10 ميجابايت"),
            )

        text = extract_text_from_image(contents)

        if current_user.role.value == "student" and current_user.student:
            achievement_service.record_reading(db, current_user.student.id)
            achievement_service.record_activity(db, current_user.student.id)

        return format_response(True, {"extracted_text": text}, "تم استخراج النص بنجاح")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))
