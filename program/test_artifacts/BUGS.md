# Bug Log — Edu Smart Assistant

Tracking bugs found during E2E QA on 2026-05-13.
Format per entry — see template at the bottom of this file.

---

## BUG-1: Auth error response leaks internal token error detail
- Severity: high
- Source: api-tester
- Endpoint/Screen: POST /api/auth/verify-token
- Repro: `curl -X POST http://178.105.109.153:8001/api/auth/verify-token -H "Content-Type: application/json" -d '{"token":"invalid_token_12345"}'`
- Expected: Generic error message without exposing token value or internal exception message
- Actual: `{"detail":{"success":false,"data":null,"message":"فشل التحقق من التوكن: Wrong number of segments in token: b'invalid_token_12345'"}}` — exposes raw exception string including submitted token bytes
- Evidence: D:/Student/Edu/program/test_artifacts/logs/api/auth_verify_invalid.txt

## BUG-2: Inconsistent error envelope shape between 401 and 422 responses
- Severity: medium
- Source: api-tester
- Endpoint/Screen: All endpoints — observable on POST /api/auth/verify-token
- Repro: (a) POST /api/auth/verify-token with empty body `{}` → 422; (b) POST with invalid token → 401
- Expected: All error responses use the same project-standard envelope: `{"success": false, "data": null, "message": "..."}`
- Actual: 401 responses nest inside `detail` key: `{"detail":{"success":false,...}}`. 422 responses use bare envelope: `{"success":false,...}`. Clients must handle two different error shapes, breaking the project standard.
- Evidence: D:/Student/Edu/program/test_artifacts/logs/api/auth_verify_empty.txt (422) vs D:/Student/Edu/program/test_artifacts/logs/api/auth_verify_invalid.txt (401)

## BUG-3: CORS reflects all origins with credentials allowed — critical security misconfiguration
- Severity: critical
- Source: api-tester
- Endpoint/Screen: All endpoints (global CORS middleware)
- Repro: `curl -X OPTIONS http://178.105.109.153:8001/api/auth/verify-token -H "Origin: http://evil.com" -H "Access-Control-Request-Method: POST" -D -`
- Expected: Only trusted origins (e.g. localhost:3000, deployed admin domain) receive `Access-Control-Allow-Origin`. Untrusted origins should be rejected.
- Actual: Server echoes back any origin in `Access-Control-Allow-Origin` AND sets `access-control-allow-credentials: true`. Any website can make credentialed cross-origin requests to this API.
- Evidence: D:/Student/Edu/program/test_artifacts/logs/api/cors_evil_origin.txt

## BUG-4: DashboardLayout mock-mode check broken — admin panel always redirects to login on localhost
- Severity: high
- Source: team-lead
- Endpoint/Screen: All admin pages (/dashboard, /lessons, /quizzes, /subjects)
- Repro: Navigate to http://localhost:3000/dashboard — page immediately redirects back to /
- Expected: On localhost (dev), DashboardLayout should allow access without Firebase auth (mock mode)
- Actual: `onAuthStateChanged` fires in <1s with no Firebase user. The `isMockMode` check uses `process.env.NEXT_PUBLIC_API_URL?.includes('localhost')` which evaluates to false (NEXT_PUBLIC_API_URL points to the remote server 178.105.109.153). So auth guard calls router.push('/') before the 3s fallback timeout fires. Entire admin panel is inaccessible without a real Firebase session.
- Evidence: D:/Student/Edu/program/admin/src/components/layout/DashboardLayout.tsx line 41; D:/Student/Edu/program/test_artifacts/screenshots/admin_login_after_submit.png

## BUG-5: Login page shows no error message after failed login — silent failure loop
- Severity: medium
- Source: team-lead
- Endpoint/Screen: http://localhost:3000/ (login page)
- Repro: Fill any credentials and click تسجيل الدخول on localhost
- Expected: Either navigate to dashboard (mock mode) or show an error message explaining what went wrong
- Actual: Firebase 400 is silently caught, /api/auth/me 401 is silently caught, router.push('/dashboard') is called, RSC fetch fails with network error, browser falls back to /dashboard which immediately redirects to /login via broken auth guard (BUG-4). No error message ever displayed. User sees login form again with no feedback.
- Evidence: D:/Student/Edu/program/.playwright-mcp/console-2026-05-13T13-55-48-599Z.log lines 4-20; D:/Student/Edu/program/test_artifacts/screenshots/admin_login_silent_failure.png


