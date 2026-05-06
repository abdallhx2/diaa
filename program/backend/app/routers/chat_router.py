from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.services.chat_service import ask_question
from app.models.chat_message import ChatMessage
from app.models.lesson import Lesson
from app.models.user import User
from app.schemas.chat_schema import ChatRequest, ChatResponse, ChatHistoryItem
from app.middleware.auth_middleware import get_current_user
from app.utils.helpers import format_response

router = APIRouter()


@router.post("/ask")
async def ask(
    body: ChatRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Send a question to the AI assistant."""
    if current_user.role.value != "student" or not current_user.student:
        raise HTTPException(status_code=403, detail=format_response(False, None, "الوصول مقصور على الطلاب"))

    student_id = current_user.student.id

    try:
        # Validate lesson exists if lesson_id provided
        if body.lesson_id:
            lesson = db.query(Lesson).filter(Lesson.id == body.lesson_id).first()
            if not lesson:
                raise HTTPException(
                    status_code=404,
                    detail=format_response(False, None, "الدرس غير موجود"),
                )

        # Check message limit (20 messages per student per lesson)
        msg_count = (
            db.query(ChatMessage)
            .filter(
                ChatMessage.student_id == student_id,
                ChatMessage.lesson_id == body.lesson_id,
                ChatMessage.role == "user",
            )
            .count()
        )
        if msg_count >= 20:
            raise HTTPException(
                status_code=429,
                detail=format_response(False, None, "تجاوزت الحد الأقصى للرسائل (20 رسالة)"),
            )

        answer = ask_question(
            db=db,
            question=body.question,
            student_id=student_id,
            lesson_id=body.lesson_id,
        )

        return format_response(True, ChatResponse(answer=answer).model_dump(), "تم الإجابة")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.get("/history/{lesson_id}")
async def get_history(
    lesson_id: UUID,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get chat history for a specific lesson."""
    if current_user.role.value != "student" or not current_user.student:
        raise HTTPException(status_code=403, detail=format_response(False, None, "الوصول مقصور على الطلاب"))

    student_id = current_user.student.id

    try:
        messages = (
            db.query(ChatMessage)
            .filter(
                ChatMessage.student_id == student_id,
                ChatMessage.lesson_id == lesson_id,
            )
            .order_by(ChatMessage.created_at.asc())
            .all()
        )

        messages_list = []
        for m in messages:
            messages_list.append({
                "role": m.role,
                "content": m.content,
                "created_at": str(m.created_at),
            })

        return format_response(True, {"messages": messages_list}, "سجل المحادثة")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))
