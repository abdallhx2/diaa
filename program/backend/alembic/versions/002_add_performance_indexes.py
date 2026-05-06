"""Add performance indexes for frequently queried columns

Revision ID: 002_add_indexes
Revises: None
Create Date: 2026-03-10
"""
from alembic import op

revision = '002_add_indexes'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # Foreign key indexes for JOIN performance
    # NOTE: students.user_id skipped — unique=True already creates an index
    op.create_index('ix_students_parent_id', 'students', ['parent_id'])
    op.create_index('ix_learning_sessions_student_id', 'learning_sessions', ['student_id'])
    op.create_index('ix_learning_sessions_lesson_id', 'learning_sessions', ['lesson_id'])
    op.create_index('ix_quiz_results_student_id', 'quiz_results', ['student_id'])
    op.create_index('ix_quiz_results_quiz_id', 'quiz_results', ['quiz_id'])
    op.create_index('ix_chat_messages_student_id', 'chat_messages', ['student_id'])
    op.create_index('ix_chat_messages_lesson_id', 'chat_messages', ['lesson_id'])
    op.create_index('ix_quizzes_lesson_id', 'quizzes', ['lesson_id'])
    op.create_index('ix_system_logs_user_id', 'system_logs', ['user_id'])

    # Filter/sort indexes
    op.create_index('ix_system_logs_created_at', 'system_logs', ['created_at'])
    op.create_index('ix_lessons_grade_level', 'lessons', ['grade_level'])
    op.create_index('ix_lessons_qr_code', 'lessons', ['qr_code'], unique=True)


def downgrade():
    op.drop_index('ix_lessons_qr_code', table_name='lessons')
    op.drop_index('ix_lessons_grade_level', table_name='lessons')
    op.drop_index('ix_system_logs_created_at', table_name='system_logs')
    op.drop_index('ix_system_logs_user_id', table_name='system_logs')
    op.drop_index('ix_quizzes_lesson_id', table_name='quizzes')
    op.drop_index('ix_chat_messages_lesson_id', table_name='chat_messages')
    op.drop_index('ix_chat_messages_student_id', table_name='chat_messages')
    op.drop_index('ix_quiz_results_quiz_id', table_name='quiz_results')
    op.drop_index('ix_quiz_results_student_id', table_name='quiz_results')
    op.drop_index('ix_learning_sessions_lesson_id', table_name='learning_sessions')
    op.drop_index('ix_learning_sessions_student_id', table_name='learning_sessions')
    op.drop_index('ix_students_parent_id', table_name='students')
