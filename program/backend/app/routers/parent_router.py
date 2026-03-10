from fastapi import APIRouter, Depends, Request, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.parent import Parent
from app.models.student import Student
from app.services.report_service import get_weekly_report, get_monthly_report
from app.utils.helpers import format_response

router = APIRouter()


def require_parent(request: Request):
    user = request.state.user
    if user.role != "parent":
        raise HTTPException(
            status_code=403,
            detail=format_response(False, None, "غير مصرح — هذه الصفحة لأولياء الأمور فقط")
        )
    return user


def verify_child_belongs_to_parent(db: Session, child_id: int, parent_id: int):
    child = db.query(Student).filter(
        Student.id == child_id,
        Student.parent_id == parent_id
    ).first()
    if not child:
        raise HTTPException(
            status_code=403,
            detail=format_response(False, None, "غير مصرح — هذا الطفل لا ينتمي لحسابك")
        )
    return child


@router.get("/children")
async def get_children(request: Request, db: Session = Depends(get_db)):
    user = require_parent(request)

    parent = db.query(Parent).filter(Parent.user_id == user.id).first()
    if not parent:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "بيانات ولي الأمر غير موجودة")
        )

    children = db.query(Student).filter(Student.parent_id == parent.id).all()

    children_list = [
        {
            "id": child.id,
            "name": child.name,
            "age": child.age,
            "grade": child.grade,
            "learning_level": child.learning_level
        }
        for child in children
    ]

    return format_response(True, children_list, "قائمة الأبناء")


@router.get("/reports/{child_id}")
async def get_child_report(child_id: int, request: Request, db: Session = Depends(get_db)):
    user = require_parent(request)

    parent = db.query(Parent).filter(Parent.user_id == user.id).first()
    if not parent:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "بيانات ولي الأمر غير موجودة")
        )

    child = verify_child_belongs_to_parent(db, child_id=child_id, parent_id=parent.id)

    report_data = {
        "child": {
            "id": child.id,
            "name": child.name,
            "grade": child.grade,
            "learning_level": child.learning_level
        }
    }

    return format_response(True, report_data, "تقرير الطفل")


@router.get("/reports/{child_id}/weekly")
async def get_child_weekly_report(child_id: int, request: Request, db: Session = Depends(get_db)):
    user = require_parent(request)

    parent = db.query(Parent).filter(Parent.user_id == user.id).first()
    if not parent:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "بيانات ولي الأمر غير موجودة")
        )

    verify_child_belongs_to_parent(db, child_id=child_id, parent_id=parent.id)

    weekly_report = get_weekly_report(db, child_id=child_id)

    return format_response(True, weekly_report, "التقرير الأسبوعي")


@router.get("/reports/{child_id}/monthly")
async def get_child_monthly_report(child_id: int, request: Request, db: Session = Depends(get_db)):
    user = require_parent(request)

    parent = db.query(Parent).filter(Parent.user_id == user.id).first()
    if not parent:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "بيانات ولي الأمر غير موجودة")
        )

    verify_child_belongs_to_parent(db, child_id=child_id, parent_id=parent.id)

    monthly_report = get_monthly_report(db, child_id=child_id)

    return format_response(True, monthly_report, "التقرير الشهري")