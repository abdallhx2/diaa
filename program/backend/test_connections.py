"""
============================================================
اختبار الاتصال بالبوابات الخارجية — Connection Test
============================================================
شغّل هذا الملف للتأكد من أن جميع الخدمات متصلة بشكل صحيح
Run: python test_connections.py
============================================================
"""

import sys

# ��لوان الطباعة
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
        from firebase_admin import credentials
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
# 3. اختبار OpenRouter — Chat (المحادثة الذكية)
# ─────────────────────────────────────────────
def test_openrouter_chat():
    header("3. OpenRouter Chat (المحادثة الذكية)")
    try:
        from openai import OpenAI
        import os
        from dotenv import load_dotenv
        load_dotenv()

        api_key = os.getenv("OPENROUTER_API_KEY")
        if not api_key:
            fail("OPENROUTER_API_KEY غير موجود في .env")
            return False

        model = os.getenv("CHAT_MODEL", "openai/gpt-4o-mini")

        client = OpenAI(
            base_url="https://openrouter.ai/api/v1",
            api_key=api_key,
        )
        response = client.chat.completions.create(
            model=model,
            messages=[{"role": "user", "content": "قل: مرحبا"}],
            max_tokens=10,
        )
        answer = response.choices[0].message.content
        ok(f"Chat يعمل (النموذج: {model}) — الرد: {answer}")
        return True
    except Exception as e:
        fail("فشل الاتصال بـ OpenRouter Chat", str(e))
        return False


# ─────────────────────────────────────────────
# 4. اختبار OpenRouter — Vision/OCR (استخراج النص)
# ─────────────────────────────────────────────
def test_openrouter_vision():
    header("4. OpenRouter Vision/OCR (استخراج النص)")
    try:
        from openai import OpenAI
        import os
        from dotenv import load_dotenv
        load_dotenv()

        api_key = os.getenv("OPENROUTER_API_KEY")
        if not api_key:
            fail("OPENROUTER_API_KEY غير موجود في .env")
            return False

        model = os.getenv("VISION_MODEL", "openai/gpt-4o-mini")

        client = OpenAI(
            base_url="https://openrouter.ai/api/v1",
            api_key=api_key,
        )

        # Test with a simple text description (no actual image needed for connectivity test)
        response = client.chat.completions.create(
            model=model,
            messages=[{"role": "user", "content": "قل: اختبار"}],
            max_tokens=10,
        )
        ok(f"Vision model متاح (النموذج: {model})")
        return True
    except Exception as e:
        fail("فشل الاتصال بـ OpenRouter Vision", str(e))
        return False


# ─────────────────────────────────────────────
# 5. اختبار OpenRouter — TTS (تحويل النص لصوت)
# ─────────────────────────────────────────────
def test_openrouter_tts():
    header("5. OpenRouter TTS (تحويل النص لصوت)")
    try:
        import httpx
        import json
        import base64
        import os
        from dotenv import load_dotenv
        load_dotenv()

        api_key = os.getenv("OPENROUTER_API_KEY")
        if not api_key:
            fail("OPENROUTER_API_KEY غير موجود في .env")
            return False

        model = os.getenv("TTS_MODEL", "openai/gpt-audio-mini")
        voice = os.getenv("TTS_VOICE", "alloy")

        audio_chunks = []
        with httpx.stream(
            "POST",
            "https://openrouter.ai/api/v1/chat/completions",
            headers={
                "Authorization": f"Bearer {api_key}",
                "HTTP-Referer": "https://edu-smart.app",
                "Content-Type": "application/json",
            },
            json={
                "model": model,
                "modalities": ["text", "audio"],
                "audio": {"voice": voice, "format": "pcm16"},
                "messages": [{"role": "user", "content": "Say: hello"}],
                "stream": True,
            },
            timeout=30,
        ) as response:
            for line in response.iter_lines():
                if line.startswith("data: ") and "DONE" not in line:
                    try:
                        chunk = json.loads(line[6:])
                        choices = chunk.get("choices", [])
                        if choices:
                            delta = choices[0].get("delta", {})
                            audio = delta.get("audio", {})
                            if audio and audio.get("data"):
                                audio_chunks.append(audio["data"])
                    except (json.JSONDecodeError, KeyError):
                        pass

        if audio_chunks:
            full_b64 = "".join(audio_chunks)
            audio_bytes = base64.b64decode(full_b64)
            ok(f"TTS يعمل (النموذج: {model}, الصوت: {voice}) — {len(audio_bytes)} bytes")
            return True
        else:
            fail("TTS لم يرجع بيانات صوتية")
            return False
    except Exception as e:
        fail("فشل الاتصال بـ OpenRouter TTS", str(e))
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
    results["OpenRouter Chat"] = test_openrouter_chat()
    results["OpenRouter Vision"] = test_openrouter_vision()
    results["OpenRouter TTS"] = test_openrouter_tts()
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
