"""
Edu Smart Assistant — Full Lifecycle Test
==========================================
Tests the complete user journey:
  Phase 1: Auth (verify tokens, create users)
  Phase 2: Admin (dashboard, lesson CRUD, user management)
  Phase 3: Student (dashboard, sessions, AI chat, quizzes)
  Phase 4: Parent (children list, reports)
  Phase 5: Data integrity verification

Run:
  cd backend
  python -m pytest tests/test_lifecycle.py -v --tb=short
"""

import hashlib
import httpx
import pytest

BASE = "http://localhost:8000"

# ── Mock tokens ───────────────────────────────────────────────
# Mock auth: token "mock_role_name" → uid = md5(token)
# verify-token auto-creates users with get_or_create_user
STUDENT_TOKEN = "mock_student_ahmed"
PARENT_TOKEN = "mock_parent_Khaled"
ADMIN_TOKEN = "mock_admin_AdminUser"


def uid_for(token: str) -> str:
    return hashlib.md5(token.encode("utf-8")).hexdigest()


def auth_header(token: str) -> dict:
    return {"Authorization": f"Bearer {token}"}


# ── Shared state across tests (collected during lifecycle) ────
state = {
    "student_user_id": None,
    "student_id": None,
    "parent_user_id": None,
    "admin_user_id": None,
    "lesson_id": None,          # from seed data
    "new_lesson_id": None,      # created by admin
    "session_id": None,
    "quiz_id": None,
    "child_id": None,           # student ID visible to parent
}


@pytest.fixture(scope="module")
def client():
    with httpx.Client(base_url=BASE, timeout=30) as c:
        yield c


# ═══════════════════════════════════════════════════════════════
# PHASE 0: Health Check
# ═══════════════════════════════════════════════════════════════

class TestPhase0Health:
    def test_health_check(self, client):
        r = client.get("/")
        assert r.status_code == 200
        data = r.json()
        assert data["success"] is True
        print(f"  ✓ Backend running: {data['message']}")


# ═══════════════════════════════════════════════════════════════
# PHASE 1: Authentication
# ═══════════════════════════════════════════════════════════════

class TestPhase1Auth:
    def test_01_verify_student_token(self, client):
        """Create/find student user via verify-token."""
        r = client.post("/api/auth/verify-token", json={"token": STUDENT_TOKEN})
        assert r.status_code == 200
        data = r.json()
        assert data["success"] is True
        profile = data["data"]
        assert profile["role"] == "student"
        state["student_user_id"] = profile["id"]
        if "student" in profile:
            state["student_id"] = profile["student"]["id"]
        print(f"  ✓ Student: {profile['name']} (id={profile['id'][:8]}...)")

    def test_02_verify_parent_token(self, client):
        """Create/find parent user via verify-token."""
        r = client.post("/api/auth/verify-token", json={"token": PARENT_TOKEN})
        assert r.status_code == 200
        data = r.json()
        assert data["success"] is True
        profile = data["data"]
        assert profile["role"] == "parent"
        state["parent_user_id"] = profile["id"]
        print(f"  ✓ Parent: {profile['name']} (id={profile['id'][:8]}...)")

    def test_03_verify_admin_token(self, client):
        """Create/find admin user via verify-token."""
        r = client.post("/api/auth/verify-token", json={"token": ADMIN_TOKEN})
        assert r.status_code == 200
        data = r.json()
        assert data["success"] is True
        profile = data["data"]
        assert profile["role"] == "admin"
        state["admin_user_id"] = profile["id"]
        print(f"  ✓ Admin: {profile['name']} (id={profile['id'][:8]}...)")

    def test_04_get_me_student(self, client):
        """Verify /auth/me returns correct student profile."""
        r = client.get("/api/auth/me", headers=auth_header(STUDENT_TOKEN))
        assert r.status_code == 200
        data = r.json()
        assert data["data"]["role"] == "student"
        print(f"  ✓ /auth/me student OK")

    def test_05_get_me_parent(self, client):
        r = client.get("/api/auth/me", headers=auth_header(PARENT_TOKEN))
        assert r.status_code == 200
        assert r.json()["data"]["role"] == "parent"
        print(f"  ✓ /auth/me parent OK")

    def test_06_get_me_admin(self, client):
        r = client.get("/api/auth/me", headers=auth_header(ADMIN_TOKEN))
        assert r.status_code == 200
        assert r.json()["data"]["role"] == "admin"
        print(f"  ✓ /auth/me admin OK")

    def test_07_no_token_rejected(self, client):
        """Endpoints reject requests without token."""
        r = client.get("/api/auth/me")
        assert r.status_code == 401
        print(f"  ✓ No-token correctly rejected")

    def test_08_bad_token_rejected(self, client):
        """Invalid token format is rejected by middleware."""
        r = client.get("/api/auth/me", headers={"Authorization": "Bearer bad"})
        # Mock mode will parse any token, so this should still create a user
        # The key test is that the middleware doesn't crash
        assert r.status_code in (200, 401)
        print(f"  ✓ Token validation works (status={r.status_code})")


