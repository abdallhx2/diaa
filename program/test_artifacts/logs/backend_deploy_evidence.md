# Backend Deploy Evidence — 2026-05-14

## Deployment Summary
- Server: 178.105.109.153:8001
- Service: edu-backend.service (systemd)
- Migration: 003_add_lesson_summary applied
- Seed: 4 lessons + 12 quizzes inserted

## Lesson UUIDs
| Title | Subject | UUID |
|-------|---------|------|
| أسرتي الحبيبة | لغتي | 9efabb71-771e-45f5-b41f-fde6b6189760 |
| فصل الربيع | لغتي | 034b82b1-cdeb-4384-886f-9df89abdd954 |
| النباتات من حولنا | العلوم | aea0f6f5-341f-4ea9-840a-e5d50da37870 |
| حالات الماء | العلوم | 51405f72-c617-478e-b546-935d3c035ec0 |

## Smoke Test Results (student token: student.test@diaa.com)

### Test 1: GET /api/lessons/subjects?grade=الثالث
```
HTTP 200
{"success":true,"data":{"subjects":["العلوم","لغتي"]},"message":"تم جلب المواد بنجاح"}
```

### Test 2: GET /api/lessons/?grade=الثالث&subject=لغتي
```
HTTP 200
{"success":true,"data":{"lessons":[
  {"id":"9efabb71-771e-45f5-b41f-fde6b6189760","title":"أسرتي الحبيبة","subject":"لغتي","grade_level":"الثالث"},
  {"id":"034b82b1-cdeb-4384-886f-9df89abdd954","title":"فصل الربيع","subject":"لغتي","grade_level":"الثالث"}
]},"message":"تم جلب الدروس بنجاح"}
```

### Test 3: GET /api/lessons/9efabb71-771e-45f5-b41f-fde6b6189760
```
HTTP 200
{"success":true,"data":{"lesson":{"id":"9efabb71-771e-45f5-b41f-fde6b6189760","title":"أسرتي الحبيبة","subject":"لغتي","grade_level":"الثالث","original_text":"...","summary":"...","audio_url":null}},"message":"تم جلب الدرس بنجاح"}
```

### Test 4: POST /api/student/sessions/start (no session_type)
```
HTTP 200
{"success":true,...}
```

## Files Changed
- `backend/alembic/versions/003_add_lesson_summary.py` — new migration
- `backend/alembic/env.py` — new alembic env (was missing from repo)
- `backend/app/models/lesson.py` — added summary column
- `backend/app/schemas/student_schema.py` — session_type optional
- `backend/app/services/chat_service.py` — added summarize() async function
- `backend/app/routers/lesson_router.py` — new router (3 endpoints)
- `backend/app/main.py` — mounted lesson_router at /api/lessons
- `backend/scripts/seed_lessons.py` — new idempotent seed script
