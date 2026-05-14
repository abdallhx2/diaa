# Edu Smart Assistant — E2E QA Report

**Date:** 2026-05-13
**Scope:** Full-lifecycle test of backend (`http://178.105.109.153:8001`), Next.js admin panel (local `:3000`), and Flutter mobile app (`com.edusmart.assistant` on Android emulator DMX, API 33).

## Setup
- Created Firebase service-account-driven seed users (parent + student + admin) since the in-app registration paths for admin and child don't create real Firebase accounts.
  - `admin@diaa.com` / `Admin1234!` (custom claim role=admin)
  - `parent.test@diaa.com` / `Parent1234!` (custom claim role=parent; DB row registered)
  - `student.test@diaa.com` / `Student12345` (custom claim role=student)
- Seed script: `test_artifacts/seed_users.py`, `test_artifacts/seed_student.py`. Creds saved to `test_creds.json`.

## Coverage

| Surface | Touched | Notes |
|---|---|---|
| Backend public/auth endpoints | ✅ | `api_report.md` enumerates every path |
| Backend admin (lessons, dashboard, users, logs, settings) | partial | only lessons exercised via UI; users/logs/settings have no UI page |
| Backend parent (children, reports weekly/monthly) | ✅ | all 200, real data |
| Backend student (dashboard, progress, scan/qr, chat/ask, sessions, quizzes) | ✅ | sessions/start 422, TTS 500; rest OK |
| Admin panel | login → dashboard → subjects → lessons (add modal) → quizzes | only 4 of expected pages exist |
| Mobile parent | role-select → login → add-child → home → reports → account → my-children → logout-route-bug | all screens viewed |
| Mobile student | login → student home → ابدأ التعلم → subjects → lessons → lesson detail (4 tabs) → quiz Q1 → AI chat | quiz/lesson list are mock data |

## Result Summary

- **22 bugs** logged in `BUGS.md`. Severity breakdown:
  - **Critical (5):** BUG-3 (open CORS), BUG-5 (admin Add Lesson is TODO), BUG-16 (mobile child has no real Firebase account), BUG-18 (mobile student lessons + quiz hard-coded), BUG-21 (companion to 18 — quiz doesn't advance).
  - **High (9):** BUG-1, BUG-4, BUG-6, BUG-7, BUG-10, BUG-14, BUG-15, BUG-19, BUG-20.
  - **Medium (4):** BUG-2, BUG-8, BUG-9, BUG-11, BUG-13.
  - **Low (4):** BUG-12, BUG-17, BUG-22.
- All screenshots in `test_artifacts/screenshots/` (33 admin/mobile screens).
- Raw API evidence in `test_artifacts/logs/api/`.

## What Works Well
- Backend deployment is live and the parent + student core APIs all return real data with correct response envelopes (`{success, data, message}`).
- Firebase auth integration on the deployed backend correctly validates tokens and resolves custom-claim roles.
- AI chat over `/api/chat/ask` returns coherent Arabic answers grounded in the lesson text.
- Admin panel login, dashboard, subjects, lesson list, and quiz list READ paths work — they show real data from the API.
- Mobile parent registration, add-child, dashboard, reports tab, and account tab all reach the backend correctly. Adding a child correctly creates the DB row (verified via API).

## What's Broken (Top 5)
1. **Admin panel CRUD is mostly a façade** (BUG-5, BUG-6, BUG-9, BUG-11). "Add Lesson" / "Edit" / "Delete" buttons just `console.log`. There are no UI pages for users/logs/settings even though the backend supports them.
2. **Mobile student lesson + quiz are static mock data** (BUG-18, BUG-21). Subjects, lesson titles, quiz questions, and "completed" badges are all hard-coded — no API call. The whole student learning experience is a demo.
3. **Mobile child accounts cannot log in as students** (BUG-16). Add-Child generates a placeholder UID; no Firebase account is created. To even test the student flow we had to manually seed a Firebase user.
4. **Open CORS** (BUG-3). API echoes any Origin and allows credentials — any website can hit the API on behalf of a logged-in user.
5. **Mobile back-press from login crashes to a 404 route** (BUG-15). Pressing the system Back button on the login screen lands the user on a dead "الصفحة غير موجودة" page with no recovery.

## Suggested Fix Order
1. BUG-3 (CORS) — 1-line config change, biggest security win.
2. BUG-20 (session_type optional) — 1-line schema change, unblocks all session tracking.
3. BUG-15 (login back route) — 5 lines in routes.dart.
4. BUG-5/6/8 (admin Lesson CRUD wiring) — ~30 lines across LessonModal.tsx + lessons/page.tsx.
5. BUG-18 + BUG-16 (mobile student lessons/quiz from API) — biggest scope; needs real student subject/lesson/quiz wiring + decision on child auth model.
