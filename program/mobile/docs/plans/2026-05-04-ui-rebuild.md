# ضياء UI Rebuild — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Rebuild all Flutter mobile screens to match the `ui.html` reference design — purple palette, Tajawal font, new layout patterns. UI layer only; providers/services/models unchanged.

**Architecture:** Replace theme (blue→purple, Cairo→Tajawal), build shared widgets (bottom nav, top bar, cards), then rewrite each screen group. The student dashboard becomes a shell with BottomNavigationBar + IndexedStack. Login merges role selection into a tab switcher. Lesson detail uses TabBar.

**Tech Stack:** Flutter/Dart, google_fonts (Tajawal), provider (existing), existing services/models.

---

## Task 1: Theme + Constants

**Files:**
- Modify: `lib/config/theme.dart` (full rewrite)
- Modify: `lib/config/constants.dart` (update app name + design constants)
- Modify: `lib/app.dart` (update app title)

**What to do:**

Rewrite `theme.dart` with this palette (from ui.html `:root`):
- `primary100 = #8B5FBF`, `primary200 = #61398F`
- `accent100 = #D6C6E1`, `accent200 = #9A73B5`
- `text100 = #4A4A4A`, `text200 = #878787`
- `bg100 = #F5F3F7`, `bg200 = #E9E4ED`, `bg300 = #FFFFFF`
- `radius = 18.0`, `radiusSm = 12.0`
- Font: `GoogleFonts.tajawalTextTheme()` everywhere (replace all Cairo references)
- Shadow: `BoxShadow(color: Color(0x268B5FBF), blurRadius: 32, offset: Offset(0, 8))`
- Shadow large: `BoxShadow(color: Color(0x3861398F), blurRadius: 48, offset: Offset(0, 16))`
- ElevatedButton: bg `#61398F`, radius 12, padding 15, shadow purple
- InputDecoration: bg `#F5F3F7`, border `#E9E4ED`, focusBorder `#8B5FBF`, radius 12
- AppBar: bg white, foreground text100, no elevation, border bottom bg200
- Card: radius 18, shadow purple-tinted, white bg

Update `constants.dart`:
- `appName = 'ضياء'`
- `appNameAr = 'ضياء'`
- `appTagline = 'رفيق التعلم الذكي'`
- `borderRadius = 18.0`
- `borderRadiusSm = 12.0`

Update `app.dart` title to `'ضياء'`.

**Commit:** `feat: update theme to ضياء purple palette with Tajawal font`

---

## Task 2: Shared Widgets

**Files:**
- Modify: `lib/widgets/custom_button.dart` (restyle)
- Modify: `lib/widgets/custom_text_field.dart` (restyle)
- Create: `lib/widgets/diyaa_bottom_nav.dart`
- Create: `lib/widgets/diyaa_top_bar.dart`
- Create: `lib/widgets/diyaa_inner_nav.dart`
- Create: `lib/widgets/diyaa_menu_card.dart`

### 2a: `custom_button.dart`
Restyle: bg `#61398F`, radius 12, padding 15, Tajawal bold, purple shadow `0 4px 16px rgba(139,95,191,0.4)`. Keep existing API (text, onPressed, isLoading, icon, color, width). Add `variant` param: `primary` (filled purple), `outline` (transparent + purple border), `ghost` (semi-transparent white), `white` (white bg, purple text).

### 2b: `custom_text_field.dart`
Restyle: bg `#F5F3F7`, border 1.5px `#E9E4ED`, focusBorder `#8B5FBF`, radius 12, Tajawal font, RTL direction. Remove prefixIcon (not in reference), use label above field pattern (label as separate Text widget above the input, not inside).

### 2c: `diyaa_bottom_nav.dart`
3-tab bottom navigation matching `.bottom-nav` in ui.html:
- White background, top border `bg200`, height ~60
- Each tab: icon (emoji text or Icon) + label
- Active: `primary200` color, inactive: `text200`
- Params: `currentIndex`, `onTap(int index)`
- Tabs configurable via `items: List<BottomNavItem>` where `BottomNavItem({String icon, String label})`

### 2d: `diyaa_top_bar.dart`
Gradient top bar matching `.top-bar` in ui.html:
- Background: `#61398F` solid
- Curved bottom: use `ClipPath` or `Container` with bottom border radius 40px
- Has: greeting text (small, white 75% opacity), name (large, white, bold 800), grade (accent100, small)
- Optional: badge in top-left (stars/streak)
- Params: `greeting`, `name`, `grade`, `badgeText`

