from sqlalchemy.orm import Session
from app.config import settings as _cfg
from app.models.user import User, UserRole
from app.models.parent import Parent
from app.models.student import Student
from app.models.admin import Admin

# Only import Firebase SDK when not in mock mode
if not _cfg.USE_MOCKS:
    from firebase_admin import auth


def verify_firebase_token(token: str) -> dict:
    """Verify a Firebase ID token and return the decoded claims."""
    from app.config import settings
    if settings.USE_MOCKS:
        from app.services.mock_services import MockFirebaseAuth
        return MockFirebaseAuth.verify_id_token(token)
    try:
        decoded_token = auth.verify_id_token(token)
        return decoded_token
    except Exception as e:
        raise Exception(f"فشل التحقق من التوكن: {str(e)}")


def get_user_by_firebase_uid(db: Session, firebase_uid: str) -> User | None:
    """Look up a user by their Firebase UID."""
    return db.query(User).filter(User.firebase_uid == firebase_uid).first()


def get_or_create_user(
    db: Session,
    firebase_uid: str,
    role: str,
    name: str,
    email: str | None = None,
) -> User:
    """Find existing user by firebase_uid or create a new one with the appropriate role record."""
    existing = db.query(User).filter(User.firebase_uid == firebase_uid).first()
    if existing:
        return existing

    user = User(
        firebase_uid=firebase_uid,
        role=UserRole(role),
        name=name,
        email=email,
    )
    db.add(user)
    db.flush()

    if role == "student":
        student = Student(user_id=user.id, grade="غير محدد")
        db.add(student)
    elif role == "parent":
        parent = Parent(user_id=user.id)
        db.add(parent)
    elif role == "admin":
        admin_record = Admin(user_id=user.id)
        db.add(admin_record)

    db.commit()
    db.refresh(user)
    return user


def register_parent(db: Session, name: str, email: str | None = None, phone: str | None = None, firebase_uid: str = "") -> User:
    """Register a new parent user. Firebase account should already exist."""
    try:
        user = User(
            firebase_uid=firebase_uid,
            role=UserRole.parent,
            name=name,
            email=email,
            phone=phone,
        )
        db.add(user)
        db.flush()

        parent = Parent(user_id=user.id)
        db.add(parent)

        db.commit()
        db.refresh(user)
        return user
    except Exception as e:
        db.rollback()
        raise Exception(f"فشل تسجيل ولي الأمر: {str(e)}")


def add_child(
    db: Session,
    parent_user: User,
    child_firebase_uid: str,
    child_name: str,
    age: int | None = None,
    grade: str = "غير محدد",
    learning_level: str = "مبتدئ",
) -> User:
    """Add a child (student) linked to a parent."""
    try:
        parent_record = db.query(Parent).filter(Parent.user_id == parent_user.id).first()
        if not parent_record:
            raise Exception("سجل ولي الأمر غير موجود")

        child_user = User(
            firebase_uid=child_firebase_uid,
            role=UserRole.student,
            name=child_name,
        )
        db.add(child_user)
        db.flush()

        student = Student(
            user_id=child_user.id,
            parent_id=parent_record.id,
            age=age,
            grade=grade,
            learning_level=learning_level,
        )
        db.add(student)

        db.commit()
        db.refresh(child_user)
        return child_user
    except Exception as e:
        db.rollback()
        raise Exception(f"فشل إضافة الطفل: {str(e)}")


def get_user_profile(db: Session, user: User) -> dict:
    """Get full user profile including role-specific data."""
    profile = {
        "id": str(user.id),
        "name": user.name,
        "email": user.email,
        "role": user.role.value if hasattr(user.role, "value") else user.role,
        "phone": user.phone,
        "created_at": str(user.created_at),
        "is_active": user.is_active,
    }

    if user.role == UserRole.student and user.student:
        profile["student"] = {
            "id": str(user.student.id),
            "grade": user.student.grade,
            "learning_level": user.student.learning_level,
            "progress_score": float(user.student.progress_score or 0),
        }
    elif user.role == UserRole.parent and user.parent:
        children = []
        for child in user.parent.children:
            children.append({
                "id": str(child.id),
                "name": child.user.name if child.user else "",
                "grade": child.grade,
            })
        profile["children"] = children
    elif user.role == UserRole.admin and user.admin:
        profile["admin_level"] = user.admin.admin_level

    return profile
