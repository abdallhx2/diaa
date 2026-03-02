# ============================================================
# File: utils/image_processing.py
# Purpose: معالجة الصور — تحسين جودة الصور قبل OCR
# Owner: فرح — OCR Engineer
# Branch: feature/ai-ocr
# Week: Week 1 — أدوات معالجة الصور
# ============================================================

# --- Required Imports ---
# from PIL import Image, ImageEnhance, ImageFilter
# import numpy as np

# --- Implementation Steps ---

# Step 1: دالة enhance_contrast(image: Image) -> Image
# - حسّني تباين الصورة عشان النص يكون أوضح
# - enhancer = ImageEnhance.Contrast(image)
# - enhanced = enhancer.enhance(1.5)  — معامل التباين (1.0 = بدون تغيير, 1.5 = أوضح)
# - ارجعي enhanced
# - التباين العالي يساعد EasyOCR يميز الحروف من الخلفية

# Step 2: دالة remove_noise(image: Image) -> Image
# - أزيلي الضوضاء (noise) من الصورة
# - cleaned = image.filter(ImageFilter.MedianFilter(size=3))
# - أو استخدمي GaussianBlur بسيط:
#   - cleaned = image.filter(ImageFilter.GaussianBlur(radius=0.5))
# - ارجعي cleaned
# - إزالة الضوضاء تحسن دقة OCR خصوصاً للصور من الكاميرا

# Step 3: دالة convert_to_grayscale(image: Image) -> Image
# - حولي الصورة لتدرج الرمادي (grayscale)
# - gray = image.convert('L')
# - ارجعي gray
# - OCR يشتغل أفضل على صور grayscale

# Step 4: دالة resize_if_needed(image: Image, max_size: int = 2000) -> Image
# - تحققي من أبعاد الصورة:
#   - width, height = image.size
# - لو أي بعد أكبر من max_size:
#   - احسبي النسبة: ratio = max_size / max(width, height)
#   - new_size = (int(width * ratio), int(height * ratio))
#   - resized = image.resize(new_size, Image.LANCZOS)
#   - ارجعي resized
# - لو الصورة صغيرة كفاية — ارجعيها زي ما هي
# - تصغير الصور الكبيرة يحسن الأداء بدون ما يأثر كثير على الدقة

# --- Dependencies ---
# - Pillow (PIL) library
# - numpy library

# --- Notes ---
# - ترتيب المعالجة المقترح: grayscale → contrast → noise removal → resize
# - هذي الدوال تُستدعى من ocr_service.py قبل تمرير الصورة لـ EasyOCR
# - لا تبالغي في المعالجة — أحياناً الصورة الأصلية تكون كافية
# - MedianFilter(3) مناسب للضوضاء العادية، زيديه لـ 5 لو الضوضاء كثيرة
# - LANCZOS هو أفضل filter لتصغير الصور (يحافظ على الجودة)
