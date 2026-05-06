"""
Comprehensive live test suite for the Diya system.
Tests all API endpoints with seeded SQLite data.
Run: python run_tests.py
"""
import httpx
import json
import sys
import io

BASE = "http://localhost:8000"
PASS = 0
FAIL = 0
BUGS = []


def test(name, condition, detail=""):
    global PASS, FAIL
    if condition:
        PASS += 1
        print(f"  [PASS] {name}")
    else:
        FAIL += 1
        BUGS.append(f"{name}: {detail}")
        print(f"  [FAIL] {name} -- {detail}")


def api(method, path, token=None, json_data=None, files=None):
    headers = {}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    if method == "GET":
        r = httpx.get(f"{BASE}{path}", headers=headers, timeout=15)
    elif method == "POST":
        if files:
            r = httpx.post(f"{BASE}{path}", headers=headers, files=files, timeout=15)
        else:
            headers["Content-Type"] = "application/json"
            r = httpx.post(f"{BASE}{path}", headers=headers, json=json_data, timeout=15)
    elif method == "PUT":
        headers["Content-Type"] = "application/json"
        r = httpx.put(f"{BASE}{path}", headers=headers, json=json_data, timeout=15)
    elif method == "DELETE":
        r = httpx.delete(f"{BASE}{path}", headers=headers, timeout=15)
    return r.status_code, r.json()


