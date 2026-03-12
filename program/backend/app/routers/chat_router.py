from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.orm import Session
from app.database import get_db
from app.services.chat_service import ask_question
from app.models.chat_message import ChatMessage
from app.models.lesson import Lesson
from app.utils.helpers import format_response
from pydantic import BaseModel
from typing import Optional
import uuid

router = APIRouter()


class ChatRequest(BaseModel):
    question: str
    lesson_id: str


@router.post("/ask")
def ask(body: ChatRequest, request: Request, db: Session = Depends(get_db)):
    user = request.state.user

    lesson = db.query(Lesson).filter(Lesson.id == uuid.UUID(body.lesson_id)).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="الدرس غير موجود")

    messages_count = db.query(ChatMessage).filter_by(
        student_id=user.student.id,
        lesson_id=lesson.id
    ).count()

    if messages_count >= 20:
        raise HTTPException(status_code=429, detail="تجاوزتِ الحد الأقصى للرسائل في هذا الدرس")

    answer = ask_question(body.question, lesson.original_text)

    message = ChatMessage(
        student_id=user.student.id,
        lesson_id=lesson.id,
        user_message=body.question,
        bot_response=answer,
    )
    db.add(message)
    db.commit()

    return format_response(True, {"answer": answer, "audio_url": None}, "تم الإجابة")


@router.get("/history/{lesson_id}")
def get_history(lesson_id: str, request: Request, db: Session = Depends(get_db)):
    user = request.state.user

    messages = db.query(ChatMessage).filter_by(
        student_id=user.student.id,
        lesson_id=uuid.UUID(lesson_id)
    ).order_by(ChatMessage.created_at.asc()).all()

    messages_list = [
        {
            "id": str(m.id),
            "user_message": m.user_message,
            "bot_response": m.bot_response,
            "created_at": str(m.created_at),
        }
        for m in messages
    ]

    return format_response(True, {"messages": messages_list}, "سجل المحادثة")