### 2e: `diyaa_inner_nav.dart`
Inner screen navigation bar matching `.inner-nav`:
- White bg, padding 16x20, bottom border `bg200`
- Back button: 36x36, bg `bg100`, radius 10, arrow icon
- Title: text100, 1rem, bold 700
- Params: `title`, `onBack` (defaults to Navigator.pop), `trailing` widget optional

### 2f: `diyaa_menu_card.dart`
Menu card matching `.menu-card`:
- White bg, radius 18, padding 18x20, row layout
- Icon container: 52x52, radius 16, gradient background
- Title (bold) + description (small, text200)
- Trailing arrow `‹`
- Params: `icon` (String emoji), `iconGradient` (list of colors), `title`, `description`, `onTap`

**Commit:** `feat: add ضياء shared widgets (bottom nav, top bar, inner nav, menu card)`

---

## Task 3: Splash Screen

**Files:**
- Modify: `lib/screens/splash/splash_screen.dart` (full rewrite)

**What to do:**
Match `.splash` in ui.html:
- Background: `LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2D1B4E), Color(0xFF1a0f30)])`
- Radial glow: center of screen, purple radial gradient overlay
- Center: app logo image (if exists in assets, else use 📚 emoji in rounded container) + "ضياء" text (white, 2.8rem, weight 900)
- Bottom: tagline "رفيق التعلم الذكي" (accent100, 0.95rem, 300 weight, 80% opacity) + 3 bouncing dots loader
- Bouncing dots: 3 circles, 8px, purple, staggered animation
- Keep existing auth check logic from `_checkAuthAndNavigate()` — only change the `build()` method
- Navigation: after 3s, same logic → check auth → route to login or dashboard

**Commit:** `feat: rebuild splash screen with dark purple gradient design`

---

## Task 4: Login Screen (Combined)

**Files:**
- Modify: `lib/screens/auth/student_login_screen.dart` → rename concept to combined login
- Modify: `lib/screens/auth/parent_login_screen.dart` (keep but simplify — redirect to combined)
- Modify: `lib/screens/auth/role_selection_screen.dart` → repurpose as the combined login screen
- Modify: `lib/config/routes.dart` (update routing)

**What to do:**
Repurpose `role_selection_screen.dart` into a **combined login screen** matching `.login-screen` in ui.html:
- White bg, padding 24
- Top: logo image (90x90) or fallback icon, "أهلاً بك في ضياء" title, "سجل دخولك للمتابعة" subtitle
- Role tabs: `.role-tabs` — segmented control with "🎓 طالب" and "👨‍👧 ولي أمر"
  - Container with bg200 background, radius 12, padding 4
  - Active tab: bg primary100, white text, purple shadow
  - Inactive: text200
- Form fields: email + password (using CustomTextField)
- Primary button: "تسجيل الدخول"
- When parent tab active: show additional "تسجيل" outline button + "نسيت كلمة المرور؟" link
- Use existing AuthProvider.login() with role param based on active tab
- On success: route to studentDashboard or parentDashboard based on tab

Update `routes.dart`:
- `roleSelection` route now points to the combined login screen
- Keep `studentLogin` and `parentLogin` routes pointing to the same combined screen (or remove them and redirect)
- Splash navigates to `roleSelection` (which is now the login screen)

**Commit:** `feat: rebuild login as combined screen with student/parent tab switcher`

---

## Task 5: Parent Register Screen

**Files:**
- Modify: `lib/screens/auth/parent_register_screen.dart`

**What to do:**
Match the parent signup screen in ui.html:
- Uses `.sms-screen` layout: white bg, centered content
- Icon wrap: 70x70, purple gradient bg, radius 24, "👨‍👩‍👧" emoji
- Title: "تسجيل وليّ الأمر" (1.3rem, bold)
- Subtitle: "أنشئ حسابك للمتابعة مع أبنائك"
- Form fields: name, phone, email, password
- Primary button: "تسجيل"
- Keep existing provider logic

**Commit:** `feat: rebuild parent register screen`

---

## Task 6: Student Dashboard Shell (Bottom Nav)

**Files:**
- Modify: `lib/screens/student/student_dashboard_screen.dart` (full rewrite)
- Create: `lib/screens/student/student_home_tab.dart`
- Create: `lib/screens/student/student_results_tab.dart`
- Create: `lib/screens/student/student_account_tab.dart`

**What to do:**

