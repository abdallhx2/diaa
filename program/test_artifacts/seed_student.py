"""Seed an additional Firebase student user for E2E mobile student-flow testing."""
import io, sys, os
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
import firebase_admin
from firebase_admin import auth as fb_auth, credentials
import requests

cred = credentials.Certificate(os.path.join(os.path.dirname(__file__), '..', 'backend', 'firebase-credentials.json'))
firebase_admin.initialize_app(cred)

EMAIL = "student.test@diaa.com"
PASS  = "Student12345"
NAME  = "أحمد الطالب"

try:
    u = fb_auth.get_user_by_email(EMAIL)
    print(f"[exists] {EMAIL} -> {u.uid}")
except fb_auth.UserNotFoundError:
    u = fb_auth.create_user(email=EMAIL, password=PASS, display_name=NAME)
    print(f"[created] {EMAIL} -> {u.uid}")

fb_auth.set_custom_user_claims(u.uid, {"role": "student"})
fb_auth.update_user(u.uid, password=PASS)
print(f"  custom claim: role=student; password ensured")

KEY = "AIzaSyBIOeNIusj9n-fUaQVCpHCNe56EJAh0htQ"
r = requests.post(
    f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={KEY}",
    json={"email": EMAIL, "password": PASS, "returnSecureToken": True},
    timeout=20,
)
print(f"sign-in: HTTP {r.status_code}")
if r.status_code == 200:
    tok = r.json()["idToken"]
    rr = requests.post(
        "http://178.105.109.153:8001/api/auth/verify-token",
        json={"token": tok}, timeout=20,
    )
    print(f"verify-token: HTTP {rr.status_code}")
    print(f"  {rr.text[:300]}")
