# ============================================================
# File: services/ocr_service.py
# Purpose: خدمة التعرف على النص العربي — EasyOCR service لاستخراج النص من الصور
# Owner: فرح — OCR Engineer
# Branch: feature/ai-ocr
# Week: Week 1-2 — بناء محرك OCR للنص العربي
# ============================================================

# --- Required Imports ---
# import easyocr
# from PIL import Image
# import io
# import numpy as np
# from app.utils.image_processing import enhance_contrast, remove_noise, convert_to_grayscale, resize_if_needed

# --- Implementation Steps ---

# Step 1: تهيئة EasyOCR Reader عند بدء التطبيق
# - reader = easyocr.Reader(['ar'])
# - ملاحظة: التحميل يتم في main.py startup event، وتقدرين توصلين للـ reader من app.state
# - بديل: حمليه هنا كـ global variable (يتحمل مرة واحدة عند أول import)
# - اللغة المدعومة: العربية ['ar']
# - ممكن تضيفين الإنجليزية أيضاً: ['ar', 'en']

# Step 2: دالة extract_text_from_image(image_bytes: bytes) -> str
# - حولي الـ bytes لـ PIL Image:
#   - image = Image.open(io.BytesIO(image_bytes))
# - طبقي معالجة الصورة (image preprocessing):
#   - image = convert_to_grayscale(image)     — تحويل لتدرج الرمادي
#   - image = enhance_contrast(image)          — تحسين التباين
#   - image = remove_noise(image)              — إزالة الضوضاء
#   - image = resize_if_needed(image, 2000)    — تصغير لو الصورة كبيرة جداً
# - حولي لـ numpy array:
#   - image_array = np.array(image)
# - استدعي EasyOCR:
#   - results = reader.readtext(image_array)
# - results يرجع list of tuples: [(bbox, text, confidence), ...]

# Step 3: ترتيب ودمج النصوص
# - رتبي النتائج حسب الموقع (من أعلى لأسفل، من يمين لشمال للعربي)
# - ادمجي النصوص مع مسافات:
#   - extracted_text = " ".join([result[1] for result in results])
# - نظفي النص: أزيلي المسافات الزائدة

# Step 4: التعامل مع الأخطاء
# - لو الصورة فاضية أو ما فيها نص — ارجعي string فاضي
# - لو صار خطأ في EasyOCR — ارمي Exception واضح
# - سجلي الأخطاء في الـ log

# --- Dependencies ---
# - app/utils/image_processing.py (دوال معالجة الصور)
# - easyocr library
# - Pillow (PIL) library
# - numpy library

# --- Notes ---
# - الهدف: دقة 85% أو أعلى في استخراج النص العربي
# - الأداء المطلوب: أقل من 5 ثواني لكل صورة
# - EasyOCR يحتاج GPU لأداء أفضل (لكن يشتغل على CPU أيضاً)
# - معالجة الصورة (preprocessing) تحسن الدقة بشكل ملحوظ
# - لو الصورة كبيرة جداً (أكثر من 2000px) — صغريها عشان الأداء
