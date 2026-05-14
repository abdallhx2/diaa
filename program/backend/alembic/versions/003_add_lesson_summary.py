"""Add summary column to lessons table

Revision ID: 003_add_lesson_summary
Revises: 002_add_indexes
Create Date: 2026-05-14
"""
from alembic import op
import sqlalchemy as sa

revision = '003_add_lesson_summary'
down_revision = '002_add_indexes'
branch_labels = None
depends_on = None


def upgrade():
    op.add_column('lessons', sa.Column('summary', sa.Text(), nullable=True))


def downgrade():
    op.drop_column('lessons', 'summary')
