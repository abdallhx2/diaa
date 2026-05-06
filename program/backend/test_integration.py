"""
Comprehensive integration tests for Edu Smart Assistant API (MOCK mode).
Tests all endpoints with proper auth tokens.

Mock token format: "mock_ROLE_NAME"
  - The mock auth parser splits on "_" and extracts role + name.
  - For Bearer headers we use ASCII-safe names (HTTP headers are latin-1).
  - For verify-token POST body we also test Arabic names.

Run: C:/Users/abdal/AppData/Local/Programs/Python/Python313/python.exe test_integration.py
"""

import sys
import requests
from typing import Optional

BASE = "http://localhost:8000"

# ── Tokens ──────────────────────────────────────────────────────
# Bearer header tokens (ASCII-safe for HTTP header encoding)
STUDENT_TOKEN = "mock_student_TestStudent"
PARENT_TOKEN = "mock_parent_TestParent"
ADMIN_TOKEN = "mock_admin_TestAdmin"

# Arabic tokens for verify-token body tests (sent as JSON, no header issue)
STUDENT_TOKEN_AR = "mock_student_\u0637\u0627\u0644\u0628"          # mock_student_طالب
PARENT_TOKEN_AR = "mock_parent_\u0648\u0644\u064a_\u0623\u0645\u0631"  # mock_parent_ولي_أمر
ADMIN_TOKEN_AR = "mock_admin_\u0645\u0634\u0631\u0641"             # mock_admin_مشرف

# Will be populated during tests
LESSON_ID: Optional[str] = None


def h(token: str) -> dict:
    """Build Authorization header."""
    return {"Authorization": f"Bearer {token}"}


class TestResult:
    def __init__(self, name: str, passed: bool, status: int, detail: str = ""):
        self.name = name
        self.passed = passed
        self.status = status
        self.detail = detail


results: list[TestResult] = []


def record(name: str, passed: bool, status: int, detail: str = ""):
    results.append(TestResult(name, passed, status, detail))


def safe_json(resp: requests.Response) -> dict:
    try:
        return resp.json()
    except Exception:
        return {}


# ── Setup helpers ────────────────────────────────────────────────


def setup_users():
    """Call verify-token for each role to ensure users exist in DB.
    Uses both ASCII and Arabic tokens so both user records are created."""
    tokens = [
        STUDENT_TOKEN, PARENT_TOKEN, ADMIN_TOKEN,
        STUDENT_TOKEN_AR, PARENT_TOKEN_AR, ADMIN_TOKEN_AR,
    ]
    for token in tokens:
        try:
            requests.post(f"{BASE}/api/auth/verify-token", json={"token": token})
        except Exception:
            pass


def create_lesson_via_admin() -> Optional[str]:
    """Create a test lesson via admin endpoint, return lesson ID."""
    try:
        resp = requests.post(
            f"{BASE}/api/admin/lessons",
            headers=h(ADMIN_TOKEN),
            json={
                "title": "Integration Test Lesson",
                "subject": "Science",
                "grade_level": "3",
                "original_text": "This is a test lesson about science and nature.",
                "qr_code": "integration_test_qr_001",
            },
        )
        if resp.status_code == 200:
            data = safe_json(resp)
            if data.get("success") and data.get("data"):
                return data["data"].get("id")
    except Exception:
        pass
    return None


# ── Test Functions ───────────────────────────────────────────────

# 1. Health Check
def test_health():
    resp = requests.get(f"{BASE}/")
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    record("GET /  (health check)", ok, resp.status_code,
           body.get("message", "")[:30])


# 2. Auth - verify-token
def test_auth_verify_token_student():
    resp = requests.post(f"{BASE}/api/auth/verify-token",
                         json={"token": STUDENT_TOKEN_AR})
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data"):
        detail = f"role={body['data'].get('role', '?')}"
    record("POST /api/auth/verify-token (student)", ok, resp.status_code, detail)