## BUG-4: Admin login mock-mode broken end-to-end (initial blocker)
- Severity: high (test-blocker; behaved as critical until seeded)
- Source: team-lead
- Endpoint/Screen: admin / (login)
- Repro: Set NEXT_PUBLIC_API_URL to deployed backend, browse to admin /, submit any creds.
- Expected: Either real Firebase auth, or working "mock mode" path that lets devs in.
- Actual: api.ts injects `mock_admin_AdminUser` Bearer token only when `config.baseURL?.includes('localhost')`. With deployed backend the token isn't injected. /auth/me returns 401 → response interceptor does `window.location.href = '/'` BEFORE the page-level catch can run `router.push('/dashboard')`, causing infinite return-to-login.
- Fix sketch: in `admin/src/services/api.ts` line 14, also check `window.location.hostname` for localhost. AND/OR backend must accept mock tokens when an env flag is set. Also the deployed backend has USE_MOCKS=false so even if mock token is injected it gets 401.
- Workaround used: created real Firebase admin via service-account script `test_artifacts/seed_users.py`.
- Evidence: admin/src/services/api.ts:14, admin/src/app/page.tsx:23-44

## BUG-5: Admin "Add Lesson" save button is a no-op (TODO)
- Severity: critical
- Source: team-lead
- Endpoint/Screen: admin /lessons → "إضافة درس" modal → "حفظ الدرس"
- Repro: open Add Lesson modal, fill title + subject + summary, click حفظ الدرس.
- Expected: POST /api/admin/lessons; lesson appears in list.
- Actual: handleSave just calls onClose(); no API call; no error shown; new lesson never appears (verified: GET /api/admin/lessons still returns 5 seed rows).
- Fix sketch: implement handleSave with `await api.post('/admin/lessons', { title, subject, summary, ... })` and refresh parent state via callback prop.
- Evidence: admin/src/components/lessons/LessonModal.tsx:64-67

## BUG-6: Admin lesson Edit and Delete buttons are no-ops
- Severity: high
- Source: team-lead
- Endpoint/Screen: admin /lessons → row edit/delete buttons
- Repro: click any row's edit or delete icon.
- Expected: Edit opens prefilled modal; Delete confirms then DELETE /api/admin/lessons/{id}.
- Actual: handleEdit and handleDelete only `console.log` lesson.id and do nothing.
- Fix sketch: handleEdit → open LessonModal with mode="edit" + initialData; handleDelete → confirm() then api.delete + refresh.
- Evidence: admin/src/app/lessons/page.tsx:62-68

## BUG-7: Add-Lesson subject dropdown only has 2 of 4 subjects
- Severity: high
- Source: team-lead
- Endpoint/Screen: admin /lessons → Add Lesson modal → subject select
- Repro: open Add Lesson modal, expand subject dropdown.
- Expected: Dropdown contains every subject the system supports (لغتي, علوم, رياضيات, تربية اسلامية — at minimum the subjects appearing in /admin/lessons response).
- Actual: Dropdown hard-codes only "لغتي" and "علوم". Existing seed lessons reference "رياضيات" and "تربية اسلامية", which means a lesson with one of those subjects can't be re-saved with the same value through the modal.
- Fix sketch: Fetch /admin/dashboard or a /admin/subjects endpoint; render <option> per returned subject. (Backend lacks a subjects list endpoint — also worth filing.)
- Evidence: admin/src/components/lessons/LessonModal.tsx:133-136

## BUG-8: Admin UI silently masks API errors with mock data fallback
- Severity: medium
- Source: team-lead
- Endpoint/Screen: admin /lessons (and likely /subjects, /quizzes by pattern)
- Repro: stop backend or block /admin/lessons; reload page.
- Expected: User-visible error or empty state.
- Actual: Component swallows the exception and renders 4 hard-coded mock lessons (`getMockLessons`), making it impossible to tell the backend is down.
- Fix sketch: Replace `catch { setLessons(getMockLessons()); }` with surfacing an error banner.
- Evidence: admin/src/app/lessons/page.tsx:32-34

