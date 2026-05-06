from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func
from app.database import get_db
from app.models.user import User
from app.models.parent import Parent
from app.models.student import Student
from app.models.learning_session import LearningSession
from app.models.quiz_result import QuizResult
from app.services.report_service import get_weekly_report, get_monthly_report
from app.middleware.auth_middleware import get_current_user
from app.utils.helpers import format_response

router = APIRouter()


def _require_parent(current_user: User) -> Parent:
    """Ensure user is a parent and return the Parent record."""
    if current_user.role.value != "parent":
        raise HTTPException(status_code=403, detail=format_response(False, None, "الوصول مقصور على أولياء الأمور"))
    if not current_user.parent:
        raise HTTPException(status_code=404, detail=format_response(False, None, "سجل ولي الأمر غير موجود"))
    return current_user.parent


def _verify_child_belongs_to_parent(db: Session, parent: Parent, child_id: UUID) -> Student:
    """Verify that the child belongs to this parent."""
    student = db.query(Student).filter(Student.id == child_id, Student.parent_id == parent.id).first()
    if not student:
        raise HTTPException(status_code=403, detail=format_response(False, None, "هذا الطفل لا ينتمي لحسابك"))
    return student


@router.get("/children")
async def get_children(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get list of parent's children."""
    parent = _require_parent(current_user)
    try:
        children = (
            db.query(Student)
            .options(joinedload(Student.user))
            .filter(Student.parent_id == parent.id)
            .all()
        )
        children_list = []
        for child in children:
            children_list.append({
                "id": str(child.id),
                "name": child.user.name if child.user else "",
                "age": child.age,
                "grade": child.grade,
                "learning_level": child.learning_level,
                "progress_score": float(child.progress_score or 0),
            })
        return format_response(True, children_list, "قائمة الأبناء")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.get("/reports/{child_id}")
async def get_child_report(
    child_id: UUID,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get general report for a child."""
    parent = _require_parent(current_user)
    student = _verify_child_belongs_to_parent(db, parent, child_id)
    try:
        total_sessions = (
            db.query(func.count(LearningSession.id))
            .filter(LearningSession.student_id == student.id)
            .scalar()
        ) or 0
        total_quizzes = (
            db.query(func.count(QuizResult.id))
            .filter(QuizResult.student_id == student.id)
            .scalar()
        ) or 0

        report = {
            "child_name": student.user.name if student.user else "",
            "grade": student.grade,
            "learning_level": student.learning_level,
            "progress_score": float(student.progress_score or 0),
            "total_sessions": total_sessions,
            "total_quizzes": total_quizzes,
        }
        return format_response(True, report, "تقرير الطفل")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.get("/reports/{child_id}/weekly")
async def get_child_weekly_report(
    child_id: UUID,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get weekly report for a child."""
    parent = _require_parent(current_user)
    _verify_child_belongs_to_parent(db, parent, child_id)
    try:
        report = get_weekly_report(db, child_id)
        return format_response(True, report, "التقرير الأسبوعي")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.get("/reports/{child_id}/monthly")
async def get_child_monthly_report(
    child_id: UUID,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get monthly report for a child."""
    parent = _require_parent(current_user)
    _verify_child_belongs_to_parent(db, parent, child_id)
    try:
        report = get_monthly_report(db, child_id)
        return format_response(True, report, "التقرير الشهري")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))