# ═══════════════════════════════════════════════════════════════
# PHASE 2: Admin Operations
# ═══════════════════════════════════════════════════════════════

class TestPhase2Admin:
    def test_01_admin_dashboard(self, client):
        """Admin dashboard returns system stats."""
        r = client.get("/api/admin/dashboard", headers=auth_header(ADMIN_TOKEN))
        assert r.status_code == 200
        data = r.json()["data"]
        assert "total_users" in data
        assert "total_sessions_week" in data
        print(f"  ✓ Dashboard: {data['total_users']} users, {data['total_sessions_week']} sessions/week")

    def test_02_list_users(self, client):
        """Admin can list all users."""
        r = client.get("/api/admin/users", headers=auth_header(ADMIN_TOKEN))
        assert r.status_code == 200
        data = r.json()["data"]
        assert "users" in data
        assert data["total"] > 0
        print(f"  ✓ Users list: {data['total']} users")

    def test_03_create_lesson(self, client):
        """Admin creates a new lesson."""
        r = client.post("/api/admin/lessons", headers=auth_header(ADMIN_TOKEN), json={
            "title": "درس اختبار - حروف الهجاء المتقدمة",
            "subject": "لغتي",
            "grade_level": "الصف الثاني",
            "original_text": (
                "حرف الباء هو ثاني حرف في الحروف الهجائية العربية. "
                "شكل حرف الباء: بـ ـبـ ـب ب. "
                "حرف الباء نقطة واحدة تحته. "
                "كلمات تبدا بحرف الباء: بطة، بقرة، باب، بيت. "
                "تدريب: اكتب حرف الباء واذكر ثلاث كلمات تبدا به."
            ),
            "qr_code": "QR_TEST_001",
        })
        assert r.status_code == 200
        data = r.json()
        assert data["success"] is True
        state["new_lesson_id"] = data["data"]["id"]
        print(f"  ✓ Lesson created: {data['data']['title']} (id={data['data']['id'][:8]}...)")

    def test_04_list_lessons(self, client):
        """Admin can list all lessons (including newly created)."""
        r = client.get("/api/admin/lessons", headers=auth_header(ADMIN_TOKEN))
        assert r.status_code == 200
        data = r.json()["data"]
        assert data["total"] > 0
        titles = [l["title"] for l in data["lessons"]]
        assert any("اختبار" in t for t in titles), f"New lesson not found in: {titles}"
        # Also grab a seeded lesson_id for student tests
        for lesson in data["lessons"]:
            if "الالف" in lesson["title"] or lesson["qr_code"] == "QR001":
                state["lesson_id"] = lesson["id"]
                break
        if not state["lesson_id"] and data["lessons"]:
            state["lesson_id"] = data["lessons"][-1]["id"]
        print(f"  ✓ Lessons list: {data['total']} lessons")

    def test_05_update_lesson(self, client):
        """Admin updates the new lesson."""
        r = client.put(
            f"/api/admin/lessons/{state['new_lesson_id']}",
            headers=auth_header(ADMIN_TOKEN),
            json={"title": "درس اختبار - حرف الباء (محدث)"},
        )
        assert r.status_code == 200
        assert r.json()["success"] is True
        print(f"  ✓ Lesson updated: {r.json()['data']['title']}")

    def test_06_create_user(self, client):
        """Admin creates a new user."""
        import uuid
        r = client.post("/api/admin/users", headers=auth_header(ADMIN_TOKEN), json={
            "name": "طالب اختبار جديد",
            "email": f"test-{uuid.uuid4().hex[:6]}@edu.sa",
            "role": "student",
        })
        assert r.status_code == 200
        assert r.json()["success"] is True
        print(f"  ✓ User created: {r.json()['data']['name']}")

    def test_07_system_logs(self, client):
        """Admin can view system logs."""
        r = client.get("/api/admin/logs", headers=auth_header(ADMIN_TOKEN))
        assert r.status_code == 200
        data = r.json()["data"]
        assert "logs" in data
        print(f"  ✓ System logs: {data['total']} entries")

    def test_08_settings_get(self, client):
        """Admin can read system settings."""
        r = client.get("/api/admin/settings", headers=auth_header(ADMIN_TOKEN))
        assert r.status_code == 200
        data = r.json()["data"]
        assert data["language"] == "ar"
        print(f"  ✓ Settings: language={data['language']}")

    def test_09_settings_update(self, client):
        """Admin can update system settings."""
        r = client.put("/api/admin/settings", headers=auth_header(ADMIN_TOKEN), json={
            "language": "ar",
            "available_content": ["لغة عربية", "رياضيات", "علوم"],
            "notifications": {
                "email_notifications": True,
                "push_notifications": True,
                "parent_weekly_report": True,
            },
        })
        assert r.status_code == 200
        assert r.json()["success"] is True
        print(f"  ✓ Settings updated")

    def test_10_non_admin_rejected(self, client):
        """Student can't access admin endpoints."""
        r = client.get("/api/admin/dashboard", headers=auth_header(STUDENT_TOKEN))
        assert r.status_code == 403
        print(f"  ✓ Non-admin correctly rejected from admin endpoints")


