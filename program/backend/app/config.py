# ============================================================
# File: config.py
# Purpose: إعدادات التطبيق باستخدام pydantic-settings — قراءة المتغيرات من .env
# Owner: مشاعل — Backend Lead
# Branch: feature/backend-auth
# Week: Week 1 — إعداد الهيكل الأساسي للتطبيق
# ============================================================

# --- Required Imports ---
# from pydantic_settings import BaseSettings
# from typing import List

# --- Implementation Steps ---

# Step 1: إنشاء كلاس Settings يرث من BaseSettings
# - class Settings(BaseSettings):

# Step 2: تعريف جميع الحقول المطلوبة
# - DATABASE_URL: str                    — رابط قاعدة البيانات PostgreSQL
# - FIREBASE_CREDENTIALS_PATH: str       — مسار ملف credentials لـ Firebase
# - AZURE_SPEECH_KEY: str                — مفتاح Azure Speech Service
# - AZURE_SPEECH_REGION: str             — منطقة Azure (مثل: eastus)
# - OPENAI_API_KEY: str                  — مفتاح OpenAI API
# - OPENAI_MODEL: str = "gpt-4o-mini"   — نموذج OpenAI المستخدم (القيمة الافتراضية)
# - FIREBASE_STORAGE_BUCKET: str         — اسم bucket في Firebase Storage
# - APP_ENV: str = "development"         — بيئة التطبيق (development/production)
# - CORS_ORIGINS: List[str]              — قائمة الـ origins المسموح بها

# Step 3: إعداد Config الداخلي
# - class Config:
# -     env_file = ".env"
# -     env_file_encoding = "utf-8"

# Step 4: إنشاء instance من Settings
# - settings = Settings()
# - هذا الـ instance يُستخدم في جميع أنحاء التطبيق

# --- Dependencies ---
# - ملف .env في root المشروع (backend/.env)

# --- Notes ---
# - لا تحفظي ملف .env في Git — أضيفيه في .gitignore
# - كل متغير لازم يكون موجود في .env وإلا يطلع خطأ
# - CORS_ORIGINS ممكن تكون comma-separated في .env مثل: http://localhost:3000,http://localhost:5173
# - APP_ENV يتحكم في سلوك التطبيق (مثلاً: debug mode في development)
# - OPENAI_MODEL القيمة الافتراضية gpt-4o-mini عشان التكلفة أقل
