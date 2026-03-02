# ============================================================
# File: schemas/auth_schema.py
# Purpose: مخططات المصادقة — التحقق من بيانات تسجيل الدخول والتسجيل
# Owner: رنيم — API Developer
# Branch: feature/backend-routers
# Week: Week 2 — إعداد الـ schemas
# ============================================================

# --- Required Imports ---
# from pydantic import BaseModel, EmailStr
# from typing import Optional
# from uuid import UUID
# from datetime import datetime

# --- Implementation Steps ---

# Step 1: TokenVerifyRequest — طلب التحقق من التوكن
# - class TokenVerifyRequest(BaseModel):
#     - token: str  — توكن Firebase المراد التحقق منه

# Step 2: RegisterParentRequest — طلب تسجيل ولي أمر
# - class RegisterParentRequest(BaseModel):
#     - name: str           — اسم ولي الأمر
#     - email: EmailStr     — البريد الإلكتروني (يتحقق من الصيغة تلقائياً)
#     - password: str       — كلمة المرور (أقل شيء 6 أحرف)
#     - phone: Optional[str] = None  — رقم الهاتف (اختياري)

# Step 3: AddChildRequest — طلب إضافة طفل
# - class AddChildRequest(BaseModel):
#     - name: str           — اسم الطفل
#     - age: int            — العمر (بين 5 و 15)
#     - grade: str          — الصف الدراسي
#     - learning_level: str — مستوى التعلم (مبتدئ/متوسط/متقدم)

# Step 4: UserResponse — بيانات المستخدم في الـ response
# - class UserResponse(BaseModel):
#     - id: UUID
#     - name: str
#     - email: str
#     - role: str
#     - phone: Optional[str]
#     - created_at: datetime
#     - class Config:
#         - from_attributes = True  — (كان اسمه orm_mode في Pydantic v1)

# Step 5: LoginResponse — استجابة تسجيل الدخول
# - class LoginResponse(BaseModel):
#     - success: bool
#     - user: UserResponse
#     - token: str

# --- Dependencies ---
# - لا يعتمد على ملفات أخرى (schemas مستقلة)

# --- Notes ---
# - استخدمي EmailStr للتحقق التلقائي من صيغة البريد الإلكتروني
# - from_attributes = True يسمح بالتحويل المباشر من SQLAlchemy model
# - الـ standard response format يُستخدم في الراوتر مع format_response
# - كل الـ schemas تستخدم Pydantic v2 syntax