### 6a: `student_dashboard_screen.dart`
Convert to a shell with BottomNavigationBar:
- Scaffold with no AppBar
- Body: `IndexedStack` with 3 children (home, results, account tabs)
- Bottom: `DiyaaBottomNav` with items: `[🏠 الرئيسية, 🏆 نتائجي, 👤 حسابي]`
- State: `_currentIndex` tracking active tab
- Keep existing `initState` fetchDashboard call

### 6b: `student_home_tab.dart`
Match the "child home" screen in ui.html:
- `DiyaaTopBar` with greeting "مرحباً 🌟", student name, grade
- Content area with padding:
  - Section title: "ماذا تريد أن تفعل؟" (text100, 0.85rem, bold)
  - 3 `DiyaaMenuCard`s:
    1. 📚 "ابدأ التعلم" / "دروس الفيديو والملخصات" → navigate to subjects
    2. 🔊 "اقرأ لي" / "صوّر أي نص وأسمعه لك" → navigate to scanPage
    3. ✏️ "تمرّن" / "اختبر نفسك وتحسّن" → navigate to practice selection
  - Card icon gradients: purple solid, teal gradient, pink-orange gradient
- Read student name/grade from StudentProvider

### 6c: `student_results_tab.dart`
Match "نتائجي" tab in ui.html:
- Top bar: "🏆 نتائجي" as greeting, "سجل اختباراتك ودرجاتك" as grade
- Last result card: star icon + lesson name + score
- List of all results using lesson-item style cards with score chips
- Score chips: green for ≥8/10, yellow/amber for 6-7, red for <6
- Read from StudentProvider or QuizProvider if available

### 6d: `student_account_tab.dart`
Match "حسابي" tab in ui.html:
- Top bar: "👤 حسابي" as greeting, "بيانات حسابك الشخصي" as grade
- Profile avatar: 82x82 circle, purple gradient, emoji
- Name (large, bold) + grade
- Info card: white, rounded, 2 rows (name, grade) with divider
- Logout button: outline red, "🚪 تسجيل الخروج"
- Use AuthProvider.logout()

**Commit:** `feat: rebuild student dashboard with bottom nav and 3 tabs`

---

## Task 7: Subject Selection + Lesson List

**Files:**
- Create: `lib/screens/student/subject_selection_screen.dart`
- Create: `lib/screens/student/lesson_list_screen.dart`
- Modify: `lib/config/routes.dart` (add routes)

### 7a: `subject_selection_screen.dart`
Match "اختر المادة" in ui.html:
- DiyaaInnerNav: title "ابدأ التعلم"
- Section title: "اختر المادة الدراسية"
- Subject cards (`.subject-card`): white, radius 18, border 2px transparent, hover→primary100
  - Icon: 52x52, radius 16, gradient bg, emoji
  - Title + subtitle (lesson count + grade)
  - Arrow trailing
- Subjects: لغتي (blue-purple gradient), العلوم (green gradient)
- Navigate to lesson list on tap

### 7b: `lesson_list_screen.dart`
Match "قائمة الدروس" in ui.html:
- DiyaaInnerNav: title "لغتي — الصف الثاني" (dynamic)
- Section title: "اختر الدرس"
- Lesson items (`.lesson-item`): white, radius 12, row layout
  - Status circle: 28x28, done=green check, todo=dashed border
  - Title + subtitle (مكتمل / غير مكتمل)
  - Button: "فتح" (bg200) or "ابدأ" (primary, active)
- Navigate to lesson detail on tap
- Use LessonProvider data if available

**Commit:** `feat: add subject selection and lesson list screens`

---

## Task 8: Lesson Detail (Tabbed)

**Files:**
- Create: `lib/screens/student/lesson_detail_screen.dart`
- Modify: `lib/screens/student/ai_chat_screen.dart` (restyle as embedded tab)
- Modify: `lib/config/routes.dart` (add route)

**What to do:**
Match section 3 of ui.html — lesson detail with 4 tabs:

- DiyaaInnerNav: title = lesson name
- TabBar below nav: 4 tabs: "① فيديو", "② الملخص", "③ اختبر", "④ اسأل"
  - Style: white bg, bottom border, active = primary200 text + primary100 underline
- TabBarView with 4 tab contents:

**Tab 1 — Video:**
- Dark area (`.video-area`): bg `#1a1a2e`, height 160, radius 18, centered play button
- Play button: 56x56, purple circle, "▶" icon

**Tab 2 — Summary:**
- "🔊 استمع للملخص" section title
- Audio bar (`.audio-bar`): white, radius 12, play button + wave bars + time
- "📄 النص" section title
- Text box: white, radius 12, lesson text content