## BUG-9: Admin sidebar missing Users / Logs / Settings entries
- Severity: medium
- Source: team-lead
- Endpoint/Screen: admin sidebar
- Repro: log in as admin and inspect sidebar.
- Expected: Per backend OpenAPI, admin can manage users (/api/admin/users CRUD), inspect logs (/api/admin/logs), and edit settings (/api/admin/settings). All three should be reachable from the sidebar.
- Actual: Sidebar has only Dashboard, Subjects, Lessons, Quizzes. No /users, /logs, /settings pages exist in admin/src/app/.
- Fix sketch: Build /users, /logs, /settings pages and link from sidebar.
- Evidence: admin/src/app/ directory contents

## BUG-10: Auth state lost on direct route navigation; bounces to login
- Severity: high
- Source: team-lead
- Endpoint/Screen: any protected route (/dashboard, /lessons, /quizzes) opened by direct URL after login
- Repro: log in successfully → navigate to http://localhost:3000/dashboard via address bar.
- Expected: Stay on /dashboard.
- Actual: Page renders briefly then bounces to /. Cause: api interceptor in `admin/src/services/api.ts` does `window.location.href = '/'` on any 401, with no awareness that Firebase auth may still be rehydrating. Pages call `api.get` immediately on mount before `getIdToken()` resolves, get a 401, and force-redirect.
- Fix sketch: wait for `onAuthStateChanged` resolution before issuing protected calls; OR have interceptor refresh and retry once instead of immediate hard redirect.
- Evidence: admin/src/services/api.ts:25-35

## BUG-11: Quizzes UI uses /api/quizzes (student endpoint) for admin CRUD
- Severity: medium
- Source: team-lead
- Endpoint/Screen: admin /quizzes — Add/Edit/Delete question
- Repro: open /quizzes; observe rendered list works; click "إضافة سؤال" (form likely TODO too based on lessons-modal pattern).
- Expected: Admin uses dedicated admin endpoints with auth.
- Actual: Backend OpenAPI shows admin endpoints exist for lessons/users only — NO /api/admin/quizzes endpoint exists. The admin UI must therefore reach /api/quizzes/{lesson_id} which is a student-facing read endpoint with no create/update/delete. Question CRUD on admin side has no backing API.
- Fix sketch: Add /api/admin/quizzes (POST/PUT/DELETE) endpoints in backend; wire admin UI to them.
- Evidence: openapi.json `/api/quizzes/*` paths; missing /api/admin/quizzes

## BUG-12: Mobile parent dashboard shows blank grade label
- Severity: low
- Source: team-lead
- Endpoint/Screen: mobile parent dashboard + /my-children
- Repro: add child with grade "الثالث"; observe child card.
- Expected: "الصف الثالث" rendered.
- Actual: Card shows "الصف" with no value after it (verified across home + my-children screens). Backend GET /api/parent/children returns `"grade":"الثالث"` correctly — UI just isn't binding it.
- Evidence: mobile_12_after_add_child.png, mobile_15_my_children.png

## BUG-13: Mobile parent registration screen unreachable from intro / no "register" link
- Severity: medium
- Source: team-lead
- Endpoint/Screen: mobile parent login (initial form)
- Repro: launch fresh app → role selection → login screen.
- Expected: Visible "إنشاء حساب جديد" / "تسجيل" link on the parent login screen.
- Actual: Initial render shows only login fields + "نسيت كلمة المرور". A "تسجيل" register button only appears AFTER the soft keyboard is dismissed (visible in mobile_07_pw_retry.png), which a real user is unlikely to discover. Mobile_04_splash shows it absent.
- Evidence: mobile_04_splash.png vs mobile_07_pw_retry.png

## BUG-14: First mobile launch landed directly inside parent flow (residual session before clear)
- Severity: high (intermittent — suggests stale persisted state survives reinstalls until pm clear)
- Source: team-lead
- Endpoint/Screen: mobile launch
- Repro: install fresh APK without `pm clear`, launch → app skipped login and dropped me into "إضافة طفل" form (with `tAhmed` / age 8 prefilled) — the leftover state of an anonymous prior session.
- Expected: A fresh install / first launch goes through splash → role-selection → login.
- Actual: SharedPreferences `isLoggedIn=true` survived re-install, so checkAuthState() granted access without a real Firebase session. Working solution required `adb shell pm clear com.edusmart.assistant`.
- Fix sketch: also verify `_authService.isSignedIn` AND a non-expired Firebase user before treating SharedPreferences as ground truth (or clear prefs on app upgrade).
- Evidence: mobile_01_launch.png, mobile_03_back1.png; auth_provider.dart:67-100

