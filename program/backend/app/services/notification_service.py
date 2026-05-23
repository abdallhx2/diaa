from sqlalchemy.orm import Session
from app.models.fcm_token import FcmToken
from app.models.student import Student


def send_to_user(db: Session, user_id, title: str, body: str, data: dict = None):
    """Send FCM push to all tokens registered for a user. Removes invalid tokens."""
    if data is None:
        data = {}

    try:
        from firebase_admin import messaging
    except ImportError:
        return

    tokens = db.query(FcmToken).filter(FcmToken.user_id == user_id).all()
    if not tokens:
        return

    for fcm in tokens:
        msg = messaging.Message(
            notification=messaging.Notification(title=title, body=body),
            data={k: str(v) for k, v in data.items()},
            token=fcm.token,
        )
        try:
            messaging.send(msg)
        except Exception as e:
            err_str = str(e).lower()
            if "unregistered" in err_str or "not-registered" in err_str or "invalid-registration-token" in err_str:
                db.delete(fcm)
                db.commit()


def notify_parent_of_child_event(db: Session, student_id, event_type: str, payload: dict = None):
    """Find parent of student and send them a push notification."""
    if payload is None:
        payload = {}

    student = (
        db.query(Student)
        .filter(Student.id == student_id)
        .first()
    )
    if not student or not student.parent:
        return

    parent_user_id = student.parent.user_id
    child_name = student.user.name if student.user else "الطفل"

    if event_type == "lesson_completed":
        lesson_title = payload.get("lesson_title", "")
        title = "درس جديد منجز"
        body = f"{child_name} أنهى درس {lesson_title}" if lesson_title else f"{child_name} أنهى درسًا جديدًا"

    elif event_type == "quiz_completed":
        score = payload.get("score", 0)
        total = payload.get("total", 0)
        lesson_title = payload.get("lesson_title", "")
        title = "نتيجة اختبار"
        body = f"{child_name} حصل على {score}/{total} في {lesson_title}" if lesson_title else f"{child_name} حصل على {score}/{total}"

    elif event_type == "achievement_unlocked":
        name_ar = payload.get("name_ar", "")
        title = "إنجاز جديد"
        body = f'{child_name} فتح إنجاز "{name_ar}" 🎉'

    else:
        return

    send_to_user(db, parent_user_id, title, body, data={"event_type": event_type, **payload})
