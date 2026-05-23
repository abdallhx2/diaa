"""Normalize grade values in students and lessons

Unify grade naming to the short form used by mobile (الأول/الثاني/.../السادس)
instead of the mixed forms found in legacy data:
  students.grade:        الأول | الثاني | الثالث | الخامس | الصف الاول | الصف الخامس
  lessons.grade_level:   الثالث | الصف الاول | الصف الثالث | الصف الخامس

Mobile expects the short form (see mobile/lib/config/constants.dart).

Revision ID: 006_normalize_grade
Revises: 005_fcm_tokens
Create Date: 2026-05-23
"""
from alembic import op

revision = '006_normalize_grade'
down_revision = '005_fcm_tokens'
branch_labels = None
depends_on = None


GRADE_MAP = {
    'الصف الاول': 'الأول',
    'الصف الأول': 'الأول',
    'الاول': 'الأول',
    'الصف الثاني': 'الثاني',
    'الصف الثالث': 'الثالث',
    'الصف الرابع': 'الرابع',
    'الصف الخامس': 'الخامس',
    'الصف السادس': 'السادس',
}


def upgrade():
    conn = op.get_bind()
    for old, new in GRADE_MAP.items():
        conn.exec_driver_sql(
            "UPDATE students SET grade = %s WHERE grade = %s",
            (new, old),
        )
        conn.exec_driver_sql(
            "UPDATE lessons SET grade_level = %s WHERE grade_level = %s",
            (new, old),
        )


def downgrade():
    # No-op: original mixed values cannot be reconstructed safely
    pass
