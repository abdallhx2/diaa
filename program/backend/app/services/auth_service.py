# app/services/auth_service.py

import firebase_admin
from firebase_admin import auth, credentials
from sqlalchemy.orm import Session

from app.config import settings
from app.models.parent import Parent
from app.models.student import Student
from app.models.user import User
from app.utils.helpers import generate_uuid


# Initialize Firebase Admin SDK once
if not firebase_admin._apps:
    cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
    firebase_admin.initialize_app(cred)


def verify_firebase_token(token: str) -> dict:
    """
    Verify Firebase ID token and return decoded payload.
    """
    try:
        decoded_token = auth.verify_id_token(token)
        return decoded_token
    except auth.ExpiredIdTokenError:
        raise Exception("Token has expired")
    except auth.InvalidIdTokenError:
        raise Exception("Invalid token")
    except Exception as e:
        raise Exception(f"Token verification failed: {str(e)}")


def get_or_create_user(
    db: Session,
    firebase_uid: str,
    role: str,
    name: str,
    email: str,
) -> User:
    """
    Get user by firebase_uid or create a new one.
    Also creates related Parent/Student record when needed.
    """
    existing_user = db.query(User).filter(User.firebase_uid == firebase_uid).first()
    if existing_user:
        return existing_user

    new_user = User(
        id=generate_uuid(),
        firebase_uid=firebase_uid,
        role=role,
        name=name,
        email=email,
        is_active=True,
    )
    db.add(new_user)
    db.flush()

    if role == "parent":
        parent = Parent(
            id=generate_uuid(),
            user_id=new_user.id,
            phone="",
            num_children=0,
        )
        db.add(parent)

    elif role == "student":
        student = Student(
            id=generate_uuid(),
            user_id=new_user.id,
            parent_id=None,
            name=name,
            age=0,
            grade="",
            learning_level="beginner",
        )
        db.add(student)

    db.commit()
    db.refresh(new_user)
    return new_user


def register_parent(db: Session, data) -> dict:
    """
    Create a new parent account in Firebase and local database.
    Expects:
    - data.name
    - data.email
    - data.password
    - data.phone
    """
    existing_user = db.query(User).filter(User.email == data.email).first()
    if existing_user:
        raise ValueError("البريد الإلكتروني مستخدم مسبقاً")

    try:
        firebase_user = auth.create_user(
            email=data.email,
            password=data.password,
            display_name=data.name,
        )
    except Exception as e:
        raise ValueError(f"فشل إنشاء حساب Firebase: {str(e)}")

    new_user = User(
        id=generate_uuid(),
        firebase_uid=firebase_user.uid,
        role="parent",
        name=data.name,
        email=data.email,
        is_active=True,
    )
    db.add(new_user)
    db.flush()

    new_parent = Parent(
        id=generate_uuid(),
        user_id=new_user.id,
        phone=getattr(data, "phone", ""),
        num_children=0,
    )
    db.add(new_parent)

    db.commit()
    db.refresh(new_user)
    db.refresh(new_parent)

    return {
        "id": new_user.id,
        "firebase_uid": new_user.firebase_uid,
        "name": new_user.name,
        "email": new_user.email,
        "role": new_user.role,
        "phone": new_parent.phone,
        "num_children": new_parent.num_children,
    }


def add_child_to_parent(db: Session, parent_id, child_data) -> dict:
    """
    Add a child to an existing parent.

    Expects:
    - child_data.name
    - child_data.age
    - child_data.grade
    - child_data.learning_level

    Optional:
    - child_data.email
    - child_data.password

    If email/password are provided, a Firebase account is created.
    Otherwise, a local placeholder firebase_uid is generated.
    """
    parent = db.query(Parent).filter(Parent.id == parent_id).first()
    if not parent:
        raise ValueError("ولي الأمر غير موجود")
    child_email = getattr(child_data, "email", None)
    child_password = getattr(child_data, "password", None)

    firebase_uid = None

    if child_email and child_password:
        try:
            firebase_user = auth.create_user(
                email=child_email,
                password=child_password,
                display_name=child_data.name,
            )
            firebase_uid = firebase_user.uid
        except Exception as e:
            raise ValueError(f"فشل إنشاء حساب Firebase للطفل: {str(e)}")
    else:
        firebase_uid = f"local-student-{generate_uuid()}"

    new_user = User(
        id=generate_uuid(),
        firebase_uid=firebase_uid,
        role="student",
        name=child_data.name,
        email=child_email or "",
        is_active=True,
    )
    db.add(new_user)
    db.flush()

    new_student = Student(
        id=generate_uuid(),
        user_id=new_user.id,
        parent_id=parent_id,
        name=child_data.name,
        age=child_data.age,
        grade=child_data.grade,
        learning_level=getattr(child_data, "learning_level", "beginner"),
    )
    db.add(new_student)

    if hasattr(parent, "num_children"):
        parent.num_children = (parent.num_children or 0) + 1

    db.commit()
    db.refresh(new_user)
    db.refresh(new_student)

    return {
        "id": new_student.id,
        "user_id": new_user.id,
        "firebase_uid": new_user.firebase_uid,
        "parent_id": new_student.parent_id,
        "name": new_student.name,
        "age": new_student.age,
        "grade": new_student.grade,
        "learning_level": new_student.learning_level,
    }