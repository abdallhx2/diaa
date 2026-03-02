# ============================================================
# File: models/parent.py
# Purpose: موديل ولي الأمر — جدول parents في قاعدة البيانات
# Owner: فاطمة — Database Lead
# Branch: feature/backend-models
# Week: Week 1 — إنشاء جداول قاعدة البيانات
# ============================================================

# --- Required Imports ---
# import uuid
# from sqlalchemy import Column, Integer, ForeignKey
# from sqlalchemy.dialects.postgresql import UUID
# from sqlalchemy.orm import relationship
# from app.database import Base

# --- Implementation Steps ---

# Step 1: إنشاء كلاس Parent يرث من Base
# - __tablename__ = "parents"

# Step 2: تعريف الأعمدة (Columns)
# - id: UUID — Primary Key, default=uuid.uuid4
# - user_id: UUID — ForeignKey("users.id"), Unique, Not Null — ربط مع جدول المستخدمين
# - num_children: INTEGER — Default=0 — عدد الأبناء المسجلين

# Step 3: تعريف العلاقات (Relationships)
# - user = relationship("User", back_populates="parent")               — علاقة 1:1 مع User
# - children = relationship("Student", back_populates="parent")        — علاقة 1:N مع الطلاب

# --- Dependencies ---
# - app/database.py (Base class)
# - app/models/user.py (User model — FK)

# --- Notes ---
# - num_children يتحدث تلقائياً عند إضافة أو حذف طالب
# - ولي الأمر يقدر يشوف تقارير أبنائه فقط
# - user_id يكون Unique عشان كل مستخدم يكون عنده سجل ولي أمر واحد فقط