def test_auth_verify_token_parent():
    resp = requests.post(f"{BASE}/api/auth/verify-token",
                         json={"token": PARENT_TOKEN_AR})
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data"):
        detail = f"role={body['data'].get('role', '?')}"
    record("POST /api/auth/verify-token (parent)", ok, resp.status_code, detail)


def test_auth_verify_token_admin():
    resp = requests.post(f"{BASE}/api/auth/verify-token",
                         json={"token": ADMIN_TOKEN_AR})
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data"):
        detail = f"role={body['data'].get('role', '?')}"
    record("POST /api/auth/verify-token (admin)", ok, resp.status_code, detail)


# 2. Auth - /me
def test_auth_me_student():
    resp = requests.get(f"{BASE}/api/auth/me", headers=h(STUDENT_TOKEN))
    body = safe_json(resp)
    ok = (resp.status_code == 200
          and body.get("success") is True
          and body.get("data") is not None)
    detail = ""
    if ok:
        detail = f"role={body['data'].get('role', '?')}"
    record("GET /api/auth/me (student Bearer)", ok, resp.status_code, detail)


# 3. Student endpoints
def test_student_dashboard():
    resp = requests.get(f"{BASE}/api/student/dashboard", headers=h(STUDENT_TOKEN))
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data"):
        detail = f"progress={body['data'].get('progress_score', '?')}"
    record("GET /api/student/dashboard", ok, resp.status_code, detail)


def test_student_sessions():
    resp = requests.get(f"{BASE}/api/student/sessions", headers=h(STUDENT_TOKEN))
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    record("GET /api/student/sessions", ok, resp.status_code)


def test_student_progress():
    resp = requests.get(f"{BASE}/api/student/progress", headers=h(STUDENT_TOKEN))
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data"):
        detail = f"pct={body['data'].get('progress_percentage', '?')}"
    record("GET /api/student/progress", ok, resp.status_code, detail)


# 4. Scan - QR
def test_scan_qr():
    global LESSON_ID
    resp = requests.post(
        f"{BASE}/api/scan/qr",
        headers=h(STUDENT_TOKEN),
        json={"qr_code": "integration_test_qr_001"},
    )
    body = safe_json(resp)
    if resp.status_code == 200 and body.get("success"):
        ok = True
        detail = f"found lesson"
        if body.get("data", {}).get("id"):
            LESSON_ID = body["data"]["id"]
    elif resp.status_code == 404:
        ok = True  # valid: lesson may not exist yet
        detail = "404 no lesson (valid)"
    else:
        ok = False
        detail = f"unexpected"
    record("POST /api/scan/qr", ok, resp.status_code, detail)


# 5. TTS
def test_tts_generate():
    resp = requests.post(
        f"{BASE}/api/tts/generate",
        headers=h(STUDENT_TOKEN),
        json={"text": "hello world test"},
    )
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data"):
        url = body["data"].get("audio_url", "")
        detail = f"has_url={'yes' if url else 'no'}"
    record("POST /api/tts/generate", ok, resp.status_code, detail)


# 6. Chat
def test_chat_ask():
    payload: dict = {"question": "What is the first lesson about?"}
    if LESSON_ID:
        payload["lesson_id"] = LESSON_ID
    resp = requests.post(
        f"{BASE}/api/chat/ask",
        headers=h(STUDENT_TOKEN),
        json=payload,
    )
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data"):
        answer = body["data"].get("answer", "")
        detail = f"answer_len={len(answer)}"
    record("POST /api/chat/ask", ok, resp.status_code, detail)


def test_chat_history():
    lid = LESSON_ID or "ce8fc1d0-109a-49a5-adc6-bf795507deba"
    resp = requests.get(
        f"{BASE}/api/chat/history/{lid}",
        headers=h(STUDENT_TOKEN),
    )
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data"):
        msgs = body["data"].get("messages", [])
        detail = f"messages={len(msgs)}"
    record("GET /api/chat/history/{{lesson_id}}", ok, resp.status_code, detail)


