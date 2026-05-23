"""Add achievements, student_achievements, student_streaks tables

Revision ID: 004_achievements
Revises: 003_add_lesson_summary
Create Date: 2026-05-15
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import UUID
import uuid

revision = '004_achievements'
down_revision = '003_add_lesson_summary'
branch_labels = None
depends_on = None

SEED_ACHIEVEMENTS = [
    ("streak_3",    "متابع نشيط",      "3 أيام متتالية",           "🔥", 3,  "streak"),
    ("streak_7",    "أسبوع كامل",       "7 أيام متتالية",           "⭐", 7,  "streak"),
    ("streak_30",   "بطل المثابرة",     "30 يوم متتالي",            "🏆", 30, "streak"),
    ("lessons_1",   "أول درس",          "إكمال درس واحد",           "📚", 1,  "lessons"),
    ("lessons_5",   "قارئ نشط",         "إكمال 5 دروس",             "📖", 5,  "lessons"),
    ("quiz_perfect","إجابة كاملة",      "3/3 في اختبار",            "💯", 1,  "perfect"),
    ("readings_10", "الماسح الذهبي",    "10 صور OCR",               "📸", 10, "readings"),
    ("quizzes_10",  "مختبر محترف",      "إكمال 10 اختبارات",        "✏️", 10, "quizzes"),
]


def upgrade():
    op.create_table(
        "achievements",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, default=uuid.uuid4),
        sa.Column("code", sa.String(40), unique=True, nullable=False),
        sa.Column("name_ar", sa.String(80), nullable=False),
        sa.Column("description_ar", sa.Text(), nullable=True),
        sa.Column("icon_emoji", sa.String(10), nullable=True),
        sa.Column("threshold", sa.Integer(), nullable=False),
        sa.Column("kind", sa.String(20), nullable=False),
    )

    op.create_table(
        "student_achievements",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, default=uuid.uuid4),
        sa.Column("student_id", UUID(as_uuid=True), sa.ForeignKey("students.id"), nullable=False),
        sa.Column("achievement_id", UUID(as_uuid=True), sa.ForeignKey("achievements.id"), nullable=False),
        sa.Column("unlocked_at", sa.DateTime(), nullable=True, server_default=sa.func.now()),
        sa.UniqueConstraint("student_id", "achievement_id", name="uq_student_achievement"),
    )

    op.create_table(
        "student_streaks",
        sa.Column("student_id", UUID(as_uuid=True), sa.ForeignKey("students.id"), primary_key=True),
        sa.Column("current_streak", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("longest_streak", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("last_activity_date", sa.Date(), nullable=True),
    )

    # Seed the 8 achievements catalog rows
    achievements_table = sa.table(
        "achievements",
        sa.column("id", UUID(as_uuid=True)),
        sa.column("code", sa.String),
        sa.column("name_ar", sa.String),
        sa.column("description_ar", sa.Text),
        sa.column("icon_emoji", sa.String),
        sa.column("threshold", sa.Integer),
        sa.column("kind", sa.String),
    )
    op.bulk_insert(
        achievements_table,
        [
            {
                "id": uuid.uuid4(),
                "code": code,
                "name_ar": name_ar,
                "description_ar": desc,
                "icon_emoji": icon,
                "threshold": threshold,
                "kind": kind,
            }
            for code, name_ar, desc, icon, threshold, kind in SEED_ACHIEVEMENTS
        ],
    )


def downgrade():
    op.drop_table("student_streaks")
    op.drop_table("student_achievements")
    op.drop_table("achievements")