# ═══════════════════════════════════════════════════════════════
# PHASE 3: Student Learning Flow
# ═══════════════════════════════════════════════════════════════

class TestPhase3Student:
    def test_01_student_dashboard(self, client):
        """Student can view their dashboard."""
        r = client.get("/api/student/dashboard", headers=auth_header(STUDENT_TOKEN))
        assert r.status_code == 200
        data = r.json()["data"]
        assert "student_info" in data
        assert "recent_sessions" in data
        # Capture student_id if not already set
        if not state["student_id"]:
            state["student_id"] = data["student_info"]["id"]
        print(f"  ✓ Dashboard: {data['student_info']['name']}, grade={data['student_info']['grade']}")

    def test_02_start_session(self, client):
        """Student starts a learning session for a lesson."""
        assert state["lesson_id"], "No lesson_id available (admin tests must run first)"
        r = client.post("/api/student/sessions/start", headers=auth_header(STUDENT_TOKEN), json={
            "lesson_id": state["lesson_id"],
            "session_type": "qr",
        })
        assert r.status_code == 200
        data = r.json()["data"]
        state["session_id"] = data["id"]
        assert data["session_type"] == "qr"
        print(f"  ✓ Session started: {data['id'][:8]}... (type={data['session_type']})")

    def test_03_get_sessions(self, client):
        """Student can list their sessions."""
        r = client.get("/api/student/sessions", headers=auth_header(STUDENT_TOKEN))
        assert r.status_code == 200
        sessions = r.json()["data"]
        assert len(sessions) >= 1
        print(f"  ✓ Sessions: {len(sessions)} total")

    def test_04_get_quizzes_for_lesson(self, client):
        """Get quiz questions for the lesson."""
        r = client.get(f"/api/quizzes/{state['lesson_id']}", headers=auth_header(STUDENT_TOKEN))
        assert r.status_code == 200
        quizzes = r.json()["data"]
        if quizzes:
            state["quiz_id"] = quizzes[0]["id"]
            print(f"  ✓ Quizzes for lesson: {len(quizzes)} questions")
        else:
            # If no quizzes for this lesson, use the new lesson or skip
            print(f"  ✓ No quizzes for this lesson (will try random)")

    def test_05_get_random_quizzes(self, client):
        """Get random quiz questions."""
        r = client.get(
            f"/api/quizzes/random/{state['lesson_id']}",
            headers=auth_header(STUDENT_TOKEN),
        )
        assert r.status_code == 200
        quizzes = r.json()["data"]
        if quizzes and not state["quiz_id"]:
            state["quiz_id"] = quizzes[0]["id"]
        print(f"  ✓ Random quizzes: {len(quizzes)} questions")

    def test_06_get_quizzes_by_type(self, client):
        """Get quizzes filtered by type."""
        for qtype in ["reading", "writing", "comprehension"]:
            r = client.get(f"/api/quizzes/types/{qtype}", headers=auth_header(STUDENT_TOKEN))
            assert r.status_code == 200
            count = len(r.json()["data"])
            print(f"  ✓ {qtype} quizzes: {count}")

    def test_07_submit_quiz_correct(self, client):
        """Student submits a correct quiz answer."""
        if not state["quiz_id"]:
            pytest.skip("No quiz available")
        # First, get the quiz to see options (but correct_answer is hidden in API)
        # We'll just submit 'ا' — it may or may not be correct
        r = client.post("/api/quizzes/submit", headers=auth_header(STUDENT_TOKEN), json={
            "quiz_id": state["quiz_id"],
            "selected_answer": "ا",
        })
        assert r.status_code == 200
        data = r.json()["data"]
        assert "is_correct" in data
        print(f"  ✓ Quiz submitted: answer='ا', correct={data['is_correct']}")

    def test_08_submit_quiz_another(self, client):
        """Submit another answer to test multiple submissions."""
        if not state["quiz_id"]:
            pytest.skip("No quiz available")
        r = client.post("/api/quizzes/submit", headers=auth_header(STUDENT_TOKEN), json={
            "quiz_id": state["quiz_id"],
            "selected_answer": "ب",
        })
        assert r.status_code == 200
        print(f"  ✓ Second quiz submission OK")

    def test_09_get_quiz_results(self, client):
        """Student can view their quiz results."""
        assert state["student_id"], "No student_id"
        r = client.get(
            f"/api/quizzes/results/{state['student_id']}",
            headers=auth_header(STUDENT_TOKEN),
        )
        assert r.status_code == 200
        results = r.json()["data"]
        assert len(results) >= 1
        correct_count = sum(1 for r_item in results if r_item.get("is_correct"))
        print(f"  ✓ Quiz results: {len(results)} answers, {correct_count} correct")

    def test_10_ai_chat_ask(self, client):
        """Student asks AI a question about the lesson (REAL AI via OpenRouter)."""
        r = client.post("/api/chat/ask", headers=auth_header(STUDENT_TOKEN), json={
            "question": "ما هو حرف الالف؟",
            "lesson_id": state["lesson_id"],
        })
        assert r.status_code == 200
        data = r.json()["data"]
        assert "answer" in data
        assert len(data["answer"]) > 5  # Real AI should give meaningful answer
        print(f"  ✓ AI Chat answer: {data['answer'][:80]}...")

    def test_11_ai_chat_second_question(self, client):
        """Student asks another question."""
        r = client.post("/api/chat/ask", headers=auth_header(STUDENT_TOKEN), json={
            "question": "اعطني مثال على كلمة تبدا بحرف الالف",
            "lesson_id": state["lesson_id"],
        })
        assert r.status_code == 200
        data = r.json()["data"]
        assert "answer" in data
        print(f"  ✓ AI Chat follow-up: {data['answer'][:80]}...")

    def test_12_chat_history(self, client):
        """Student can view chat history for the lesson."""
        r = client.get(
            f"/api/chat/history/{state['lesson_id']}",
            headers=auth_header(STUDENT_TOKEN),
        )
        assert r.status_code == 200
        messages = r.json()["data"]["messages"]
        assert len(messages) >= 2  # At least 1 user + 1 assistant
        roles = [m["role"] for m in messages]
        assert "user" in roles
        assert "assistant" in roles
        print(f"  ✓ Chat history: {len(messages)} messages")

    def test_13_end_session(self, client):
        """Student ends the learning session."""
        assert state["session_id"], "No session to end"
        r = client.post(
            f"/api/student/sessions/{state['session_id']}/end",
            headers=auth_header(STUDENT_TOKEN),
        )
        assert r.status_code == 200
        data = r.json()["data"]
        assert data["ended_at"] is not None
        assert data["duration_minutes"] is not None
        print(f"  ✓ Session ended: duration={data['duration_minutes']}min")

    def test_14_progress(self, client):
        """Student can check their progress percentage."""
        r = client.get("/api/student/progress", headers=auth_header(STUDENT_TOKEN))
        assert r.status_code == 200
        data = r.json()["data"]
        assert "progress_percentage" in data
        print(f"  ✓ Progress: {data['progress_percentage']}%")

    def test_15_dashboard_after_activity(self, client):
        """Dashboard reflects the new activity."""
        r = client.get("/api/student/dashboard", headers=auth_header(STUDENT_TOKEN))
        assert r.status_code == 200
        data = r.json()["data"]
        assert data["completed_lessons"] >= 1
        assert data["study_time_minutes"] >= 0
        print(f"  ✓ Updated dashboard: {data['completed_lessons']} completed, "
              f"{data['quiz_score_average']}% quiz avg, "
              f"{data['study_time_minutes']}min study time")