## BUG-15: Mobile back-press from login goes to nonexistent "/" route
- Severity: high
- Source: team-lead
- Endpoint/Screen: mobile login screen / system back gesture
- Repro: from login screen press device BACK once.
- Expected: System exits app or no-op (since login is the start of the navigation stack).
- Actual: Renders fallback "الصفحة غير موجودة: /" (page not found). The app falls into a dead screen with no way out. The route generator default branch handles unknown route names — so something is requesting route "/" which is not registered (only "/splash" is).
- Fix sketch: in routes.dart `generateRoute` add explicit case for "/" or for `null` settings.name → push splash. Also override WillPopScope on login screen to exit instead of popping.
- Evidence: mobile_16_route_404.png

## BUG-16: Mobile child registration creates child without Firebase account (uid placeholder)
- Severity: critical
- Source: team-lead
- Endpoint/Screen: mobile parent /add-child
- Repro: parent adds child via UI; observe stored child_firebase_uid.
- Expected: Either prompt for child email/password and create real Firebase user, OR design student auth so children share parent session and use a child profile picker instead of email/password.
- Actual: `add_child_screen.dart:40-41` generates `'child-${timestamp}-${random}'` and submits as `child_firebase_uid`. Backend stores it. The child has no Firebase account → student login screen which requires real email/password is unreachable for this child. Child is therefore never useable in the student flow.
- Fix sketch: pivot the design — either (a) ask parent for child Firebase email/password during add-child, or (b) drop Firebase email/password for students and use a parent-managed child-picker on student tab that issues a child-scoped JWT from the backend.
- Evidence: mobile/lib/screens/parent/add_child_screen.dart:40-49
- Status: OPEN — schema gap, not fixed (2026-05-14)

## BUG-17: Text input doubles when ADB sends after a previous click within the same field
- Severity: low (test-tooling bug, but user-visible)
- Source: team-lead (during testing)
- Endpoint/Screen: any TextFormField on mobile (login email, child name, age)
- Repro: tap field → adb input X → tap same field → adb input X → text becomes XX.
- Expected: Re-tap focuses the field at cursor position; subsequent text appends. Standard.
- Actual: Initial typed value persists invisibly even after element list shows EditText empty; second input appends to old. Suggests either RTL caret position bug or controller-vs-field state desync. Real users see this if they tap a field, type, then tap the same field again to edit — they get duplicated content instead of an editable cursor.
- Evidence: mobile_19_student_logged.png — email = "student.test@diaa.coStudent12345" after distinct field taps

## BUG-18: Mobile student lesson list, lesson detail, and quiz are entirely hard-coded
- Severity: critical
- Source: team-lead
- Endpoint/Screen: mobile student → ابدأ التعلم → subject → lesson list → lesson detail
- Repro: log in as student; tap ابدأ التعلم; pick لغتي; observe lessons.
- Expected: List populated from GET /api/admin/lessons (or a student-facing equivalent). Tapping a lesson opens that specific lesson. Quiz items come from GET /api/quizzes/{lesson_id}.
- Actual:
  - Subjects show لغتي + العلوم only (backend has 4 subjects).
  - Lesson list is hard-coded to: الأسرة, المدرسة, الطبيعة, الألوان, الحيوانات. Backend's actual lessons (حرف الالف, الجملة الاسمية, الاعداد من 1 الى 10, حالات المادة, اركان الاسلام) never appear.
  - Tapping any lesson opens the SAME hardcoded "الأسرة" detail page.
  - Quiz Q1 is always "ما هو لون السماء في النهار؟" with options أحمر/أزرق/أخضر/أصفر, regardless of lesson.
  - Submitting an answer with تأكيد الإجابة does not advance to Q2 — the quiz is a static demo.
  - "مكتمل" badges on الأسرة and المدرسة are also fake — student has zero progress on backend.
- Evidence: mobile_25_subjects.png, mobile_26_lessons.png, mobile_27_chat.png (lesson list view), mobile_29_quiz_q1.png. Backend GET /api/admin/lessons (5 real lessons) vs UI list.

