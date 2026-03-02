# ============================================================
# File: Dockerfile
# Purpose: إعداد Docker للنشر على Railway
# Owner: مشاعل — Backend Lead
# Branch: feature/backend-auth
# Week: Week 3 — النشر والتجهيز
# ============================================================

# Step 1: استخدام Python 3.11 slim كـ base image (أخف وأسرع)
FROM python:3.11-slim

# Step 2: تعيين مجلد العمل داخل الـ container
WORKDIR /app

# Step 3: تثبيت الحزم اللازمة للنظام (لـ psycopg2 و OpenCV وغيرها)
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Step 4: نسخ ملف المتطلبات أولاً (عشان Docker يستفيد من الكاش)
COPY requirements.txt .

# Step 5: تثبيت المتطلبات من requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Step 6: نسخ كل ملفات التطبيق
COPY . .

# Step 7: فتح البورت 8000 (البورت الافتراضي لـ FastAPI)
EXPOSE 8000

# Step 8: تشغيل التطبيق باستخدام uvicorn
# - host 0.0.0.0 عشان يكون متاح من خارج الـ container
# - port يُقرأ من متغير البيئة PORT (Railway يحدده تلقائياً)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

# --- Notes ---
# - python:3.11-slim أخف من python:3.11 العادية (حجم أقل)
# - نسخ requirements.txt أولاً يستفيد من Docker layer caching
# - لو تغيرت requirements.txt فقط — يعيد تثبيت الحزم بس
# - لو تغير الكود فقط — ما يعيد تثبيت الحزم (أسرع)
# - Railway يوفر متغير PORT تلقائياً
# - للبناء المحلي: docker build -t edu-backend .
# - للتشغيل المحلي: docker run -p 8000:8000 --env-file .env edu-backend