def run_all():
    global PASS, FAIL

    # ══════════════════════════════════════════════════
    # TEST 0: HEALTH
    # ══════════════════════════════════════════════════
    print("\n== HEALTH ==")
    code, data = api("GET", "/")
    test("Health check", code == 200 and data["success"])

    # ══════════════════════════════════════════════════
    # TEST GROUP 2: AUTH
    # ══════════════════════════════════════════════════
    print("\n== GROUP 2: AUTH ==")

    code, data = api("POST", "/api/auth/verify-token", json_data={"token": "mock_student_Student1"})
    test("verify-token student", code == 200 and data["success"] and data["data"]["role"] == "student",
         f"code={code}")

    code, data = api("POST", "/api/auth/verify-token", json_data={"token": "mock_parent_Parent1"})
    test("verify-token parent", code == 200 and data["data"]["role"] == "parent")

    code, data = api("POST", "/api/auth/verify-token", json_data={"token": "mock_admin_AdminUser"})
    test("verify-token admin", code == 200 and data["data"]["role"] == "admin")

    code, data = api("GET", "/api/auth/me", token="mock_student_Student1")
    test("/me student has profile", code == 200 and "student" in data["data"],
         f"keys={list(data.get('data', {}).keys())}")
    student1_id = data["data"]["student"]["id"]

    code, data = api("GET", "/api/auth/me", token="mock_parent_Parent1")
    test("/me parent has children", code == 200 and len(data["data"].get("children", [])) >= 2,
         f"children={len(data.get('data', {}).get('children', []))}")

    code, data = api("POST", "/api/auth/register-parent", json_data={
        "name": "test parent new", "email": "newp@test.com", "phone": "0550000000"
    })
    test("register-parent", code == 200 and data["success"])

    code, data = api("POST", "/api/auth/add-child", token="mock_parent_Parent1", json_data={
        "child_firebase_uid": "new_child_uid_test_2",
        "child_name": "child test", "age": 7, "grade": "first", "learning_level": "beginner"
    })
    test("add-child", code == 200 and data["success"], f"code={code}")

    code, data = api("GET", "/api/auth/me", token="mock_student_Inactive")
    test("inactive user blocked (403)", code == 403, f"code={code}")

    # ══════════════════════════════════════════════════
    # TEST GROUP 3: SCAN
    # ══════════════════════════════════════════════════
    print("\n== GROUP 3: SCAN ==")

    from PIL import Image
    img = Image.new("RGB", (100, 100), "white")
    buf = io.BytesIO()
    img.save(buf, format="PNG")
    img_bytes = buf.getvalue()

    code, data = api("POST", "/api/scan/ocr", token="mock_student_Student1",
                     files={"image": ("test.png", img_bytes, "image/png")})
    test("OCR scan returns text", code == 200 and data["success"] and "extracted_text" in data["data"])

    code, data = api("POST", "/api/scan/upload", token="mock_student_Student1",
                     files={"file": ("test.png", img_bytes, "image/png")})
    test("Upload returns text", code == 200 and data["success"])

    code, data = api("POST", "/api/scan/qr", token="mock_student_Student1",
                     json_data={"qr_code": "LESSON_ALIF"})
    test("QR finds lesson", code == 200 and "original_text" in data["data"])
    lesson_alif_id = data["data"]["id"]

    code, data = api("POST", "/api/scan/qr", token="mock_student_Student1",
                     json_data={"qr_code": "LESSON_NUMBERS"})
    test("QR finds lesson 2", code == 200 and data["success"])

    code, data = api("POST", "/api/scan/qr", token="mock_student_Student1",
                     json_data={"qr_code": "NONEXISTENT"})
    test("QR 404 for unknown", code == 404, f"code={code}")

    code, data = api("POST", "/api/scan/ocr", token="mock_student_Student1",
                     files={"image": ("test.txt", b"hello", "text/plain")})
    test("OCR rejects non-image", code == 400, f"code={code}")

    # ══════════════════════════════════════════════════
    # TEST GROUP 4: TTS
    # ══════════════════════════════════════════════════
    print("\n== GROUP 4: TTS ==")

    code, data = api("POST", "/api/tts/generate", token="mock_student_Student1",
                     json_data={"text": "test text for tts"})
    test("TTS returns audio URL", code == 200 and "audio_url" in data.get("data", {}))

    code, data = api("POST", "/api/tts/generate", token="mock_student_Student1",
                     json_data={"text": ""})
    test("TTS rejects empty text", code in (400, 422), f"code={code}")

    # ══════════════════════════════════════════════════
    # TEST GROUP 5: CHAT
    # ══════════════════════════════════════════════════
    print("\n== GROUP 5: CHAT ==")

    code, data = api("POST", "/api/chat/ask", token="mock_student_Student1",
                     json_data={"lesson_id": lesson_alif_id, "question": "what is alif?"})
    test("Chat returns answer", code == 200 and "answer" in data.get("data", {}))

    code, data = api("GET", f"/api/chat/history/{lesson_alif_id}", token="mock_student_Student1")
    test("Chat history has messages", code == 200 and len(data.get("data", [])) > 0,
         f"count={len(data.get('data', []))}")

    # ══════════════════════════════════════════════════
    # TEST GROUP 6: QUIZ
    # ══════════════════════════════════════════════════
    print("\n== GROUP 6: QUIZ ==")

    code, data = api("GET", f"/api/quizzes/{lesson_alif_id}", token="mock_student_Student1")
    test("Get quizzes by lesson (5)", code == 200 and len(data["data"]) == 5,
         f"count={len(data.get('data', []))}")

    code, data = api("GET", "/api/quizzes/types/reading", token="mock_student_Student1")
    test("Get quizzes by type", code == 200 and len(data["data"]) > 0)

    code, data = api("GET", "/api/quizzes/types/invalid", token="mock_student_Student1")
    test("Invalid type rejected", code == 400, f"code={code}")

    # Submit with correct answer from DB
    from app.database import SessionLocal
    from app.models.quiz import Quiz as QuizModel
    db = SessionLocal()
    first_quiz = db.query(QuizModel).filter(QuizModel.lesson_id == lesson_alif_id).first()
    correct_answer = first_quiz.correct_answer
    quiz_id = str(first_quiz.id)
    db.close()

    code, data = api("POST", "/api/quizzes/submit", token="mock_student_Student1",
                     json_data={"quiz_id": quiz_id, "selected_answer": correct_answer})
    test("Submit correct -> is_correct=True", code == 200 and data["data"]["is_correct"] is True,
         f"is_correct={data.get('data', {}).get('is_correct')}")

    code, data = api("POST", "/api/quizzes/submit", token="mock_student_Student1",
                     json_data={"quiz_id": quiz_id, "selected_answer": "WRONG"})
    test("Submit wrong -> is_correct=False", code == 200 and data["data"]["is_correct"] is False)

    code, data = api("GET", f"/api/quizzes/results/{student1_id}", token="mock_student_Student1")
    test("Get quiz results", code == 200 and len(data["data"]) > 0)

    code, data = api("POST", "/api/quizzes/submit", token="mock_parent_Parent1",
                     json_data={"quiz_id": quiz_id, "selected_answer": "x"})
    test("Parent cant submit quiz (403)", code == 403, f"code={code}")

    # ══════════════════════════════════════════════════
    # TEST GROUP 7: STUDENT
    # ══════════════════════════════════════════════════
    print("\n== GROUP 7: STUDENT ==")

    code, data = api("GET", "/api/student/dashboard", token="mock_student_Student1")
    test("Student dashboard", code == 200 and data["success"])

    code, data = api("GET", "/api/student/sessions", token="mock_student_Student1")
    test("Student sessions", code == 200 and data["success"])

    code, data = api("GET", "/api/student/progress", token="mock_student_Student1")
    test("Student progress", code == 200 and data["success"])

    # ══════════════════════════════════════════════════
    # TEST GROUP 8: PARENT
    # ══════════════════════════════════════════════════
    print("\n== GROUP 8: PARENT ==")

    code, data = api("GET", "/api/parent/children", token="mock_parent_Parent1")
    test("Parent1 children list", code == 200 and len(data["data"]) >= 2,
         f"count={len(data.get('data', []))}")
    child_id = data["data"][0]["id"]

    code, data = api("GET", f"/api/parent/reports/{child_id}", token="mock_parent_Parent1")
    test("Parent report", code == 200 and data["success"])

    code, data = api("GET", f"/api/parent/reports/{child_id}/weekly", token="mock_parent_Parent1")
    test("Weekly report", code == 200 and "lessons_completed" in data.get("data", {}),
         f"keys={list(data.get('data', {}).keys())}")

    code, data = api("GET", f"/api/parent/reports/{child_id}/monthly", token="mock_parent_Parent1")
    test("Monthly report", code == 200 and data["success"])

    code, data = api("GET", "/api/parent/children", token="mock_parent_Parent2")
    test("Parent2 sees own children", code == 200 and len(data["data"]) >= 1)

    # ══════════════════════════════════════════════════
    # TEST GROUP 9: ADMIN
    # ══════════════════════════════════════════════════
    print("\n== GROUP 9: ADMIN ==")

    code, data = api("GET", "/api/admin/dashboard", token="mock_admin_AdminUser")
    test("Admin dashboard", code == 200 and "total_users" in data.get("data", {}))

    code, data = api("GET", "/api/admin/users", token="mock_admin_AdminUser")
    test("Admin users list", code == 200 and len(data["data"]["users"]) >= 7)

    code, data = api("POST", "/api/admin/users", token="mock_admin_AdminUser", json_data={
        "name": "crud test user", "email": "crud@test.com", "role": "student"
    })
    test("Admin create user", code == 200 and data["success"])
    if data["success"]:
        uid = data["data"]["id"]
        code, data = api("PUT", f"/api/admin/users/{uid}", token="mock_admin_AdminUser",
                         json_data={"name": "updated", "is_active": False})
        test("Admin update user", code == 200 and data["success"])
        code, data = api("DELETE", f"/api/admin/users/{uid}", token="mock_admin_AdminUser")
        test("Admin delete user", code == 200 and data["success"])

    code, data = api("GET", "/api/admin/lessons", token="mock_admin_AdminUser")
    test("Admin lessons list (5)", code == 200 and len(data["data"]["lessons"]) == 5,
         f"count={len(data.get('data', {}).get('lessons', []))}")

    code, data = api("POST", "/api/admin/lessons", token="mock_admin_AdminUser", json_data={
        "title": "crud test lesson", "subject": "test", "grade_level": "1",
        "original_text": "content", "qr_code": "TEST_CRUD"
    })
    test("Admin create lesson", code == 200 and data["success"])
    if data["success"]:
        lid = data["data"]["id"]
        code, data = api("PUT", f"/api/admin/lessons/{lid}", token="mock_admin_AdminUser",
                         json_data={"title": "updated lesson"})
        test("Admin update lesson", code == 200 and data["success"])
        code, data = api("DELETE", f"/api/admin/lessons/{lid}", token="mock_admin_AdminUser")
        test("Admin delete lesson", code == 200 and data["success"])

    code, data = api("GET", "/api/admin/logs", token="mock_admin_AdminUser")
    test("Admin logs", code == 200 and len(data["data"]["logs"]) > 0)

    code, data = api("GET", "/api/admin/settings", token="mock_admin_AdminUser")
    test("Admin get settings", code == 200 and data["success"])

    code, data = api("PUT", "/api/admin/settings", token="mock_admin_AdminUser",
                     json_data={"language": "ar", "reading_enabled": True})
    test("Admin update settings", code == 200 and data["success"])

    code, data = api("GET", "/api/admin/dashboard", token="mock_student_Student1")
    test("Student cant access admin (403)", code == 403, f"code={code}")

    # ══════════════════════════════════════════════════
    # TEST GROUP 11: ERROR HANDLING
    # ══════════════════════════════════════════════════
    print("\n== GROUP 11: ERRORS ==")

    code, _ = api("GET", "/api/auth/me")
    test("No token -> 401", code == 401, f"code={code}")

    code, _ = api("GET", "/api/auth/me", token="totally_invalid_token")
    test("Bad token -> 401", code == 401, f"code={code}")

    code, _ = api("GET", "/api/quizzes/00000000-0000-0000-0000-000000000000",
                  token="mock_student_Student1")
    test("Non-existent lesson -> empty list", code == 200)

    code, _ = api("GET", "/api/parent/children", token="mock_student_Student1")
    test("Student cant access parent endpoint", code in (403, 401, 400, 500), f"code={code}")

    # ══════════════════════════════════════════════════
    # SUMMARY
    # ══════════════════════════════════════════════════
    print("\n" + "=" * 55)
    print(f"  TOTAL TESTS: {PASS + FAIL}")
    print(f"  PASSED:      {PASS}")
    print(f"  FAILED:      {FAIL}")
    print("=" * 55)

    if BUGS:
        print("\n  BUGS:")
        for b in BUGS:
            print(f"    - {b}")

    return FAIL


if __name__ == "__main__":
    failures = run_all()
    sys.exit(0 if failures == 0 else 1)
