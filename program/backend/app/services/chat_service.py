from sqlalchemy.orm import Session
from app.config import settings
from app.models.chat_message import ChatMessage
from app.models.lesson import Lesson
from app.services.openrouter_client import client

SYSTEM_PROMPT = """أنت مساعد تعليمي ذكي للأطفال في المرحلة الابتدائية.
أجب فقط بناءً على محتوى الدرس المقدم.
إذا كان السؤال خارج محتوى الدرس، قل: "هذا السؤال خارج محتوى الدرس الحالي."
استخدم لغة بسيطة مناسبة للأطفال.
أجب بالعربية دائماً.
اجعل إجابتك مختصرة في ٣-٤ جمل كحد أقصى.
"""


def validate_question(question: str) -> bool:
    """Validate a question: must be between 3 and 500 characters."""
    if not question or not isinstance(question, str):
        return False
    stripped = question.strip()
    return 3 <= len(stripped) <= 500


def get_answer(question: str, lesson_text: str) -> str:
    """Call OpenRouter with question constrained to lesson content, return answer string.
    On error returns Arabic error message (does not raise).
    """
    if settings.MOCK_AI:
        from app.services.mock_services import MockOpenAI
        return MockOpenAI.get_answer(question, lesson_text)

    try:
        system_content = SYSTEM_PROMPT
        if lesson_text:
            system_content += f"\n\nمحتوى الدرس:\n{lesson_text}"

        messages = [
            {"role": "system", "content": system_content},
            {"role": "user", "content": question},
        ]

        response = client.chat.completions.create(
            model=settings.CHAT_MODEL,
            messages=messages,
            max_tokens=200,
            temperature=0.5,
        )

        return response.choices[0].message.content

    except Exception:
        return "عذراً، حدث خطأ أثناء معالجة سؤالك. حاول مرة أخرى."


def ask_question(
    db: Session,
    question: str,
    student_id,
    lesson_id=None,
) -> str:
    """Send a question to AI constrained to lesson content, save chat messages, return answer."""
    if not validate_question(question):
        return "السؤال يجب أن يكون بين ٣ و ٥٠٠ حرف."

    try:
        lesson_text = ""
        if lesson_id:
            lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
            if lesson:
                lesson_text = lesson.original_text

        answer = get_answer(question, lesson_text)

        # Save user message (role/content schema)
        user_msg = ChatMessage(
            student_id=student_id,
            lesson_id=lesson_id,
            role="user",
            content=question,
        )
        db.add(user_msg)

        # Save assistant response (role/content schema)
        assistant_msg = ChatMessage(
            student_id=student_id,
            lesson_id=lesson_id,
            role="assistant",
            content=answer,
        )
        db.add(assistant_msg)
        db.commit()

        return answer

    except Exception as e:
        db.rollback()
        return "عذراً، حدث خطأ في خدمة المحادثة. حاول مرة أخرى."
