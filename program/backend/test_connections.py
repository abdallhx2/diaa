"""
============================================================
اختبار الاتصال بالبوابات الخارجية — Connection Test
============================================================
شغّل هذا الملف للتأكد من أن جميع الخدمات متصلة بشكل صحيح
Run: python test_connections.py
============================================================
"""

import asyncio
import sys

# ألوان الطباعة
GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
RESET = "\033[0m"
BOLD = "\033[1m"

def ok(msg):
    print(f"  {GREEN}✔ {msg}{RESET}")

def fail(msg, err=""):
    print(f"  {RED}✘ {msg}{RESET}")
    if err:
        print(f"    {RED}↳ {err}{RESET}")

def warn(msg):
    print(f"  {YELLOW}⚠ {msg}{RESET}")

def header(title):
    print(f"\n{BOLD}{'='*50}")
    print(f"  {title}")
    print(f"{'='*50}{RESET}")


# ─────────────────────────────────────────────
# 1. اختبار PostgreSQL
# ─────────────────────────────────────────────
def test_postgresql():
    header("1. PostgreSQL Database")
    try:
        from sqlalchemy import create_engine, text
        import os
        from dotenv import load_dotenv
        load_dotenv()

        db_url = os.getenv("DATABASE_URL")
        if not db_url:
            fail("DATABASE_URL غير موجود في .env")
            return False

        engine = create_engine(db_url)
        with engine.connect() as conn:
            result = conn.execute(text("SELECT 1"))
            result.fetchone()
        ok("متصل بقاعدة البيانات بنجاح")
        return True
    except Exception as e:
        fail("فشل الاتصال بقاعدة البيانات", str(e))
        return False


# ─────────────────────────────────────────────
# 2. اختبار Firebase Admin SDK
# ─────────────────────────────────────────────
def test_firebase():
    header("2. Firebase Admin SDK")
    try:
        import firebase_admin
        from firebase_admin import credentials, auth
        import os
        from dotenv import load_dotenv
        load_dotenv()

        cred_path = os.getenv("FIREBASE_CREDENTIALS_PATH")
        if not cred_path:
            fail("FIREBASE_CREDENTIALS_PATH غير موجود في .env")
            return False

        if not os.path.exists(cred_path):
            fail(f"ملف credentials غير موجود: {cred_path}")
            return False

        if not firebase_admin._apps:
            cred = credentials.Certificate(cred_path)
            firebase_admin.initialize_app(cred)

        ok("Firebase Admin SDK يعمل بنجاح")
        return True
    except Exception as e:
        fail("فشل تهيئة Firebase", str(e))
        return False


# ─────────────────────────────────────────────
# 3. اختبار EasyOCR
# ─────────────────────────────────────────────
def test_easyocr():
    header("3. EasyOCR (استخراج النص)")
    try:
        import easyocr
        reader = easyocr.Reader(['ar'], gpu=False, verbose=False)
        ok("EasyOCR جاهز (اللغة العربية)")
        return True
    except Exception as e:
        fail("فشل تحميل EasyOCR", str(e))
        return False


# ─────────────────────────────────────────────
# 4. اختبار Azure TTS
# ─────────────────────────────────────────────
def test_azure_tts():
    header("4. Azure TTS (تحويل النص لصوت)")
    try:
        import azure.cognitiveservices.speech as speechsdk
        import os
        from dotenv import load_dotenv
        load_dotenv()

        key = os.getenv("AZURE_SPEECH_KEY")
        region = os.getenv("AZURE_SPEECH_REGION")

        if not key or not region:
            fail("AZURE_SPEECH_KEY أو AZURE_SPEECH_REGION غير موجود في .env")
            return False

        config = speechsdk.SpeechConfig(subscription=key, region=region)
        config.speech_synthesis_voice_name = "ar-SA-HamedNeural"
        ok(f"Azure TTS مُعد (المنطقة: {region})")
        return True
    except Exception as e:
        fail("فشل إعداد Azure TTS", str(e))
        return False


# ─────────────────────────────────────────────
# 5. اختبار OpenAI
# ─────────────────────────────────────────────
def test_openai():
    header("5. OpenAI GPT-4o-mini (الدردشة الذكية)")
    try:
        from openai import OpenAI
        import os
        from dotenv import load_dotenv
        load_dotenv()

        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            fail("OPENAI_API_KEY غير موجود في .env")
            return False

        client = OpenAI(api_key=api_key)
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role": "user", "content": "قل: مرحبا"}],
            max_tokens=10,
        )
        answer = response.choices[0].message.content
        ok(f"OpenAI يعمل — الرد: {answer}")
        return True
    except Exception as e:
        fail("فشل الاتصال بـ OpenAI", str(e))
        return False


# ─────────────────────────────────────────────
# 6. اختبار FastAPI Server
# ─────────────────────────────────────────────
def test_fastapi():
    header("6. FastAPI Server")
    try:
        import httpx
        r = httpx.get("http://localhost:8000/", timeout=5)
        if r.status_code == 200:
            ok("FastAPI يعمل على المنفذ 8000")
            return True
        else:
            warn(f"FastAPI يستجيب لكن بحالة: {r.status_code}")
            return True
    except Exception:
        warn("FastAPI غير مشغّل — شغّله أولاً: uvicorn app.main:app --reload")
        return False


# ─────────────────────────────────────────────
# التشغيل
# ─────────────────────────────────────────────
if __name__ == "__main__":
    print(f"\n{BOLD}🔍 اختبار اتصال Edu Smart Assistant — Backend{RESET}")
    print(f"{'─'*50}")

    results = {}
    results["PostgreSQL"] = test_postgresql()
    results["Firebase"] = test_firebase()
    results["EasyOCR"] = test_easyocr()
    results["Azure TTS"] = test_azure_tts()
    results["OpenAI"] = test_openai()
    results["FastAPI"] = test_fastapi()

    # ─── الملخص ───
    header("📊 الملخص")
    passed = sum(1 for v in results.values() if v)
    total = len(results)

    for name, status in results.items():
        icon = f"{GREEN}✔{RESET}" if status else f"{RED}✘{RESET}"
        print(f"  {icon}  {name}")

    print(f"\n  النتيجة: {passed}/{total} ناجح")

    if passed == total:
        print(f"\n  {GREEN}{BOLD}🎉 جميع الخدمات متصلة بنجاح!{RESET}\n")
    else:
        print(f"\n  {YELLOW}{BOLD}⚠ بعض الخدمات تحتاج إعداد — راجع الأخطاء أعلاه{RESET}\n")
        sys.exit(1)
