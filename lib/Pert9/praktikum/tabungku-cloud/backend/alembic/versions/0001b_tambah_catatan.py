"""Tambah kolom catatan pada kegiatan.

Revision ID: 0001b
Revises: 0001
"""
from alembic import op
import sqlalchemy as sa

revision = "0001b"
down_revision = "0001"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column("kegiatan", sa.Column("catatan", sa.Text(), nullable=True))


def downgrade() -> None:
    op.drop_column("kegiatan", "catatan")
