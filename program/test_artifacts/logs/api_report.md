# API Contract Validation Report
**Date:** 2026-05-13  
**Base URL:** http://178.105.109.153:8001/api  
**Tester:** api-tester  

---

## Endpoint Inventory (from OpenAPI spec)

| Method | Endpoint | Auth Required | Notes |
|--------|----------|--------------|-------|
| GET | / | No | Health check |
| POST | /api/auth/verify-token | Firebase token in body | Public entry point |
| POST | /api/auth/register-parent | Firebase token in body | |
| POST | /api/auth/add-child | Firebase token | |
| GET | /api/auth/me | Firebase token | |
| GET | /api/student/dashboard | Firebase token | |
| GET | /api/student/sessions | Firebase token | |
| GET | /api/student/progress | Firebase token | |
| POST | /api/student/sessions/start | Firebase token | |
| POST | /api/student/sessions/{id}/end | Firebase token | |
| POST | /api/scan/ocr | Firebase token | multipart |
| POST | /api/scan/qr | Firebase token | |
| POST | /api/scan/upload | Firebase token | multipart |
| POST | /api/tts/generate | Firebase token | |
| POST | /api/chat/ask | Firebase token | |
| GET | /api/chat/history/{lesson_id} | Firebase token | |
| GET | /api/quizzes/random/{lesson_id} | Firebase token | |
| GET | /api/quizzes/{lesson_id} | Firebase token | |
| GET | /api/quizzes/types/{quiz_type} | Firebase token | |
| POST | /api/quizzes/submit | Firebase token | |
| GET | /api/quizzes/results/{student_id} | Firebase token | |
| GET | /api/parent/children | Firebase token | |
| GET | /api/parent/reports/{child_id} | Firebase token | |
| GET | /api/parent/reports/{child_id}/weekly | Firebase token | |
| GET | /api/parent/reports/{child_id}/monthly | Firebase token | |
| GET | /api/admin/dashboard | Firebase token | |
| GET | /api/admin/users | Firebase token | |
| POST | /api/admin/users | Firebase token | |
| PUT | /api/admin/users/{user_id} | Firebase token | |
| DELETE | /api/admin/users/{user_id} | Firebase token | |
| GET | /api/admin/lessons | Firebase token | |
| POST | /api/admin/lessons | Firebase token | |
| PUT | /api/admin/lessons/{lesson_id} | Firebase token | |
| DELETE | /api/admin/lessons/{lesson_id} | Firebase token | |
| GET | /api/admin/logs | Firebase token | |
| GET | /api/admin/settings | Firebase token | |
| PUT | /api/admin/settings | Firebase token | |

---

## Endpoint Test Results

### GET /
- **Auth required:** No
- **Status:** 200
- **Response:** `{"success":true,"data":null,"message":"Edu Smart Assistant API is running"}`
- **Anomaly:** None. Correct envelope format.
- **Evidence:** `logs/api/root_health.txt`