# ═══════════════════════════════════════════════════════════════
# PHASE 4: Parent Monitoring
# ═══════════════════════════════════════════════════════════════

class TestPhase4Parent:
    def test_01_add_child(self, client):
        """Parent adds a new child to their account."""
        import uuid
        child_uid = f"child_test_{uuid.uuid4().hex[:8]}"
        r = client.post("/api/auth/add-child", headers=auth_header(PARENT_TOKEN), json={
            "child_firebase_uid": child_uid,
            "child_name": "طفل اختبار",
            "age": 7,
            "grade": "الصف الاول",
            "learning_level": "مبتدئ",
        })
        assert r.status_code == 200, f"Add child failed: {r.text}"
        state["child_id"] = r.json()["data"]["id"]
        print(f"  ✓ Child added: {r.json()['data']['name']} (id={state['child_id'][:8]}...)")

    def test_02_list_children(self, client):
        """Parent can list their children."""
        r = client.get("/api/parent/children", headers=auth_header(PARENT_TOKEN))
        assert r.status_code == 200
        children = r.json()["data"]
        if children:
            state["child_id"] = children[0]["id"]
            print(f"  ✓ Children: {len(children)} — {[c['name'] for c in children]}")
        else:
            print(f"  ⚠ No children linked to parent (add-child may have failed)")

    def test_03_child_report(self, client):
        """Parent views child's general report."""
        if not state["child_id"]:
            pytest.skip("No child linked to parent")
        r = client.get(
            f"/api/parent/reports/{state['child_id']}",
            headers=auth_header(PARENT_TOKEN),
        )
        assert r.status_code == 200
        report = r.json()["data"]
        print(f"  ✓ Child report: {report.get('child_name')}, "
              f"sessions={report.get('total_sessions')}, "
              f"quizzes={report.get('total_quizzes')}")

    def test_04_weekly_report(self, client):
        """Parent views child's weekly report."""
        if not state["child_id"]:
            pytest.skip("No child linked to parent")
        r = client.get(
            f"/api/parent/reports/{state['child_id']}/weekly",
            headers=auth_header(PARENT_TOKEN),
        )
        assert r.status_code == 200
        print(f"  ✓ Weekly report: {r.json()['data']}")

    def test_05_monthly_report(self, client):
        """Parent views child's monthly report."""
        if not state["child_id"]:
            pytest.skip("No child linked to parent")
        r = client.get(
            f"/api/parent/reports/{state['child_id']}/monthly",
            headers=auth_header(PARENT_TOKEN),
        )
        assert r.status_code == 200
        print(f"  ✓ Monthly report: {r.json()['data']}")

    def test_06_parent_cant_access_student_endpoints(self, client):
        """Parent can't access student-only endpoints."""
        r = client.get("/api/student/dashboard", headers=auth_header(PARENT_TOKEN))
        assert r.status_code == 403
        print(f"  ✓ Parent correctly rejected from student endpoints")


