# Admin Panel E2E Test Report
**Date:** 2026-05-13  
**Base URL:** http://localhost:3000  
**Tester:** team-lead  

---

## Test Environment
- Admin Next.js dev server: http://localhost:3000 (running)
- Backend API: http://178.105.109.153:8001/api (remote)
- NEXT_PUBLIC_API_URL: http://178.105.109.153:8001/api (NOT localhost)
- Firebase project: diaa-fc2d3

---

## Test Results

### 1. Login Page Load
- **URL:** http://localhost:3000/
- **Result:** PASS
- **Status:** Page renders correctly — brand heading "ضياء", email/password fields, submit button, RTL layout
- **Console errors:** Only favicon 404 (non-issue) and autocomplete attribute warning
- **Screenshot:** test_artifacts/screenshots/admin_login_page.png

### 2. Login — Mock mode with valid-format credentials (localhost)
- **Action:** Fill admin@diaa.com / admin123, click تسجيل الدخول
- **Result:** FAIL — BUG-4, BUG-5
- **Expected:** On localhost, mock mode should bypass Firebase auth and land on /dashboard
- **Actual:** 
  - Firebase sign-in attempt → 400 from identitytoolkit.googleapis.com (caught, swallowed)
  - GET /api/auth/me → 401 (caught, swallowed — mock mode continues)
  - router.push('/dashboard') called
  - Next.js RSC fetch fails: "Failed to fetch RSC payload for /dashboard"
  - Falls back to browser navigation → navigates to /dashboard
  - DashboardLayout's `onAuthStateChanged` fires immediately with no user
  - `isMockMode` check: `NEXT_PUBLIC_API_URL.includes('localhost')` = FALSE (points to remote server)
  - Auth guard calls router.push('/') — redirects back to login
  - **No error message shown to user — silent failure loop**
- **Console evidence:** `.playwright-mcp/console-2026-05-13T13-55-48-599Z.log` lines 4-19
- **Network evidence:** test_artifacts/logs/admin_network_requests.txt
- **Screenshot:** test_artifacts/screenshots/admin_login_after_submit.png, admin_login_silent_failure.png

### 3. Login — Wrong credentials (localhost)
- **Action:** Fill wrong@test.com / wrongpass, click تسجيل الدخول
- **Result:** FAIL — same as test #2
- **Expected:** Error message shown, or in mock mode, proceed
- **Actual:** Same silent failure — no error message, page stays on login, spinner eventually stops
- **Root cause:** Same as BUG-4 + BUG-5

### 4. Dashboard page direct navigation
- **URL:** http://localhost:3000/dashboard
- **Result:** FAIL — BUG-4
- **Expected:** On localhost, DashboardLayout 3-second timeout fallback should allow access
- **Actual:** `onAuthStateChanged` fires in < 1s with no Firebase user → `isMockMode` is false → `router.push('/')` → redirected to login page before 3s timeout fires
- **Page after wait:** http://localhost:3000/ (login page)

### 5. Lessons page direct navigation
- **URL:** http://localhost:3000/lessons
- **Result:** FAIL — same auth guard redirect as #4
- **Root cause:** All pages use DashboardLayout with the same broken mock-mode check

### 6. API calls from admin panel
- **Observed:** GET /api/auth/me → 401 (correct, no token sent)
- **Observed:** GET /api/admin/dashboard → 401 (correct, no token sent — called by dashboard page before redirect)
- **No data leakage, no 500 errors from API side**

---

## Bugs Found

| Bug ID | Severity | Issue |
|--------|----------|-------|
| BUG-4 | high | DashboardLayout mock-mode check uses wrong condition — always redirects on localhost when NEXT_PUBLIC_API_URL points to remote |
| BUG-5 | medium | Login page shows no error message after failed login + redirect loop — silent failure |

---

## Root Cause Analysis — BUG-4

In `DashboardLayout.tsx` line 41:
```ts
const isMockMode = process.env.NEXT_PUBLIC_API_URL?.includes('localhost');
```
`NEXT_PUBLIC_API_URL` is `http://178.105.109.153:8001/api` — does NOT include 'localhost'.
So `isMockMode` is always `false`, and when Firebase reports no user, auth guard redirects.

The check on line 27 (timeout fallback) uses `window.location.hostname === 'localhost'` correctly,
but it never runs because `onAuthStateChanged` resolves in < 1s, before the 3s timeout.

**Fix:** Change line 41-44 in DashboardLayout.tsx:
```ts
// Replace:
const isMockMode = process.env.NEXT_PUBLIC_API_URL?.includes('localhost');
if (isMockMode || window.location.hostname === 'localhost') {

// With:
if (window.location.hostname === 'localhost') {
```

---

## Root Cause Analysis — BUG-5

In `page.tsx` (login), after catching both the Firebase error and `/auth/me` 401 in mock mode,
`router.push('/dashboard')` is called. This triggers Next.js RSC fetch which fails (network error),
falls back to browser navigation, then DashboardLayout immediately redirects back to `/`.
The outer try/catch in `handleSubmit` never receives any thrown error, so `setError()` is never called.
The user sees the login form again with no message.

**Fix:** After `router.push('/dashboard')`, if navigation fails or the user ends up back on `/`,
display a message. Or better: fix BUG-4 first (the auth guard), which will fix the redirect loop.

---

## Pages Not Testable (blocked by BUG-4)
- /dashboard — admin stats, recent lessons
- /lessons — lesson list, add/edit/delete lesson modal
- /quizzes — quiz management
- /subjects — subject management
- Sidebar navigation between pages
- Header user info / logout
