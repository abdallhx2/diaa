# ============================================================
# File: models/user.py
# Purpose: موديل المستخدم الأساسي — جدول users في قاعدة البيانات
# Owner: فاطمة — Database Lead
# Branch: feature/backend-models
# Week: Week 1 — إنشاء جداول قاعدة البيانات
# ============================================================

# --- Required Imports ---
# import uuid
# from sqlalchemy import Column, String, Boolean, DateTime, Enum as SQLEnum
# from sqlalchemy.dialects.postgresql import UUID
# from sqlalchemy.orm import relationship
# from sqlalchemy.sql import func
# from app.database import Base

# --- Implementation Steps ---

# Step 1: تعريف الـ Enum للأدوار
# - أنشئي Enum بالقيم: 'student', 'parent', 'admin'
# - يُستخدم في عمود role

# Step 2: إنشاء كلاس User يرث من Base
# - __tablename__ = "users"

# Step 3: تعريف الأعمدة (Columns)
# - id: UUID — Primary Key, default=uuid.uuid4
# - firebase_uid: VARCHAR — Unique, Not Null — معرف Firebase الفريد
# - role: ENUM('student', 'parent', 'admin') — Not Null — دور المستخدم
# - name: VARCHAR(100) — Not Null — اسم المستخدم
# - email: VARCHAR(150) — Unique — البريد الإلكتروني
# - phone: VARCHAR(20) — Nullable — رقم الهاتف
# - created_at: TIMESTAMP — Default=now() — تاريخ الإنشاء
# - is_active: BOOLEAN — Default=True — حالة الحساب

# Step 4: تعريف العلاقات (Relationships)
# - student = relationship("Student", back_populates="user", uselist=False)  — علاقة 1:1
# - parent = relationship("Parent", back_populates="user", uselist=False)    — علاقة 1:1
# - admin = relationship("Admin", back_populates="user", uselist=False)      — علاقة 1:1

# --- Dependencies ---
# - app/database.py (Base class)

# --- Schema Fields (للربط مع auth_schema.py) ---
# - UserResponse: id, name, email, role, phone, created_at

# --- Notes ---
# - firebase_uid يجي من Firebase Authentication بعد تسجيل الدخول
# - uselist=False في العلاقات يعني علاقة واحد لواحد
# - الـ UUID يُنشأ تلقائياً باستخدام uuid.uuid4
# - created_at يتعبى تلقائياً بالوقت الحالي عند الإنشاء