**Tab 3 — Quiz:**
- Question counter: "السؤال ١ من ٣" + progress dots
- Quiz card (`.quiz-card`): white, radius 12
  - Question text (bold)
  - Options (`.quiz-opt`): bg100, radius 10, border 2px transparent
  - Selected: purple border + purple tint
  - Correct: green border + green bg + ✔️
  - Wrong: red border + red bg + ❌ (also show correct in green)
  - Feedback banner: green (correct) or orange (wrong) with emoji + message
  - "التالي" button
- Use existing quiz provider logic

**Tab 4 — AI Chat:**
- "🤖 اسأل بالدرس (AI)" section title
- Chat area: white, radius 12
  - AI message bubble: bg100, radius 0-12-12-12 (top-left square)
  - Input row: text field + send button (purple, 38x38, radius 10)
- Adapt existing AiChatScreen logic into this tab

**Commit:** `feat: add lesson detail screen with 4-tab layout`

---

## Task 9: Quiz Result Screen

**Files:**
- Modify: `lib/screens/quiz/quiz_result_screen.dart`

**What to do:**
Match result screen in ui.html:
- Full-screen purple bg (`#61398F`)
- Top nav: semi-transparent bg, back button, "نتيجة الاختبار" title
- Trophy emoji (animated bounce)
- "أحسنت!" title (white, 1.4rem, 900)
- Subtitle with lesson name
- Score circle: 70x70, border 6px white 30%, bg white 12%, number + "من ٣"
- Correct/wrong breakdown: 2 cards side by side (semi-transparent white)
- Encouraging message card
- Buttons: "🔁 إعادة الاختبار" (white) + "🏠 العودة للرئيسية" (ghost)
- Keep existing quiz result data from provider

**Commit:** `feat: rebuild quiz result screen with purple score display`

---

## Task 10: Practice Flow

**Files:**
- Create: `lib/screens/quiz/practice_selection_screen.dart`
- Modify: `lib/screens/quiz/reading_quiz_screen.dart`
- Modify: `lib/screens/quiz/writing_quiz_screen.dart`
- Modify: `lib/config/routes.dart`

### 10a: `practice_selection_screen.dart`
Match practice select in ui.html:
- DiyaaInnerNav: title "تمرّن"
- "اختر نوع التمرين" section title
- 2 practice cards: reading (📖, blue-purple gradient) + writing (✏️, pink gradient)
- Each card: row layout, icon + title + description + arrow
- Navigate to reading or writing quiz

### 10b: `reading_quiz_screen.dart`
Match reading practice in ui.html:
- DiyaaInnerNav: "تمرّن القراءة" + question counter trailing
- Progress bar with label ("التقدم" + percentage)
- "استمع" button at top-right
- Text passage in white card
- Question + quiz options (same style as lesson quiz)
- "التالي" button
- Keep existing quiz logic

### 10c: `writing_quiz_screen.dart`
Match writing practice in ui.html:
- DiyaaInnerNav: "تمرّن الكتابة" + counter trailing
- Progress bar
- "استمع" button
- Fill blank area: word displayed with letters, one blank (dashed border)
- Letter keyboard: grid of letter buttons, highlighted correct one
- "التالي" button
- Keep existing quiz logic

**Commit:** `feat: rebuild practice flow (selection, reading, writing)`

---

## Task 11: OCR/TTS Flow (Camera + Result + History)

**Files:**
- Modify: `lib/screens/student/scan_page_screen.dart`
- Modify: `lib/screens/student/text_display_screen.dart`
- Create: `lib/screens/student/reading_history_screen.dart`
- Modify: `lib/config/routes.dart`

### 11a: `scan_page_screen.dart`
Match camera screen in ui.html:
- Dark theme: bg `#0d0d14`
- Dark nav bar: semi-transparent, white text, back button
- Viewfinder: flex area, dashed purple border, radius 20, corner markers (purple)
- Camera icon + "وجّه الكاميرا نحو الصفحة" text
- Capture button: full-width, purple, "📷 التقاط الصورة"
- History link: "🕒 سجل القراءات" → navigate to history
- Keep existing camera logic

### 11b: `text_display_screen.dart`
Match OCR result in ui.html:
- DiyaaInnerNav: "نتيجة اقرأ لي"
- Success badge: green bg, "✅ تم استخراج النص بنجاح"
- Text box: white, radius 12, extracted text
- Audio section: "🔊 تشغيل الصوت" + audio bar
- Save button: bg200, purple text, "💾 حفظ في السجل"
- Keep existing OCR/TTS logic

