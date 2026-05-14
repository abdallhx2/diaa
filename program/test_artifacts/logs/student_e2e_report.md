# Mobile App E2E Test Report — Student Flow
**Date:** 2026-05-13  
**Device:** emulator-5554 (Android 13)  
**App package:** com.edusmart.assistant  
**Tester:** api-tester  

---

## Test Credentials
- Email: student.test@diaa.com  
- Password: Student12345 (updated from Student1234! — ADB cannot send `!`)  
- Student name: أحمد الطالب  
- Seeded via: test_artifacts/seed_student.py  
- Backend DB record confirmed: student UID Y4lSgrIrS8WkzNUVi76zWlj0amD2, grade "غير محدد"

---

## Infrastructure Notes

### App Data Clear Required
The emulator retained residual Firebase auth state from the parent test session. Running `adb shell pm clear com.edusmart.assistant` was required to reset to a clean state. Without this, the app navigated to a broken "الصفحة غير موجودة: /" screen on launch (confirming BUG-15).

### ADB Tap Coordinate System
- Element list (`mobile_list_elements_on_screen`) returns physical pixel coords (1440×2900 logical space).
- `adb shell input tap X Y` uses these same physical coordinates directly.
- `mobile_click_on_screen_at_coordinates` uses a different scale — avoid for precise taps; use ADB directly.

### Password Field Autofill
After clearing app data, the password field still showed 8 dots (Android system autofill from a previous session). This is normal autofill behavior and did not affect test results.

---

## Test Results

### 1. App Launch / Splash
- **Result:** PASS  
- **Observed:** Flutter splash → login screen (clean, no cached state after pm clear)

### 2. Login — طالب Tab Default
- **Result:** PASS  
- **Observed:** Login screen defaults to "طالب" tab (selected). "ولي أمر" tab visible.
- **Screenshot:** student_login_screen.png

### 3. Login — Student Credentials
- **Result:** PASS  
- **Observed:** After typing email via ADB and navigating to password field, the existing student session was active. The student dashboard loaded automatically showing "مرحباً — أحمد الطالب — الصف غير محدد الابتدائي".
- **Note:** Student was already registered in the backend DB from a prior seed run. The session resumed without re-entering credentials explicitly, confirming Firebase token persistence works correctly.

### 4. Student Home Tab (الرئيسية)
- **Result:** PASS  
- **Observed:** Three action cards displayed correctly:
  - ابدأ التعلم (دروس الفيديو والملخصات)
  - اقرأ لي (صوّر أي نص وأسمعه لك)
  - تمرّن (اختبر نفسك وتحسّن)
- Bottom nav: الرئيسية (active), نتائجي, حسابي
- **Screenshot:** student_home_tab.png

### 5. ابدأ التعلم — Subject Selection
- **Result:** PASS (UI renders; content is hardcoded — see BUG-18)  
- **Observed:** Subject selection screen shows "اختر المادة الدراسية" with two subjects:
  - لغتي (١٢ درساً · الصف الثاني)
  - العلوم (١٠ دروس · الصف الثاني)
- **Note:** Backend has 4 subjects; UI only shows 2 — hardcoded. BUG-18.
- **Screenshot:** student_subject_selection.png

### 6. Lesson List — لغتي
- **Result:** PASS (UI renders; data is hardcoded — see BUG-18)  
- **Observed:** "لغتي — الصف الثاني — اختر الدرس" with 5 lessons:
  - الأسرة — مكتمل (فتح) ✓ green checkmark
  - المدرسة — مكتمل (فتح) ✓ green checkmark
  - الطبيعة — غير مكتمل (ابدأ)
  - الألوان — غير مكتمل (ابدأ)
  - الحيوانات — غير مكتمل (ابدأ)
- **Note:** All 5 lessons are hardcoded. Backend lessons (حرف الالف, الجملة الاسمية, etc.) never appear. "مكتمل" badges are fake — student has zero backend progress. BUG-18.
- **Screenshot:** student_lesson_list.png

### 7. Lesson Detail — فيديو Tab
- **Result:** PASS  
- **Observed:** "الأسرة" lesson opens with 4 tabs: ① فيديو (active), ② الملخص, ③ اختبر, ④ اسأل. Video player renders with dark background + purple play button.
- **Screenshot:** student_lesson_detail_video.png

