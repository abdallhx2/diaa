# ============================================================
# File: services/chat_service.py
# Purpose: خدمة المحادثة الذكية — OpenAI GPT للإجابة على أسئلة الطلاب
# Owner: فدوه — AI Chat + Quiz Logic
# Branch: feature/ai-chat
# Week: Week 2 — بناء المساعد الذكي
# ============================================================

# --- Required Imports ---
# from openai import OpenAI
# from app.config import settings

# --- Implementation Steps ---

# Step 1: تهيئة OpenAI Client
# - client = OpenAI(api_key=settings.OPENAI_API_KEY)

# Step 2: تعريف الـ System Prompt
# - SYSTEM_PROMPT = """
#   أنت مساعد تعليمي ذكي للأطفال.
#   أجب فقط بناءً على محتوى الدرس التالي.
#   إذا كان السؤال خارج محتوى الدرس، قل: "هذا السؤال خارج محتوى الدرس الحالي."
#   استخدم لغة بسيطة مناسبة للأطفال.
#   أجب بالعربية دائماً.
#   """

# Step 3: دالة ask_question(question: str, lesson_text: str) -> str
# - تحققي إن السؤال مو فاضي
# - ابني الـ messages:
#   - messages = [
#       {"role": "system", "content": SYSTEM_PROMPT + f"\n\nمحتوى الدرس:\n{lesson_text}"},
#       {"role": "user", "content": question}
#   ]
# - أرسلي لـ OpenAI:
#   - response = client.chat.completions.create(
#       model=settings.OPENAI_MODEL,  — (gpt-4o-mini)
#       messages=messages,
#       max_tokens=500,
#       temperature=0.7
#   )
# - استخرجي الرد:
#   - answer = response.choices[0].message.content
# - ارجعي answer

# --- Dependencies ---
# - app/config.py (settings — OpenAI API key + model)
# - openai library

# --- Notes ---
# - النموذج المستخدم: gpt-4o-mini (أرخص وأسرع، كافي للأطفال)
# - temperature=0.7 يعطي إجابات متنوعة بس ما تكون عشوائية
# - max_tokens=500 يحد من طول الإجابة (مناسب للأطفال)
# - الـ System Prompt يضمن:
#   1) الإجابة من محتوى الدرس فقط
#   2) رفض الأسئلة خارج المحتوى
#   3) لغة بسيطة مناسبة للأطفال
#   4) الرد بالعربية دائماً
# - استخدمي try/except عشان تعاملين أخطاء OpenAI (rate limit, timeout, ...)
# - الحد الأقصى: 20 رسالة لكل جلسة (يُتحقق منه في chat_router)