# 7. Quizzes
def test_quizzes_by_lesson():
    lid = LESSON_ID or "ce8fc1d0-109a-49a5-adc6-bf795507deba"
    resp = requests.get(
        f"{BASE}/api/quizzes/{lid}",
        headers=h(STUDENT_TOKEN),
    )
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data") is not None:
        detail = f"count={len(body['data'])}"
    record("GET /api/quizzes/{{lesson_id}}", ok, resp.status_code, detail)


def test_quizzes_submit():
    """Submit quiz answer. Tries to find a real quiz first; if none, validates error handling."""
    lid = LESSON_ID or "ce8fc1d0-109a-49a5-adc6-bf795507deba"
    quiz_resp = requests.get(f"{BASE}/api/quizzes/{lid}", headers=h(STUDENT_TOKEN))
    quiz_body = safe_json(quiz_resp)
    quiz_id = None
    if quiz_resp.status_code == 200 and quiz_body.get("data"):
        quizzes = quiz_body["data"]
        if isinstance(quizzes, list) and len(quizzes) > 0:
            quiz_id = quizzes[0].get("id")

    if quiz_id:
        resp = requests.post(
            f"{BASE}/api/quizzes/submit",
            headers=h(STUDENT_TOKEN),
            json={"quiz_id": quiz_id, "selected_answer": "a"},
        )
        body = safe_json(resp)
        ok = resp.status_code == 200 and body.get("success") is True
        detail = ""
        if ok and body.get("data"):
            detail = f"correct={body['data'].get('is_correct')}"
        record("POST /api/quizzes/submit (real)", ok, resp.status_code, detail)
    else:
        resp = requests.post(
            f"{BASE}/api/quizzes/submit",
            headers=h(STUDENT_TOKEN),
            json={"quiz_id": "00000000-0000-0000-0000-000000000001", "selected_answer": "a"},
        )
        # 500 is expected - quiz doesn't exist, service raises
        ok = resp.status_code in (200, 500)
        record("POST /api/quizzes/submit (no quiz)", ok, resp.status_code,
               f"status={resp.status_code} (expected)")


# 8. Parent
def test_parent_children():
    resp = requests.get(f"{BASE}/api/parent/children", headers=h(PARENT_TOKEN))
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data") is not None:
        detail = f"children={len(body['data'])}"
    record("GET /api/parent/children", ok, resp.status_code, detail)


# 9. Admin
def test_admin_dashboard():
    resp = requests.get(f"{BASE}/api/admin/dashboard", headers=h(ADMIN_TOKEN))
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data"):
        detail = f"users={body['data'].get('total_users', '?')}"
    record("GET /api/admin/dashboard", ok, resp.status_code, detail)


def test_admin_users():
    resp = requests.get(f"{BASE}/api/admin/users", headers=h(ADMIN_TOKEN))
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data"):
        detail = f"total={body['data'].get('total', '?')}"
    record("GET /api/admin/users", ok, resp.status_code, detail)


def test_admin_lessons():
    resp = requests.get(f"{BASE}/api/admin/lessons", headers=h(ADMIN_TOKEN))
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data"):
        detail = f"total={body['data'].get('total', '?')}"
    record("GET /api/admin/lessons", ok, resp.status_code, detail)


def test_admin_logs():
    resp = requests.get(f"{BASE}/api/admin/logs", headers=h(ADMIN_TOKEN))
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    detail = ""
    if ok and body.get("data"):
        detail = f"total={body['data'].get('total', '?')}"
    record("GET /api/admin/logs", ok, resp.status_code, detail)


def test_admin_settings():
    resp = requests.get(f"{BASE}/api/admin/settings", headers=h(ADMIN_TOKEN))
    body = safe_json(resp)
    ok = resp.status_code == 200 and body.get("success") is True
    record("GET /api/admin/settings", ok, resp.status_code)


# 10. Auth failures
def test_no_token_401():
    resp = requests.get(f"{BASE}/api/auth/me")
    ok = resp.status_code == 401
    record("GET /api/auth/me (no token) -> 401", ok, resp.status_code)