### 11c: `reading_history_screen.dart`
Match history screen in ui.html:
- DiyaaInnerNav: "سجل القراءات"
- List of history items:
  - Icon (📄) + text preview + date
  - Action buttons: 🔊 (play) + 📄 (view)

**Commit:** `feat: rebuild OCR/TTS screens (camera, result, history)`

---

## Task 12: Parent Dashboard

**Files:**
- Modify: `lib/screens/parent/parent_dashboard_screen.dart` (full rewrite)

**What to do:**
Match parent home in ui.html:
- No AppBar — custom top bar instead
- Parent top bar: gradient `linear-gradient(135deg, #1a0f30, #61398F)`, curved bottom
  - "مرحباً،" label + parent name (bold)
  - Child tag: pill with child name + grade
  - "أبنائي" button (semi-transparent)
- Child summary card: purple-tinted bg, rounded
  - Avatar + name + grade + "نشطة ✓" badge
  - 3 stat mini-cards: lessons completed, avg score, streak days
- Menu items: 3 parent menu cards
  - ✅ الدروس المكتملة
  - 📊 التقدم والمستوى
  - 🏆 نتائج الاختبارات
- Keep existing ParentProvider logic (fetchChildren, selectedChild, weeklyReport)

**Commit:** `feat: rebuild parent dashboard with child summary and menu`

---

## Task 13: Parent Sub-screens

**Files:**
- Modify: `lib/screens/parent/reports_screen.dart` → split into multiple screens or add tabs
- Create: `lib/screens/parent/parent_progress_screen.dart`
- Create: `lib/screens/parent/parent_results_screen.dart`
- Create: `lib/screens/parent/completed_lessons_screen.dart`
- Create: `lib/screens/parent/my_children_screen.dart`
- Modify: `lib/screens/parent/add_child_screen.dart`
- Modify: `lib/config/routes.dart`

### 13a: `parent_progress_screen.dart`
Match "التقدم والمستوى" in ui.html:
- DiyaaInnerNav: "التقدم والمستوى"
- Level indicator: card with 4 dots (ضعيف/متوسط/جيد/متقدم), active highlighted
- Weekly chart: bar chart with 7 days, purple gradient bars
- Use fl_chart or custom painted bars

### 13b: `parent_results_screen.dart`
Match "نتائج الاختبارات" in ui.html:
- DiyaaInnerNav: "نتائج الاختبارات"
- Last result summary card (purple tint)
- Table: header row + data rows
  - Columns: النوع, الدرجة (score chip), التاريخ
  - Score chips: green (≥8), amber (6-7), red (<6)

### 13c: `completed_lessons_screen.dart`
Match "الدروس المكتملة":
- DiyaaInnerNav: "الدروس المكتملة"
- Summary badge: "٦ من ١٠ دروس"
- Lesson cards: check icon + name + subject/day + "مكتمل" badge

### 13d: `my_children_screen.dart`
Match "أبنائي":
- DiyaaInnerNav: "أبنائي"
- Child cards with: avatar, name, grade, "محدد ✓" or "اختيار" button, ⚙️ settings button
- Active child: purple border

### 13e: `add_child_screen.dart`
Restyle existing:
- DiyaaInnerNav: "إضافة طفل"
- Form: name, grade dropdown, gender
- Purple primary button
- Keep existing logic

**Commit:** `feat: add parent sub-screens (progress, results, lessons, children)`

---

## Task 14: Routes Update (Final)

**Files:**
- Modify: `lib/config/routes.dart` (add all new routes)

**What to do:**
Add all new route constants and cases:
```
subjects → SubjectSelectionScreen
lessons → LessonListScreen
lessonDetail → LessonDetailScreen
practiceSelect → PracticeSelectionScreen
readingHistory → ReadingHistoryScreen
parentProgress → ParentProgressScreen
parentResults → ParentResultsScreen
completedLessons → CompletedLessonsScreen
myChildren → MyChildrenScreen
```

Remove deprecated routes if any. Ensure splash → login (combined) → dashboard flow works.

**Commit:** `feat: update routes with all new screens`

---

## Task 15: Final Polish + Verify

- Run `flutter analyze` — fix any warnings
- Run app on emulator/chrome — verify each screen visually
- Check RTL layout consistency across all screens
- Verify all navigation flows work end-to-end
- Ensure no provider/service regressions

**Commit:** `chore: fix lint warnings and polish UI consistency`
