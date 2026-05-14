"""Fix student grade for student.test@diaa.com"""
import sys, os
sys.path.insert(0, '/d/Student/Edu/program/backend')
os.chdir('/d/Student/Edu/program/backend')

from dotenv import load_dotenv
load_dotenv('.env')

from app.database import engine
from app.models.student import Student
from app.models.user import User
from sqlalchemy.orm import sessionmaker

SessionLocal = sessionmaker(bind=engine)
db = SessionLocal()

try:
    # List all users
    users = db.query(User).filter(User.email != None).all()
    for u in users:
        print(f"  User: {u.id} | {u.email} | role={u.role}")
    
    # Find user by email
    user = db.query(User).filter(User.email == "student.test@diaa.com").first()
    if not user:
        print("ERROR: User not found by email — trying by role=student")
        students_users = db.query(User).all()
        for u in students_users:
            print(f"  All users: {u.id} | {u.email} | role={u.role}")
        sys.exit(1)
    
    print(f"\nFound user: {user.id} - {user.email}")
    student = db.query(Student).filter(Student.user_id == user.id).first()
    if not student:
        print("ERROR: Student record not found")
        sys.exit(1)
    
    print(f"Student ID: {student.id}, current grade: '{student.grade}'")
    student.grade = "الثالث"
    db.commit()
    db.refresh(student)
    print(f"Updated grade to: '{student.grade}'")
finally:
    db.close()