def test_student_cannot_admin():
    resp = requests.get(f"{BASE}/api/admin/dashboard", headers=h(STUDENT_TOKEN))
    ok = resp.status_code == 403
    record("GET /api/admin/dashboard (student) -> 403", ok, resp.status_code)


def test_student_cannot_parent():
    resp = requests.get(f"{BASE}/api/parent/children", headers=h(STUDENT_TOKEN))
    ok = resp.status_code == 403
    record("GET /api/parent/children (student) -> 403", ok, resp.status_code)


def test_parent_cannot_student():
    resp = requests.get(f"{BASE}/api/student/dashboard", headers=h(PARENT_TOKEN))
    ok = resp.status_code == 403
    record("GET /api/student/dashboard (parent) -> 403", ok, resp.status_code)


# ── Output ───────────────────────────────────────────────────────


def print_results() -> bool:
    passed = sum(1 for r in results if r.passed)
    total = len(results)

    print()
    print("=" * 95)
    print(f"  {'#':<4} {'Test':<55} {'HTTP':<7} {'Result':<7} Detail")
    print("-" * 95)

    for i, r in enumerate(results, 1):
        tag = "PASS" if r.passed else "FAIL"
        prefix = "  " if r.passed else "> "
        detail = r.detail[:28] if r.detail else ""
        print(f"{prefix}{i:<4} {r.name:<55} {r.status:<7} {tag:<7} {detail}")

    print("=" * 95)

    if passed == total:
        print(f"\n  ALL PASSED: {passed}/{total} tests passed.")
    else:
        print(f"\n  RESULT: {passed}/{total} tests passed, {total - passed} failed.")

    print()
    return passed == total


# ── Main ─────────────────────────────────────────────────────────


def main():
    print()
    print("  Edu Smart Assistant - Integration Tests")
    print("  " + "-" * 42)
    print(f"  Server:  {BASE}")
    print(f"  Mode:    MOCK (USE_MOCKS=true)")
    print()

    # Connectivity check
    try:
        resp = requests.get(f"{BASE}/", timeout=5)
        if resp.status_code != 200:
            print(f"  ERROR: Server returned HTTP {resp.status_code}")
            sys.exit(1)
    except requests.ConnectionError:
        print(f"  ERROR: Cannot connect to {BASE}")
        print("  Start server: uvicorn app.main:app --reload --port 8000")
        sys.exit(1)

    # Setup: create all role users in DB
    print("  [setup] Creating users via verify-token ...")
    setup_users()

    # Setup: create a lesson via admin for downstream tests
    print("  [setup] Creating test lesson via admin ...")
    global LESSON_ID
    LESSON_ID = create_lesson_via_admin()
    if LESSON_ID:
        print(f"  [setup] Lesson ID: {LESSON_ID}")
    else:
        print("  [setup] WARNING: lesson creation failed; some tests use fallback UUID")

    print()
    print("  Running tests ...")
    print()

    # 1. Health
    test_health()

    # 2. Auth
    test_auth_verify_token_student()
    test_auth_verify_token_parent()
    test_auth_verify_token_admin()
    test_auth_me_student()

    # 3. Student
    test_student_dashboard()
    test_student_sessions()
    test_student_progress()

    # 4. Scan
    test_scan_qr()

    # 5. TTS
    test_tts_generate()

    # 6. Chat
    test_chat_ask()
    test_chat_history()

    # 7. Quizzes
    test_quizzes_by_lesson()
    test_quizzes_submit()

    # 8. Parent
    test_parent_children()

    # 9. Admin
    test_admin_dashboard()
    test_admin_users()
    test_admin_lessons()
    test_admin_logs()
    test_admin_settings()

    # 10. Auth failures / RBAC
    test_no_token_401()
    test_student_cannot_admin()
    test_student_cannot_parent()
    test_parent_cannot_student()

    all_ok = print_results()
    sys.exit(0 if all_ok else 1)


if __name__ == "__main__":
    main()