### Resolved 2026-05-14
Subjects and lessons now load from real backend API (لغتي 12 درساً، العلوم 10 دروس confirmed live in 02-subjects.png / 03-lessons.png). الملخص tab shows real Arabic summary text from backend (04-lesson-summary.png). TTS autoplay works on الملخص (05-tts-playing.png). Hardcoded lesson titles "الطبيعة من حولنا جميلة" and lesson detail placeholder no longer visible. Fix: lesson_service.dart + lessons_provider + screen rewrites.

## BUG-19: Backend TTS endpoint 500 — Firebase Storage bucket misconfigured
- Severity: high
- Source: api-tester (extended)
- Endpoint/Screen: POST /api/tts/generate
- Repro: `curl -X POST .../api/tts/generate -H "Authorization: Bearer <student>" -d '{"text":"مرحباً"}'`
- Expected: 200 with audio_url.
- Actual: HTTP 500 — `خطأ في خدمة تحويل النص إلى صوت: فشل رفع الملف الصوتي: فشل رفع الملف إلى Firebase Storage: 404 POST https://storage.googleapis.com/upload/storage/v1/b/...` — backend tries to upload to a Storage bucket that doesn't exist.
- Fix sketch: in deployed backend's .env, set FIREBASE_STORAGE_BUCKET to a real bucket (currently "fake.appspot.com" locally; deployed value also wrong). And handle the upload error to return a 503/422 instead of 500.
- Evidence: /api/tts/generate response shown in api log

## BUG-20: POST /api/student/sessions/start always 422
- Severity: high
- Source: api-tester (extended)
- Endpoint/Screen: POST /api/student/sessions/start
- Repro: `curl -X POST .../api/student/sessions/start -H "Authorization: Bearer <student>" -d '{"lesson_id":"..."}'`
- Expected: 200 with session id; OR a clear error naming the missing field.
- Actual: 422 with generic `بيانات غير صحيحة`. Schema (student_schema.py:33-35) requires `session_type` (string). Mobile client almost certainly doesn't send it; users would never finish a session. Error doesn't name the missing field, so client devs can't tell.
- Fix sketch: (a) make session_type optional with default "lesson", or document it; (b) include `loc`/field name in the 422 response body.
- Evidence: backend/app/schemas/student_schema.py:33

### Resolved 2026-05-14
session_type made optional in SessionStartRequest. Endpoint now accepts requests without session_type field.

## BUG-21: Submitted quiz answer doesn't advance to next question
- Severity: high
- Source: team-lead
- Endpoint/Screen: mobile student → lesson → اختبر tab → "تأكيد الإجابة"
- Repro: open lesson → اختبر; choose any option; tap تأكيد الإجابة.
- Expected: progress to Q2/3, eventually show score.
- Actual: stays on Q1 — button visually responds but no state change. Companion to BUG-18 (entire quiz is static).
- Evidence: mobile_29_quiz_q1.png

### Resolved 2026-05-14 (backend-only fix — no APK rebuild needed)
Backend `quiz_service.submit_answer` was updated to compare `selected_answer` against option values (not just the stored key "a"). After the deploy, the full quiz flow was verified E2E on emulator-5554:
- Q1 "ممّ تتكوّن الأسرة؟" → تأكيد الإجابة → feedback message + "السؤال التالي" button appears ✅
- Q2 "أين تعيش الأسرة عادةً؟" → same advance flow works ✅
- Q3 "ماذا يتعلّم الطفل من والديه؟" → button changes to "عرض النتيجة" ✅
- Result screen: "أحسنت! نتيجتك 0/3" + "إعادة الاختبار" button ✅
Evidence: rerun-07-quiz-fixed.png, rerun-quiz-result.png

