import firebase_admin
from firebase_admin import auth, credentials
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.user import User, UserRole
from app.models.parent import Parent
from app.models.student import Student
from app.models.admin import Admin
from app.config import settings
from app.utils.helpers import generate_uuid

# تهيئة Firebase Admin SDK مرة واحدة
if not firebase_admin._apps:
    cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
    firebase_admin.initialize_app(cred)


def verify_firebase_token(token: str) -> dict:
    decoded_token = auth.verify_id_token(token)
    return decoded_token


def get_or_create_user(firebase_uid: str, role: str, name: str, email: str) -> User:
    db = SessionLocal()
    try:
        user = db.query(User).filter(User.firebase_uid == firebase_uid).first()
        if user:
            return user

        user = User(
            firebase_uid=firebase_uid,
            role=UserRole(role),
            name=name,
            email=email,
        )
        db.add(user)
        db.flush()

        if role == "student":
            student = Student(user_id=user.id)
            db.add(student)
        elif role == "parent":
            parent = Parent(user_id=user.id)
            db.add(parent)
        elif role == "admin":
            admin = Admin(user_id=user.id)
            db.add(admin)

        db.commit()
        db.refresh(user)
        return user
    finally:
        db.close()


def register_parent(data: dict) -> dict:
    firebase_user = auth.create_user(
        email=data["email"],
        password=data["password"],
        display_name=data["name"],
    )

    db = SessionLocal()
    try:
        user = User(
            firebase_uid=firebase_user.uid,
            role=UserRole.parent,
            name=data["name"],
            email=data["email"],
            phone=data.get("phone"),
        )
        db.add(user)
        db.flush()

        parent = Parent(user_id=user.id)
        db.add(parent)
        db.commit()
        db.refresh(user)

        return {
            "id": str(user.id),
            "name": user.name,
            "email": user.email,
            "role": user.role,
        }
    finally:
        db.close()


def add_child_to_parent(parent_id: str, child_data: dict) -> dict:
    db = SessionLocal()
    try:
        firebase_user = auth.create_user(
            display_name=child_data["name"],
        )

        user = User(
            firebase_uid=firebase_user.uid,
            role=UserRole.student,
            name=child_data["name"],
        )
        db.add(user)
        db.flush()

        student = Student(
            user_id=user.id,
            parent_id=parent_id,
            age=child_data.get("age"),
            grade=child_data.get("grade"),
            learning_level=child_data.get("learning_level"),
        )
        db.add(student)

        parent = db.query(Parent).filter(Parent.id == parent_id).first()
        if parent:
            parent.num_children = (parent.num_children or 0) + 1

        db.commit()
        db.refresh(user)

        return {
            "id": str(user.id),
            "name": user.name,
            "role": user.role,
        }
    finally:
        db.close()