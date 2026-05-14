"""Seed Firebase test users (admin + parent) and DB rows for E2E testing.

Usage:
  cd D:/Student/Edu/program/backend
  ../venv/Scripts/python.exe ../test_artifacts/seed_users.py

Reads firebase-credentials.json from backend/. Connects to deployed backend's
PostgreSQL via SSH tunnel? No — we hit the deployed backend's verify-token
endpoint after creating Firebase users with role custom claim, then call
register-parent so DB row exists.
"""
import json, os, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'backend'))

import firebase_admin
from firebase_admin import auth as fb_auth, credentials
import requests

CRED_PATH = os.path.join(os.path.dirname(__file__), '..', 'backend', 'firebase-credentials.json')
API_KEY = "AIzaSyBIOeNIusj9n-fUaQVCpHCNe56EJAh0htQ"
BACKEND = "http://178.105.109.153:8001/api"

ADMIN_EMAIL = "admin@diaa.com"
ADMIN_PASS  = "Admin1234!"
PARENT_EMAIL = "parent.test@diaa.com"
PARENT_PASS  = "Parent1234!"

cred = credentials.Certificate(CRED_PATH)
firebase_admin.initialize_app(cred)


def ensure_user(email: str, password: str, name: str, role: str | None) -> str:
    try:
        u = fb_auth.get_user_by_email(email)
        print(f"[exists] {email} -> {u.uid}")
    except fb_auth.UserNotFoundError:
        u = fb_auth.create_user(email=email, password=password, display_name=name)
        print(f"[created] {email} -> {u.uid}")
    if role:
        fb_auth.set_custom_user_claims(u.uid, {"role": role})
        print(f"  custom claim: role={role}")
    return u.uid


def signin_password(email: str, password: str) -> str:
    """Use Firebase REST API to exchange email/pw for an ID token."""
    r = requests.post(
        f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={API_KEY}",
        json={"email": email, "password": password, "returnSecureToken": True},
        timeout=20,
    )
    r.raise_for_status()
    return r.json()["idToken"]


def main():
    print("=== Seeding test users ===")
    admin_uid  = ensure_user(ADMIN_EMAIL,  ADMIN_PASS,  "AdminUser",  "admin")
    parent_uid = ensure_user(PARENT_EMAIL, PARENT_PASS, "ParentUser", "parent")

    # Sign in as admin to verify token works
    print("\n=== Verifying admin token roundtrip ===")
    admin_token = signin_password(ADMIN_EMAIL, ADMIN_PASS)
    r = requests.post(f"{BACKEND}/auth/verify-token", json={"token": admin_token}, timeout=20)
    print(f"verify-token (admin): HTTP {r.status_code}")
    print(f"  body: {r.text[:300]}")

    # Sign in as parent and register
    print("\n=== Registering parent in backend DB ===")
    parent_token = signin_password(PARENT_EMAIL, PARENT_PASS)
    r = requests.post(
        f"{BACKEND}/auth/register-parent",
        headers={"Authorization": f"Bearer {parent_token}"},
        json={"name": "وليد ولي الأمر", "email": PARENT_EMAIL, "phone": "0501234567"},
        timeout=20,
    )
    print(f"register-parent: HTTP {r.status_code}")
    print(f"  body: {r.text[:300]}")

    creds = {
        "admin": {"email": ADMIN_EMAIL, "password": ADMIN_PASS, "uid": admin_uid},
        "parent": {"email": PARENT_EMAIL, "password": PARENT_PASS, "uid": parent_uid},
    }
    out = os.path.join(os.path.dirname(__file__), 'test_creds.json')
    with open(out, 'w', encoding='utf-8') as f:
        json.dump(creds, f, ensure_ascii=False, indent=2)
    print(f"\n=== Saved creds to {out} ===")


if __name__ == "__main__":
    main()
