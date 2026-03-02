# ============================================================
# File: services/storage_service.py
# Purpose: خدمة التخزين — Firebase Storage لرفع وإدارة الملفات الصوتية
# Owner: ريناد — TTS Engineer
# Branch: feature/ai-tts
# Week: Week 2 — ربط التخزين السحابي
# ============================================================

# --- Required Imports ---
# import firebase_admin
# from firebase_admin import storage
# from app.config import settings

# --- Implementation Steps ---

# Step 1: تهيئة Firebase Admin SDK (لو ما تهيأ قبل)
# - تحققي إن Firebase مهيأ:
#   - if not firebase_admin._apps:
#       cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
#       firebase_admin.initialize_app(cred, {'storageBucket': settings.FIREBASE_STORAGE_BUCKET})
# - أو استخدمي الـ app الموجود من auth_service

# Step 2: دالة upload_audio(audio_bytes: bytes, filename: str) -> str
# - خذي reference للـ bucket:
#   - bucket = storage.bucket()
# - أنشئي blob بالمسار:
#   - blob = bucket.blob(f"audio/{filename}")
# - ارفعي الملف:
#   - blob.upload_from_string(audio_bytes, content_type="audio/mpeg")
# - اجعلي الملف عام (public):
#   - blob.make_public()
# - ارجعي الرابط العام:
#   - return blob.public_url

# Step 3: دالة get_file_url(path: str) -> str | None
# - خذي reference للـ bucket:
#   - bucket = storage.bucket()
# - تحققي لو الملف موجود:
#   - blob = bucket.blob(path)
#   - if blob.exists():
#       return blob.public_url
#   - else:
#       return None
# - تُستخدم للتحقق من الكاش في tts_service

# Step 4: دالة delete_file(path: str) -> bool
# - خذي reference للـ bucket:
#   - bucket = storage.bucket()
# - احذفي الملف:
#   - blob = bucket.blob(path)
#   - blob.delete()
# - ارجعي True لو نجح، False لو فشل

# --- Dependencies ---
# - app/config.py (settings — Firebase credentials + bucket name)
# - firebase-admin library
# - google-cloud-storage library

# --- Notes ---
# - Firebase Admin SDK لازم يتهيأ مرة واحدة فقط في التطبيق
# - الملفات الصوتية تُخزن في مجلد audio/ داخل bucket
# - make_public() يخلي الملف متاح بدون مصادقة (مناسب للصوتيات)
# - لو تبين أمان أكثر — استخدمي signed URLs بدل public URLs
# - filename عادةً يكون hash للنص + .mp3 (مثل: abc123.mp3)
