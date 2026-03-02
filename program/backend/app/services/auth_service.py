# ============================================================
# File: services/auth_service.py
# Purpose: خدمة المصادقة — التحقق من توكن Firebase وإدارة المستخدمين
# Owner: مشاعل — Backend Lead
# Branch: feature/backend-auth
# Week: Week 1 — نظام المصادقة
# ============================================================

# --- Required Imports ---
# import firebase_admin
# from firebase_admin import auth, credentials
# from sqlalchemy.orm import Session
# from app.database import SessionLocal
# from app.models.user import User
# from app.models.parent import Parent
# from app.models.student import Student
# from app.config import settings
# from app.utils.helpers import generate_uuid

# --- Implementation Steps ---

# Step 1: تهيئة Firebase Admin SDK
# - cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
# - firebase_admin.initialize_app(cred)
# - هذا يتم مرة واحدة عند تحميل الملف

# Step 2: دالة verify_firebase_token(token: str) -> dict
# - استخدمي auth.verify_id_token(token) من Firebase Admin SDK
# - ترجع decoded_token اللي يحتوي على: uid, email, name, ...
# - لو التوكن منتهي أو غير صالح — ارمي Exception
# - ارجعي decoded_token

# Step 3: دالة get_or_create_user(firebase_uid: str, role: str, name: str, email: str) -> User
# - ابحثي في DB عن مستخدم بـ firebase_uid
# - لو موجود — ارجعيه مباشرة
# - لو مو موجود — أنشئي مستخدم جديد:
#   - User(id=generate_uuid(), firebase_uid=firebase_uid, role=role, name=name, email=email)
#   - لو role == "student" — أنشئي Student record مرتبط
#   - لو role == "parent" — أنشئي Parent record مرتبط
#   - لو role == "admin" — أنشئي Admin record مرتبط
#   - db.add(user) → db.commit()
# - ارجعي المستخدم

# Step 4: دالة register_parent(data: dict) -> dict
# - أنشئي حساب في Firebase: auth.create_user(email=data.email, password=data.password, display_name=data.name)
# - أنشئي مستخدم في DB بـ role="parent"
# - أنشئي Parent record مرتبط
# - ارجعي بيانات ولي الأمر

# Step 5: دالة add_child_to_parent(parent_id: UUID, child_data: dict) -> dict
# - أنشئي حساب Firebase للطفل (أو استخدمي حساب ولي الأمر)
# - أنشئي User بـ role="student"
# - أنشئي Student record بـ parent_id
# - حدثي num_children في Parent record (+1)
# - db.commit()
# - ارجعي بيانات الطفل

# --- Dependencies ---
# - app/config.py (settings — Firebase credentials path)
# - app/database.py (SessionLocal)
# - app/models/user.py, parent.py, student.py, admin.py
# - app/utils/helpers.py (generate_uuid)

# --- Notes ---
# - Firebase Admin SDK لازم يتهيأ مرة واحدة فقط
# - verify_firebase_token تتحقق من: صلاحية التوكن + عدم انتهاء الصلاحية
# - get_or_create_user تضمن ما يتكرر المستخدم في DB
# - استخدمي try/except حول Firebase calls عشان تعاملين الأخطاء بشكل مناسب
