"""
Smoke test script for Edu Smart Assistant backend API.
Hits every endpoint group against a running server in mock mode.

Usage:
    set PYTHONIOENCODING=utf-8
    python -m tests.smoke_test
"""

import sys
import httpx

BASE_URL = "http://localhost:8000"

# Mock tokens — format: "mock_role_name"
# Using ASCII-only names so httpx can send them in HTTP headers.
# The mock auth hashes the token to produce a uid; the name part after the
# second underscore becomes the display name in the DB (cosmetic only).
STUDENT_TOKEN = "mock_student_student1"
PARENT_TOKEN = "mock_parent_parent1"
ADMIN_TOKEN = "mock_admin_admin1"


def auth_header(token: str) -> dict:
    return {"Authorization": f"Bearer {token}"}


# ─── Results tracking ─────────────────────────────────────────────

results: list[tuple[str, bool, str]] = []


def record(name: str, passed: bool, detail: str = ""):
    tag = "\u2705" if passed else "\u274c"
    line = f"  {tag} {name}"
    if detail:
        line += f"  ({detail})"
    print(line)
    results.append((name, passed, detail))


def check(name: str, resp: httpx.Response, expected_status: int = 200):
    """Validate status code and standard response shape."""
    if resp.status_code != expected_status:
        record(name, False, f"status {resp.status_code}, expected {expected_status}")
        return None

    try:
        body = resp.json()
    except Exception:
        record(name, False, "response is not JSON")
        return None

    if "success" not in body:
        record(name, False, "missing 'success' field")
        return None

    if not body["success"]:
        record(name, False, f"success=false: {body.get('message', '')}")
        return None

    record(name, True)
    return body


# ─── Test functions ───────────────────────────────────────────────

def test_health(client: httpx.Client):
    print("\n== Health ==")
    resp = client.get("/")
    check("GET /", resp)


def test_auth_create_users(client: httpx.Client) -> dict:
    """Create all three user types via verify-token. Returns user profiles."""
    print("\n== Auth: Create Users ==")
    users = {}
    for label, token in [("student", STUDENT_TOKEN), ("parent", PARENT_TOKEN), ("admin", ADMIN_TOKEN)]:
        resp = client.post("/api/auth/verify-token", json={"token": token})
        body = check(f"POST /api/auth/verify-token [{label}]", resp)
        if body:
            users[label] = body.get("data", {})
    return users


def test_auth_me(client: httpx.Client):
    print("\n== Auth: /me ==")
    for label, token in [("student", STUDENT_TOKEN), ("parent", PARENT_TOKEN), ("admin", ADMIN_TOKEN)]:
        resp = client.get("/api/auth/me", headers=auth_header(token))
        check(f"GET /api/auth/me [{label}]", resp)


def test_student_endpoints(client: httpx.Client):
    print("\n== Student ==")
    h = auth_header(STUDENT_TOKEN)
    for path in ["/api/student/dashboard", "/api/student/sessions", "/api/student/progress"]:
        resp = client.get(path, headers=h)
        check(f"GET {path}", resp)


def test_scan_qr(client: httpx.Client) -> str | None:
    """Scan QR001 and return the lesson_id."""
    print("\n== Scan ==")
    h = auth_header(STUDENT_TOKEN)
    resp = client.post("/api/scan/qr", json={"qr_code": "QR001"}, headers=h)
    body = check("POST /api/scan/qr (QR001)", resp)
    if body and body.get("data"):
        lesson_id = body["data"].get("id")
        print(f"       lesson_id = {lesson_id}")
        return lesson_id
    return None


def test_tts(client: httpx.Client):
    print("\n== TTS ==")
    h = auth_header(STUDENT_TOKEN)
    resp = client.post("/api/tts/generate", json={"text": "\u0628\u0633\u0645 \u0627\u0644\u0644\u0647 \u0627\u0644\u0631\u062d\u0645\u0646 \u0627\u0644\u0631\u062d\u064a\u0645"}, headers=h)
    check("POST /api/tts/generate", resp)


