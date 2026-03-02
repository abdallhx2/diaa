# ============================================================
# File: schemas/admin_schema.py
# Purpose: مخططات لوحة تحكم المشرف — إحصائيات النظام والإعدادات
# Owner: رنيم — API Developer
# Branch: feature/backend-routers
# Week: Week 2 — إعداد الـ schemas
# ============================================================

# --- Required Imports ---
# from pydantic import BaseModel
# from typing import List, Optional, Dict
# from decimal import Decimal

# --- Implementation Steps ---

# Step 1: AdminDashboard — إحصائيات النظام للمشرف
# - class AdminDashboard(BaseModel):
#     - total_users: int               — إجمالي عدد المستخدمين
#     - active_users_7d: int           — المستخدمين النشطين آخر 7 أيام
#     - total_sessions_week: int       — إجمالي جلسات التعلم هذا الأسبوع
#     - total_sessions_month: int      — إجمالي جلسات التعلم هذا الشهر
#     - avg_response_time: Decimal     — متوسط وقت الاستجابة بالميلي ثانية (من system_logs)

# Step 2: SystemSettings — إعدادات النظام
# - class SystemSettings(BaseModel):
#     - language: str = "ar"           — اللغة الافتراضية
#     - available_content: List[str]   — المحتوى المتاح (مثل: ["لغة عربية", "رياضيات"])
#     - notifications: Dict[str, bool] — إعدادات الإشعارات، مثال:
#       # {
#       #   "email_notifications": True,
#       #   "push_notifications": True,
#       #   "parent_weekly_report": True
#       # }

# --- Dependencies ---
# - لا يعتمد على ملفات أخرى (schemas مستقلة)

# --- Notes ---
# - AdminDashboard يُستخدم في GET /api/admin/dashboard
# - SystemSettings يُستخدم في GET/PUT /api/admin/settings
# - active_users_7d يتحسب من learning_sessions اللي started_at آخر 7 أيام
# - avg_response_time يتحسب من details.response_time_ms في system_logs