## BUG-22: Student reports tab missing — only "نتائجي" present
- Severity: low
- Source: team-lead
- Endpoint/Screen: mobile student bottom-nav
- Observation: student bottom nav shows الرئيسية / نتائجي / حسابي. The student-side "نتائجي" was not exercised because all flows above never produce real results (quiz hardcoded, sessions can't start). Tab presence noted but coverage limited by upstream bugs.

## BUG-23: Student profile shows "الصف غير محدد الابتدائي" — grade not set in seed account
- Severity: low
- Source: qa-tester (2026-05-14 E2E run)
- Endpoint/Screen: mobile student home screen header
- Repro: log in as student.test@diaa.com; observe header subtitle.
- Expected: Student grade level shown (e.g. "الصف الثالث الابتدائي").
- Actual: Shows "الصف غير محدد الابتدائي" — grade field is null/empty in the seeded student record (Student.grade defaults to "غير محدد" in seed_student.py).
- Fix: set grade in the seed script, or update Student.grade directly in the DB. Also: PUT /api/admin/users/{id} does NOT update Student.grade (only User fields) — admin router needs a fix.
- Evidence: 01-home.png

### Workaround applied 2026-05-14 (rerun)
Updated Student.grade to "الثالث" directly on the production DB via SSH + venv Python. App now shows "الصف الثالث الابتدائي" in rerun-01-home.png. Also fixed: PUT /api/admin/users now accepts `grade` field and updates the Student record (admin_router.py + admin_schema.py patch deployed).

## BUG-24: Arabic chat input impossible without devicekit — اسأل tab untestable via automation
- Severity: medium (test-environment limitation)
- Source: qa-tester (2026-05-14 E2E run)
- Endpoint/Screen: mobile student → lesson → اسأل tab
- Repro: tap input field; attempt to type Arabic via mobile_type_keys or adb input text.
- Expected: Arabic text enters the chat input; send button dispatches to AI; reply bubble renders.
- Actual: mobile_type_keys returns "Non-ASCII text not supported — install mobilenext devicekit". adb input text fails with NullPointerException on Arabic strings. Clipboard-paste approach triggers tab switch to quiz screen instead of pasting. The اسأل tab UI renders correctly (greeting bubble visible) but no question could be submitted.
- Fix: install devicekit-android on the emulator, or use Android debug bridge instrumentation for text injection.
- Evidence: 08-chat-reply.png (tab renders, no message sent)

## BUG-26: GET /api/lessons response wraps list in {"lessons": [...]} — Flutter client expects bare list
- Severity: high (caused empty lesson list in new APK until fixed)
- Source: qa-tester (2026-05-14 rerun)
- Endpoint/Screen: mobile student → subject → lesson list (blank)
- Repro: tap ابدأ التعلم → pick any subject → observe empty "لا توجد دروس متاحة لصفك حالياً".
- Expected: Lessons load from API and render as cards.
- Actual: Backend returned `{"success":true,"data":{"lessons":[...]}}` but Flutter `lesson_service.dart` line 33 does `data['data'] as List<dynamic>` — casting a Map to List throws, returns []. The new Flutter code expects `data` to be the list directly.
- Fix applied 2026-05-14: Changed `lesson_router.py` list_lessons to `return format_response(True, lessons, ...)` (bare list instead of `{"lessons": lessons}`). Deployed via scp + systemctl restart.
- Evidence: rerun showed empty screen → fixed → rerun-03-lessons.png shows real lessons.

## BUG-27: TTS unavailable — Azure TTS bucket misconfigured on production (الصوت غير متاح حالياً)
- Severity: medium (graceful degradation works; audio is just unavailable)
- Source: qa-tester (2026-05-14 rerun)
- Endpoint/Screen: mobile student → lesson → الملخص tab → play button
- Repro: open any lesson → الملخص tab → tap ▶ play button.
- Expected: Audio plays from Azure TTS.
- Actual: App shows "الصوت غير متاح حالياً" with a muted icon. TTS service returns empty URL (backend returns 500 due to Firebase Storage bucket misconfiguration — same root cause as BUG-19).
- Fix: Fix BUG-19 (configure correct FIREBASE_STORAGE_BUCKET in deployed .env).
- Note: Graceful degradation works correctly — app handles TTS failure without crash.
- Evidence: rerun-05-tts-unavailable.png

## BUG-25: Scan screen camera unavailable on emulator — "لا يمكن الوصول للكاميرا"
- Severity: low (environment limitation, not app bug)
- Source: qa-tester (2026-05-14 E2E run)
- Endpoint/Screen: mobile student → اقرأ لي → camera viewfinder
- Repro: tap اقرأ لي → grant camera permission → observe viewfinder.
- Expected: Live camera preview; tap "التقاط الصورة" to capture and OCR.
- Actual: Viewfinder shows "لا يمكن الوصول للكاميرا. تأكد من منح التطبيق صلاحية استخدام الكاميرا من إعدادات الجهاز". Permission was granted ("While using the app") but the emulator has no camera hardware. UI renders correctly otherwise (capture button + history link present).
- Evidence: 11-scan-tts.png