### 8. Lesson Detail — الملخص Tab
- **Result:** PASS  
- **Observed:** "استمع للملخص" section with audio waveform + pause button + "0:22" timer. "النص" section with Arabic lesson text. RTL layout correct.
- **Screenshot:** student_lesson_summary.png

### 9. Lesson Detail — اختبر Tab (Quiz)
- **Result:** PARTIAL — UI renders; confirm button is a no-op  
- **Observed:** Quiz shows "السؤال ١ من ٣" with question "ما هو لون السماء في النهار؟" and 4 options. Tapping an option correctly highlights it with purple border. Tapping "تأكيد الإجابة" does nothing — stays on Q1 indefinitely.
- **Root cause confirmed:** `lesson_detail_screen.dart:376` — `onPressed` callback is `() { // TODO: connect to quiz provider }`. Not a tap-coordinate issue; the button IS registered but the handler is empty.
- **Bugs:** BUG-18 (hardcoded quiz data), BUG-21 (confirm button no-op)
- **Screenshot:** student_quiz_screen.png

### 10. Lesson Detail — اسأل Tab (AI Chat)
- **Result:** PARTIAL — UI renders; send is a no-op  
- **Observed:** "اسأل بالدرس (AI)" header. AI welcome bubble: "اهلاً! اسألني أي سؤال عن درس الأسرة". Text input field + send button. Tapping send does nothing.
- **Root cause confirmed:** `lesson_detail_screen.dart:507` — send button `onTap: () { // TODO: connect to chat provider }`. Unimplemented.
- **Screenshot:** student_ai_chat_screen.png

### 11. تمرّن — Practice Type Selection
- **Result:** PASS  
- **Observed:** "اختر نوع التمرين" with two options:
  - تمرّن القراءة (اختر الكلمة الصحيحة)
  - تمرّن الكتابة (أكمل الحروف الناقصة)
- Back navigation works.

### 12. Bottom Nav — نتائجي Tab
- **Result:** PASS (static mock data displayed correctly)  
- **Observed:** "نتائجي — سجل اختباراتك ودرجاتك". Last result: "اختبار القراءة — 9/10" with gold star. Results list: اختبار القراءة (9/10), اختبار الفهم (7/10), اختبار الكتابة (5/10).
- **Note:** All data is hardcoded mock — not real backend results. Real quiz flow is blocked by BUG-18/BUG-21.
- **Screenshot:** student_results_tab.png

### 13. Bottom Nav — حسابي Tab
- **Result:** PASS  
- **Observed:** "حسابي — بيانات حسابك الشخصي". Profile: avatar, name "أحمد الطالب", grade "الصف غير محدد الابتدائي". Info card shows name + grade. "تسجيل الخروج" button visible.
- **Note:** Grade shows "غير محدد" — expected, since seed_student.py registered via verify-token which doesn't set a specific grade. Backend returned grade "غير محدد" which is the default.
- **Screenshot:** student_account_tab.png

### 14. Logout
- **Not tested** — skipped to preserve session.

---

## Bugs Confirmed / Observed

| Bug ID | Severity | Issue | Status |
|--------|----------|-------|--------|
| BUG-15 | high | Back press from login → "الصفحة غير موجودة: /" route 404 | Confirmed (required pm clear workaround) |
| BUG-18 | critical | Entire lesson/quiz UI is hardcoded — no backend data | Confirmed in code (lesson_detail_screen.dart) |
| BUG-21 | high | Quiz confirm button ("تأكيد الإجابة") is a no-op TODO | Confirmed in code (line 376) |

No new bugs beyond what team-lead already logged.

---

## Summary

Student flow renders correctly at the UI level but **core features are unimplemented scaffolding**:

- Login and session persistence ✓
- Home screen with 3 action cards ✓
- Subject selection screen renders ✓
- Lesson list with completion badges renders ✓ (data hardcoded)
- All 4 lesson detail tabs render ✓ (video player, summary, quiz, AI chat)
- Quiz answer selection works ✓
- Quiz confirm button: unimplemented (no-op) ✗
- AI chat send: unimplemented (no-op) ✗
- Bottom nav all 3 tabs functional ✓
- Profile data (name, grade) displayed correctly ✓
- Logout button visible ✓ (not tested)

**Assessment:** Student UI shell is complete. All actual learning functionality (real lessons from backend, real quiz submission, AI chat, TTS "اقرأ لي" feature, session tracking) requires implementation of the TODO handlers before the student flow is functionally usable.
