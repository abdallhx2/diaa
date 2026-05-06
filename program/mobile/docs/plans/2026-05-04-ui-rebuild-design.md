# UI Rebuild Design — ضياء App

## Goal
Rebuild all Flutter screens to match the reference `ui.html` design. UI layer only — providers, services, models stay intact.

## Theme
- **Primary**: #8B5FBF (light), #61398F (dark)
- **Accent**: #D6C6E1, #9A73B5
- **Text**: #4A4A4A (primary), #878787 (secondary)
- **Background**: #F5F3F7 (main), #E9E4ED (secondary), #FFFFFF (cards)
- **Font**: Tajawal (replacing Cairo)
- **Radius**: 18px standard, 12px small
- **Shadows**: Purple-tinted rgba(139,95,191,0.15)

## Shared Widgets
- `DiyaaBottomNav` — 3-tab bottom navigation
- `DiyaaTopBar` — Gradient top bar with curved bottom
- `DiyaaInnerNav` — Back button + title navigation bar
- `DiyaaMenuCard` — Icon + title + description + arrow card
- `DiyaaSubjectCard` — Subject selection card
- `DiyaaLessonItem` — Lesson list item with status
- `DiyaaQuizOption` — Quiz answer option with states (default, selected, correct, wrong)
- `DiyaaAudioBar` — Audio player with wave animation
- `DiyaaProgressBar` — Custom progress bar with label

## Screens (25 total)

### Auth (5)
1. Splash — dark purple gradient, logo, app name, bouncing dots
2. Login — combined student/parent tab switcher
3. Parent Signup — form with name, phone, email, password
4. Forgot Password — phone input
5. OTP + Reset Password (can be combined or separate)

### Student (8)
6. Dashboard shell with BottomNav (home/results/account)
7. Home tab — top bar + 3 menu cards
8. Results tab — score history list
9. Account tab — profile info + logout
10. Subject Selection — subject cards
11. Lesson List — lessons with done/todo status
12. Lesson Detail — 4-tab layout (video, summary, quiz, AI chat)
13. Quiz Result — purple bg, score circle, breakdown

### Practice (4)
14. Practice Selection — reading vs writing cards
15. Reading Practice — passage + MCQ with listen button
16. Writing Practice — fill missing letters with keyboard
17. Practice Result — score + retry

### OCR/TTS (3)
18. Camera — dark theme, viewfinder, capture button
19. OCR Result — extracted text + audio bar
20. Reading History — list of past scans

### Parent (5)
21. Dashboard — child summary stats + menu
22. Progress — level indicator + weekly chart
23. Results Table — score list with chips
24. Completed Lessons — lesson cards with status
25. My Children — child list + select/settings

## Navigation Changes
- Remove `RoleSelectionScreen` (merged into login)
- Login screen handles role switching via tabs
- Student dashboard uses `BottomNavigationBar` with `IndexedStack`
- Lesson detail uses `TabBar` + `TabBarView`
- Add new routes for: forgot-password, otp, reset-password, lesson-detail, subjects, lessons, practice-select, reading-practice, writing-practice, practice-result, ocr-history, parent-progress, parent-results, completed-lessons, my-children, my-results, my-account
