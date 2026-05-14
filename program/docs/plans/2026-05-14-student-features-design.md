# Student Features — End-to-End Implementation Design

**Date:** 2026-05-14
**Status:** Approved (option A — MVP صادق)
**Author:** team-lead (orchestrated)

## Problem

E2E QA found the entire student-facing app shell is mock data: subjects, lessons, the lesson detail tabs, quiz submission, AI chat send, and TTS playback are all stubs / `TODO`s (see `test_artifacts/BUGS.md` BUG-16, BUG-18, BUG-21). The backend itself is missing the read endpoints a student would need to browse lessons. Goal: make the six student menu items actually work end-to-end against the deployed backend at `http://178.105.109.153:8001`.

## Scope

**In scope (option A — MVP):**
- ابدأ التعلم: subjects → lessons → lesson detail with real data
- 4 lesson tabs: نص (real), ملخص (lazy AI-generated), اختبر (real quizzes via API), اسأل (real chat)
- اقرأ لي: TTS playback wired to existing scan flow
- تمرّن (practice): random quiz across grade lessons
- Session start on lesson open, end on close
- Seed 4 lessons + ~12 quizzes so the UI has something to render

**Out of scope:**
- Video player (placeholder stays)
- WebSocket session updates
- Cloud-stored TTS files (use the bucket the backend already targets; if 500, log + fallback to disabled play button)
- Push notifications / streaks / gamification
- Admin panel for lesson upload (students get seeded data)

## Backend Changes

### Schema
1. Add `lessons.summary TEXT NULL` column (Alembic migration). Generated lazily by `chat_service.summarize(text)` and cached on first request.

### New endpoints (`app/routers/lesson_router.py`, mounted at `/api/lessons`)
| Method | Path | Auth | Returns |
|---|---|---|---|
| GET | `/api/lessons/subjects?grade=X` | student | `{ subjects: ["لغتي", "العلوم", ...] }` distinct subjects for a grade |
| GET | `/api/lessons?grade=X&subject=Y` | student | list of `{id, title, subject, grade_level}` (no body text) |
| GET | `/api/lessons/{id}` | student | full lesson `{id, title, subject, grade_level, original_text, summary, audio_url}` — generates summary if NULL |

### Schema fix (BUG-20)
`SessionStartRequest.session_type` becomes `Optional[str] = "scan"` so the start endpoint stops returning 422 when no source type is known.

### Seed script (`backend/scripts/seed_lessons.py`)
Inserts 4 lessons (2 in `لغتي`, 2 in `العلوم`, all `الثالث` to match our test student) with 3 multiple-choice quizzes each. Idempotent (skips on title match).

### Files touched
- `backend/app/models/lesson.py` (+1 column)
- `backend/alembic/versions/<new>.py` (migration)
- `backend/app/routers/lesson_router.py` (new)
- `backend/app/main.py` (mount router)
- `backend/app/schemas/student_schema.py` (`session_type` optional)
- `backend/app/services/chat_service.py` (+`summarize(text) -> str` helper)
- `backend/scripts/seed_lessons.py` (new)

## Mobile Changes

### New providers
- `SubjectsProvider` — `loadSubjects(grade)` → list
- `LessonsProvider` — `loadLessons(grade, subject)`, `loadDetail(id)`

### Rewritten / new screens
| File | Change |
|---|---|
| `subject_selection_screen.dart` | replace 2 hardcoded cards with `SubjectsProvider` list, loading + empty states |
| `lesson_list_screen.dart` | replace static list with `LessonsProvider.loadLessons` |
| `lesson_detail_screen.dart` | drop hardcoded text/quiz; load detail via `LessonsProvider.loadDetail`, hand `lessonId` to quiz + chat tabs; call `start_session` on init, `end_session` on dispose |
| `practice_select_screen.dart` (new) | pick subject → fetch random lesson → push quiz screen |
| Wire chat send (line 508) | `ChatProvider.ask(lessonId, text)` + render messages list |
| Wire quiz confirm (line 377) | `QuizProvider.submit(quizId, selected)` then advance to next question, show score at end |
| TTS playback in summary tab | `just_audio` `AudioPlayer` consuming `audio_url` from lesson detail or fresh `TtsService.generateSpeech(summary)` |
| `scan_page_screen.dart` "اقرأ لي" | OCR returns text → call TTS → play |

### Routes
Add `/practice/select` → `PracticeSelectScreen`.

## Data Flow
```
StudentHome → "ابدأ التعلم"
  → SubjectsProvider.loadSubjects(student.grade)
  → LessonsProvider.loadLessons(grade, subject)
  → LessonsProvider.loadDetail(id) + StudentService.startSession(id, "scan")
    ├ TabSummary: TtsService.generate(summary) → AudioPlayer
    ├ TabQuiz:    QuizService.getRandom(lessonId) → loop submit → result
    └ TabChat:    ChatService.askQuestion(text, lessonId) → message list
  → on dispose: StudentService.endSession(sessionId)
```

## Error Handling
- Backend 500 (TTS bucket misconfigured) → mobile shows "الصوت غير متاح حاليًا" and disables play; doesn't crash
- Empty subjects/lessons → friendly empty state ("لا توجد دروس متاحة لصفك حالياً")
- Quiz submit 500 → keep selection, allow retry
- Chat 500 → show error bubble, keep input

## Verification
For each implemented surface: launch app on emulator DMX, screenshot the working flow into `test_artifacts/screenshots/student-final/`. Update `BUGS.md` to close BUG-16, BUG-18, BUG-21, BUG-20.

## Build Sequence (parallel where safe)
1. Backend lessons migration + endpoints + seed (api-tester)
2. Mobile providers + subjects/lessons screens (bug-investigator)
3. Lesson detail wire-up: tabs + sessions (bug-investigator)
4. Practice screen + TTS playback (bug-investigator after 3)
5. Final E2E test on emulator (api-tester)

Backend deploy after step 1 so mobile work has a live target.
