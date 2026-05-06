import os
from sqlalchemy import create_engine, event
from sqlalchemy.orm import sessionmaker, DeclarativeBase
from app.config import settings

if settings.USE_MOCKS:
    # SQLite for local dev — no PostgreSQL needed
    _db_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), "edu_smart.db")
    SQLALCHEMY_DATABASE_URL = f"sqlite:///{_db_path}"
    engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})

    # Enable WAL mode and foreign keys for SQLite
    @event.listens_for(engine, "connect")
    def _set_sqlite_pragma(dbapi_conn, connection_record):
        cursor = dbapi_conn.cursor()
        cursor.execute("PRAGMA journal_mode=WAL")
        cursor.execute("PRAGMA foreign_keys=ON")
        cursor.close()
else:
    SQLALCHEMY_DATABASE_URL = settings.DATABASE_URL
    engine = create_engine(SQLALCHEMY_DATABASE_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


class Base(DeclarativeBase):
    pass


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