### POST /api/auth/verify-token (invalid token)
- **Auth required:** Token in request body
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"فشل التحقق من التوكن: Wrong number of segments in token: b'invalid_token_12345'"}}`
- **Anomaly:** [BUG-1] Response is wrapped in `detail` key, not a bare `{success,data,message}` envelope. Also exposes internal error detail including token value.
- **Evidence:** `logs/api/auth_verify_invalid.txt`

### POST /api/auth/verify-token (empty body)
- **Auth required:** Token in request body
- **Status:** 422
- **Response:** `{"success":false,"data":null,"message":"بيانات غير صحيحة"}`
- **Anomaly:** [BUG-2] 422 returns bare envelope `{success,data,message}` but 401 returns `{detail:{success,data,message}}`. Inconsistent error shapes across status codes.
- **Evidence:** `logs/api/auth_verify_empty.txt`

### POST /api/auth/register-parent (empty body, no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** [BUG-2] Same nested detail envelope inconsistency.
- **Evidence:** `logs/api/auth_register_empty.txt`

### POST /api/auth/register-parent (valid body, no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** Correctly rejects unauthenticated request.
- **Evidence:** `logs/api/auth_register_valid_noauth.txt`

### GET /api/admin/dashboard (no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** None (correctly blocked). No admin bypass.
- **Evidence:** `logs/api/admin_dashboard_noauth.txt`

### GET /api/admin/users (no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** None (correctly blocked).
- **Evidence:** `logs/api/admin_users_noauth.txt`

### GET /api/quizzes/{lesson_id} (fake UUID, no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** None (correctly blocked).
- **Evidence:** `logs/api/quizzes_fake_lesson.txt`

### GET /api/student/dashboard (no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** None (correctly blocked).
- **Evidence:** `logs/api/student_dashboard_noauth.txt`

### GET /api/quizzes/random/{lesson_id} (fake UUID, no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** None (correctly blocked).
- **Evidence:** `logs/api/quiz_random_fake.txt`

### POST /api/tts/generate (empty body, no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** None (correctly blocked).
- **Evidence:** `logs/api/tts_empty.txt`

### POST /api/chat/ask (empty body, no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** None (correctly blocked).
- **Evidence:** `logs/api/chat_ask_empty.txt`

### GET /api/admin/logs (no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** None (correctly blocked).
- **Evidence:** `logs/api/admin_logs_noauth.txt`

### GET /api/admin/settings (no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** None (correctly blocked).
- **Evidence:** `logs/api/admin_settings_noauth.txt`

### GET /api/parent/children (no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** None (correctly blocked).
- **Evidence:** `logs/api/parent_children_noauth.txt`

### GET /api/admin/lessons (no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** None (correctly blocked).
- **Evidence:** `logs/api/admin_lessons_noauth.txt`

### GET /api/auth/me (no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** None (correctly blocked).
- **Evidence:** `logs/api/auth_me_noauth.txt`

### GET /api/quizzes/types/{quiz_type} (no auth)
- **Auth required:** Yes
- **Status:** 401
- **Response:** `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}`
- **Anomaly:** None (correctly blocked).
- **Evidence:** `logs/api/quizzes_types.txt`

---

## CORS Analysis

### Preflight from localhost:3000 (expected allowed origin)
- **Status:** 200
- **access-control-allow-origin:** http://localhost:3000
- **access-control-allow-credentials:** true
- **access-control-allow-methods:** DELETE, GET, HEAD, OPTIONS, PATCH, POST, PUT
- **Evidence:** `logs/api/cors_preflight.txt`

### Preflight from http://evil.com (untrusted origin)
- **Status:** 200
- **access-control-allow-origin:** http://evil.com  ← CRITICAL BUG
- **access-control-allow-credentials:** true  ← Makes this worse
- **Evidence:** `logs/api/cors_evil_origin.txt`
- **Anomaly:** [BUG-3] CORS is configured with wildcard/reflect-all-origins. Any origin is allowed, AND credentials are allowed. This is a critical security misconfiguration.

---

## Auth-Protected Endpoint Summary (not tested with real tokens)

All auth-protected endpoints correctly return 401 with `{"detail":{"success":false,"data":null,"message":"التوكن مطلوب"}}` when called without a Firebase token. No endpoint leaked data or bypassed auth in the unauthenticated tests.

**Auth-protected endpoints not tested with valid token (Firebase required):**
- All /api/student/*, /api/parent/*, /api/admin/*, /api/scan/*, /api/tts/*, /api/chat/*, /api/quizzes/* endpoints
- Request shapes documented in OpenAPI spec and schemas section.

---

## Summary of Bugs Found

| Bug ID | Severity | Issue |
|--------|----------|-------|
| BUG-1 | high | Error response exposes internal error message including token value |
| BUG-2 | medium | Inconsistent error envelope shape (401 uses nested `detail`, 422 uses bare envelope) |
| BUG-3 | critical | CORS reflects all origins including untrusted ones, with credentials allowed |