def test_chat(client: httpx.Client, lesson_id: str | None):
    print("\n== Chat ==")
    h = auth_header(STUDENT_TOKEN)

    # ask
    payload = {"question": "\u0645\u0627 \u0647\u0648 \u0627\u0644\u0645\u0627\u0621\u061f"}
    if lesson_id:
        payload["lesson_id"] = lesson_id
    resp = client.post("/api/chat/ask", json=payload, headers=h)
    check("POST /api/chat/ask", resp)

    # history
    if lesson_id:
        resp = client.get(f"/api/chat/history/{lesson_id}", headers=h)
        check(f"GET /api/chat/history/{{lesson_id}}", resp)
    else:
        record("GET /api/chat/history/{lesson_id}", False, "skipped (no lesson_id)")


def test_quizzes(client: httpx.Client, lesson_id: str | None):
    print("\n== Quizzes ==")
    h = auth_header(STUDENT_TOKEN)

    quiz_id = None

    # get quizzes for lesson
    if lesson_id:
        resp = client.get(f"/api/quizzes/{lesson_id}", headers=h)
        body = check(f"GET /api/quizzes/{{lesson_id}}", resp)
        if body and body.get("data") and len(body["data"]) > 0:
            first_quiz = body["data"][0]
            quiz_id = first_quiz.get("id")
            print(f"       quiz_id = {quiz_id}")
    else:
        record("GET /api/quizzes/{lesson_id}", False, "skipped (no lesson_id)")

    # submit answer
    if quiz_id:
        resp = client.post(
            "/api/quizzes/submit",
            json={"quiz_id": quiz_id, "selected_answer": "a"},
            headers=h,
        )
        check("POST /api/quizzes/submit", resp)
    else:
        record("POST /api/quizzes/submit", False, "skipped (no quiz_id)")


def test_parent(client: httpx.Client):
    print("\n== Parent ==")
    h = auth_header(PARENT_TOKEN)
    resp = client.get("/api/parent/children", headers=h)
    check("GET /api/parent/children", resp)


def test_admin(client: httpx.Client):
    print("\n== Admin ==")
    h = auth_header(ADMIN_TOKEN)
    for path in [
        "/api/admin/dashboard",
        "/api/admin/users",
        "/api/admin/lessons",
        "/api/admin/logs",
        "/api/admin/settings",
    ]:
        resp = client.get(path, headers=h)
        check(f"GET {path}", resp)


# ─── Main ─────────────────────────────────────────────────────────

def main():
    print(f"Smoke testing {BASE_URL} ...")

    # Quick connectivity check
    try:
        probe = httpx.get(f"{BASE_URL}/", timeout=5)
        probe.raise_for_status()
    except Exception as e:
        print(f"\n\u274c Cannot reach {BASE_URL}: {e}")
        print("   Make sure the server is running:  uvicorn app.main:app --reload")
        sys.exit(1)

    with httpx.Client(base_url=BASE_URL, timeout=30) as client:
        test_health(client)
        users = test_auth_create_users(client)
        test_auth_me(client)
        test_student_endpoints(client)
        lesson_id = test_scan_qr(client)
        test_tts(client)
        test_chat(client, lesson_id)
        test_quizzes(client, lesson_id)
        test_parent(client)
        test_admin(client)

    # ── Summary ──
    total = len(results)
    passed = sum(1 for _, ok, _ in results if ok)
    failed = total - passed

    print("\n" + "=" * 50)
    print(f"  TOTAL: {total}  |  \u2705 Passed: {passed}  |  \u274c Failed: {failed}")
    print("=" * 50)

    if failed > 0:
        print("\nFailed tests:")
        for name, ok, detail in results:
            if not ok:
                print(f"  \u274c {name}  -- {detail}")
        sys.exit(1)
    else:
        print("\nAll tests passed.")
        sys.exit(0)


if __name__ == "__main__":
    main()
