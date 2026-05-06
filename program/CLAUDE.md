# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Edu Smart Assistant — AI-powered educational app for Saudi elementary students (grades 1-6). Monorepo with 3 systems: Flutter mobile app, FastAPI backend, Next.js admin panel. All UI is Arabic RTL. Documentation is in Arabic.

## Architecture

```
mobile/lib/    → Flutter (Dart) — Student + Parent app
backend/app/   → FastAPI (Python) — API server + AI services
admin/src/     → Next.js (TypeScript) — Admin dashboard
```

**Data flow:** Flutter App → FastAPI Backend → PostgreSQL + External APIs (EasyOCR, Azure TTS, OpenAI GPT-4o-mini) → Response back to app.

**Backend layered pattern:** `routers/` (endpoints) → `services/` (business logic) → `models/` (SQLAlchemy ORM) + `schemas/` (Pydantic validation). Standard response format: `{ success: bool, data: any, message: str }`.

**Flutter pattern:** `screens/` (UI) → `providers/` (ChangeNotifier state) → `services/` (Dio HTTP) → `models/` (data classes with fromJson/toJson).

**Admin pattern:** `app/` (Next.js pages with App Router) → `components/` (React) → `services/` (Axios HTTP) → `types/` (TypeScript interfaces).

## Development Commands

### Backend

```bash
cd backend
python -m venv venv && venv\Scripts\activate   # Windows
python -m venv venv && source venv/bin/activate # Mac
pip install -r requirements.txt
alembic upgrade head                            # Run DB migrations
uvicorn app.main:app --reload --port 8000       # Start dev server
python test_connections.py                      # Test all external services
```

### Flutter

```bash
cd mobile
flutter pub get
flutter run                # Run on connected device/emulator
flutter run -d chrome      # Run on web for quick testing
```

### Admin

```bash
cd admin
npm install
npm run dev                # Start on localhost:3000
npm run build              # Production build
npm run lint               # Lint check
```

## Key Configuration

- **Backend .env:** DATABASE_URL, FIREBASE_CREDENTIALS_PATH, AZURE_SPEECH_KEY, AZURE_SPEECH_REGION, OPENAI_API_KEY
- **Admin .env.local:** NEXT_PUBLIC_API_URL, NEXT_PUBLIC_FIREBASE_API_KEY, NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN, NEXT_PUBLIC_FIREBASE_PROJECT_ID
- **Flutter Firebase:** `google-services.json` in `mobile/android/app/`, `GoogleService-Info.plist` in `mobile/ios/Runner/`

## Team Ownership & Branches

Files are assigned to specific students. Each student works on `feature/[name]` branch. Check `docs/03_Team_Distribution.md` for exact file-to-student mapping before modifying files.

| Team | Members | Scope |
|------|---------|-------|
| Backend | مشاعل، فاطمة، رنيم | FastAPI routers, models, schemas, middleware |
| AI Core | فرح، ريناد، فدوه | backend/app/services/ (ocr, tts, chat, quiz, report) |
| Flutter | ديمة، رهف، حياة | mobile/lib/ (screens, providers, services, widgets) |
| Admin | جود، جود2 | admin/src/ (pages, components, services) |

## Conventions

- All user-facing text must be in Arabic
- Flutter UI: RTL layout, pastel colors, minimum 48dp touch targets (child-friendly)
- Backend API prefix: `/api/` (e.g., `/api/auth/`, `/api/student/`, `/api/scan/`)
- Auth: Firebase Auth tokens verified by backend middleware on every request
- Database: PostgreSQL with UUID primary keys, Alembic migrations
- AI Chat is restricted to lesson content only — never answers off-topic questions
- Files currently contain implementation hints as comments (Phase 1 scaffolding) — replace comments with actual code when implementing

## Reference Docs

- `docs/01_PRD_EduSmartAssistant.md` — Full product requirements (features, DB schema, API endpoints)
- `docs/02_Architecture_Codebase.md` — Codebase structure
- `docs/03_Team_Distribution.md` — File ownership per student with weekly tasks
- `docs/01_Timeline.md` — 4-week development timeline (Feb 26 – Mar 26, 2026)