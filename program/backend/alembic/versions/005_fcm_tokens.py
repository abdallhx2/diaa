"""Add fcm_tokens table

Revision ID: 005_fcm_tokens
Revises: 004_achievements
Create Date: 2026-05-15
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import UUID

revision = '005_fcm_tokens'
down_revision = '004_achievements'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        "fcm_tokens",
        sa.Column("id", UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("user_id", UUID(as_uuid=True), sa.ForeignKey("users.id"), nullable=False),
        sa.Column("token", sa.Text(), nullable=False),
        sa.Column("platform", sa.String(10), nullable=False),
        sa.Column("created_at", sa.DateTime(), nullable=True, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(), nullable=True, server_default=sa.func.now(), onupdate=sa.func.now()),
        sa.UniqueConstraint("user_id", "token", name="uq_user_fcm_token"),
    )
    op.create_index("ix_fcm_tokens_user_id", "fcm_tokens", ["user_id"])


def downgrade():
    op.drop_index("ix_fcm_tokens_user_id", table_name="fcm_tokens")
    op.drop_table("fcm_tokens")
