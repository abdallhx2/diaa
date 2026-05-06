from app.schemas.auth_schema import (
    TokenVerifyRequest, RegisterParentRequest, AddChildRequest,
    UserResponse, LoginResponse, TokenResponse,
)
from app.schemas.student_schema import StudentCreate, StudentUpdate, StudentResponse, StudentDashboard
from app.schemas.lesson_schema import LessonCreate, LessonResponse, LessonUpdate
from app.schemas.quiz_schema import QuizCreate, QuizResponse, QuizSubmit, QuizResultResponse
from app.schemas.chat_schema import ChatRequest, ChatResponse, ChatHistoryResponse
from app.schemas.report_schema import WeeklyReport, MonthlyReport, ChildReport
from app.schemas.admin_schema import AdminDashboard, UserManage, SystemSettings
