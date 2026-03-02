# ============================================================
# File: middleware/logging_middleware.py
# Purpose: تسجيل جميع الطلبات الواردة — Request logging middleware
# Owner: مشاعل — Backend Lead
# Branch: feature/backend-auth
# Week: Week 3 — تحسينات وأدوات المراقبة
# ============================================================

# --- Required Imports ---
# import time
# from fastapi import Request
# from starlette.middleware.base import BaseHTTPMiddleware
# from app.database import SessionLocal
# from app.models.system_log import SystemLog
# from app.utils.helpers import generate_uuid, get_current_timestamp

# --- Implementation Steps ---

# Step 1: إنشاء كلاس LoggingMiddleware يرث من BaseHTTPMiddleware
# - class LoggingMiddleware(BaseHTTPMiddleware):

# Step 2: في دالة dispatch(self, request, call_next):

# Step 3: تسجيل بيانات الطلب
# - method = request.method                    — نوع الطلب (GET, POST, ...)
# - path = request.url.path                    — مسار الطلب
# - start_time = time.time()                   — وقت بداية المعالجة

# Step 4: تمرير الطلب وقياس وقت الاستجابة
# - response = await call_next(request)
# - response_time_ms = (time.time() - start_time) * 1000  — وقت الاستجابة بالميلي ثانية

# Step 5: حفظ السجل في قاعدة البيانات
# - أنشئي DB session جديدة
# - أنشئي SystemLog record:
#   - user_id: request.state.user.id (لو موجود، وإلا None)
#   - action: f"{method} {path}"
#   - details: {
#       "method": method,
#       "path": path,
#       "status_code": response.status_code,
#       "response_time_ms": round(response_time_ms, 2)
#     }
# - احفظي في قاعدة البيانات: db.add(log) → db.commit()
# - أغلقي الـ session: db.close()

# Step 6: إرجاع الاستجابة
# - return response

# --- Dependencies ---
# - app/database.py (SessionLocal)
# - app/models/system_log.py (SystemLog model)
# - app/utils/helpers.py (generate_uuid, get_current_timestamp)

# --- Notes ---
# - سجلي كل الطلبات بما فيها الفاشلة عشان نقدر نتتبع المشاكل
# - user_id يكون None لو الطلب بدون مصادقة (مثل health check)
# - استخدمي try/except عشان لو فشل التسجيل ما يوقف التطبيق
# - السجلات تُعرض في GET /api/admin/logs للمشرف
# - قياس response_time_ms مفيد لمراقبة الأداء