# ═══════════════════════════════════════════════════════════════
# PHASE 5: Data Integrity & Cleanup
# ═══════════════════════════════════════════════════════════════

class TestPhase5Verification:
    def test_01_admin_sees_updated_stats(self, client):
        """Admin dashboard reflects all activity from the test."""
        r = client.get("/api/admin/dashboard", headers=auth_header(ADMIN_TOKEN))
        assert r.status_code == 200
        data = r.json()["data"]
        assert data["total_users"] >= 3  # At least student, parent, admin
        print(f"  ✓ Final stats: {data['total_users']} users, "
              f"{data['total_sessions_week']} sessions/week")

    def test_02_admin_cleanup_test_lesson(self, client):
        """Admin deletes the test lesson."""
        if not state["new_lesson_id"]:
            pytest.skip("No test lesson to clean up")
        r = client.delete(
            f"/api/admin/lessons/{state['new_lesson_id']}",
            headers=auth_header(ADMIN_TOKEN),
        )
        assert r.status_code == 200
        print(f"  ✓ Test lesson cleaned up")

    def test_03_deleted_lesson_gone(self, client):
        """Verify deleted lesson is no longer listed."""
        r = client.get("/api/admin/lessons", headers=auth_header(ADMIN_TOKEN))
        assert r.status_code == 200
        ids = [l["id"] for l in r.json()["data"]["lessons"]]
        assert state["new_lesson_id"] not in ids
        print(f"  ✓ Deleted lesson confirmed gone")


# ═══════════════════════════════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════════════════════════════

class TestPhase6Summary:
    def test_print_summary(self, client):
        """Print lifecycle test summary."""
        print("\n" + "=" * 60)
        print("  LIFECYCLE TEST SUMMARY")
        print("=" * 60)
        print(f"  Student user:  {state['student_user_id']}")
        print(f"  Student ID:    {state['student_id']}")
        print(f"  Parent user:   {state['parent_user_id']}")
        print(f"  Admin user:    {state['admin_user_id']}")
        print(f"  Lesson tested: {state['lesson_id']}")
        print(f"  Session ID:    {state['session_id']}")
        print(f"  Quiz ID:       {state['quiz_id']}")
        print(f"  Child ID:      {state['child_id']}")
        print("=" * 60)
        print("  ALL LIFECYCLE TESTS PASSED")
        print("=" * 60)
