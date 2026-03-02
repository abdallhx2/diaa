# ============================================================
# File: database.py
# Purpose: الاتصال بقاعدة البيانات PostgreSQL باستخدام SQLAlchemy
# Owner: فاطمة — Database Lead
# Branch: feature/backend-models
# Week: Week 1 — إعداد قاعدة البيانات والاتصال
# ============================================================

# --- Required Imports ---
# from sqlalchemy import create_engine
# from sqlalchemy.orm import sessionmaker, declarative_base
# from app.config import settings

# --- Implementation Steps ---

# Step 1: قراءة DATABASE_URL من الإعدادات
# - SQLALCHEMY_DATABASE_URL = settings.DATABASE_URL

# Step 2: إنشاء engine للاتصال بالقاعدة
# - engine = create_engine(SQLALCHEMY_DATABASE_URL)
# - لو تستخدمين async، استخدمي create_async_engine مع asyncpg

# Step 3: إنشاء SessionLocal
# - SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
# - هذا الكلاس يُستخدم لإنشاء sessions جديدة مع قاعدة البيانات

# Step 4: إنشاء Base class
# - Base = declarative_base()
# - جميع الموديلات ترث من هذا الكلاس

# Step 5: إنشاء dependency function للـ FastAPI
# - def get_db():
# -     db = SessionLocal()
# -     try:
# -         yield db
# -     finally:
# -         db.close()
# - هذي الدالة تُستخدم كـ Depends() في الراوترات

# --- Dependencies ---
# - app/config.py (للحصول على DATABASE_URL)

# --- Notes ---
# - الـ Base class يُستورد في جميع ملفات الموديلات
# - get_db تضمن إن الـ session ينغلق حتى لو صار خطأ
# - DATABASE_URL format: postgresql://user:password@host:port/dbname
# - في Railway، الـ DATABASE_URL يتوفر تلقائياً كـ environment variable
