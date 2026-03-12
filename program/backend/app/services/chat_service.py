from google import genai
from google.genai import types
from app.config import settings

client = genai.Client(api_key=settings.GEMINI_API_KEY)

SYSTEM_PROMPT = """أنت مساعد تعليمي ذكي للأطفال.
أجب فقط بناءً على محتوى الدرس التالي.
إذا كان السؤال خارج محتوى الدرس، قل: "هذا السؤال خارج محتوى الدرس الحالي."
استخدم لغة بسيطة مناسبة للأطفال.
أجب بالعربية دائماً."""


def ask_question(question: str, lesson_text: str) -> str:
    if not question or not question.strip():
        raise ValueError("السؤال لا يمكن أن يكون فارغاً")

    prompt = f"""{SYSTEM_PROMPT}

محتوى الدرس:
{lesson_text}

سؤال الطالب: {question}"""

    try:
        response = client.models.generate_content(
            model="gemini-2.0-flash",
            contents=prompt,
            config=types.GenerateContentConfig(
                max_output_tokens=500,
                temperature=0.7,
            )
        )
        return response.text
    except Exception as e:
        raise Exception(f"فشل في الحصول على إجابة: {str(e)}")