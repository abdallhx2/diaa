# ============================================================
# File: utils/helpers.py
# Purpose: دوال مساعدة عامة — تُستخدم في جميع أنحاء التطبيق
# Owner: Shared — جميع أعضاء الفريق
# Branch: feature/backend-auth
# Week: Week 1 — أدوات مشتركة
# ============================================================

# --- Required Imports ---
# import uuid
# from datetime import datetime

# --- Implementation Steps ---

# Step 1: دالة generate_uuid() -> str
# - ولدي UUID فريد جديد
# - return str(uuid.uuid4())
# - تُستخدم لإنشاء معرفات فريدة للسجلات في قاعدة البيانات

# Step 2: دالة get_current_timestamp() -> datetime
# - ارجعي الوقت الحالي
# - return datetime.utcnow()
# - تُستخدم لتسجيل أوقات الإنشاء والتعديل

# Step 3: دالة format_response(success: bool, data: any, message: str) -> dict
# - ارجعي الـ response بالتنسيق الموحد:
# - return {
#       "success": success,    — True لو نجح، False لو فشل
#       "data": data,          — البيانات المطلوبة (أو None لو فشل)
#       "message": message     — رسالة توضيحية بالعربي
#   }
# - هذا التنسيق لازم يُستخدم في كل الـ responses

# --- Dependencies ---
# - لا يعتمد على ملفات أخرى (مستقل تماماً)

# --- Notes ---
# - format_response هي الدالة الأهم — تضمن توحيد شكل الـ response في كل API
# - الـ Standard Response Format:
#   {
#       "success": bool,   — هل العملية نجحت؟
#       "data": any,       — البيانات (object, list, أو None)
#       "message": str     — رسالة توضيحية بالعربي
#   }
# - مثال نجاح: format_response(True, {"user": {...}}, "تم تسجيل الدخول بنجاح")
# - مثال فشل: format_response(False, None, "التوكن غير صالح")
# - generate_uuid تُستخدم في كل الموديلات لإنشاء id فريد
