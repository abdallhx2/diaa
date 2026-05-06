import uuid
from datetime import datetime, timezone
from typing import Any, Optional


def generate_uuid() -> str:
    return str(uuid.uuid4())


def get_current_timestamp() -> datetime:
    return datetime.now(timezone.utc)


def standard_response(success: bool, data: Any = None, message: str = "") -> dict:
    return {
        "success": success,
        "data": data,
        "message": message,
    }


# Alias for backward compatibility
format_response = standard_response


def paginate(query, page: int = 1, per_page: int = 20):
    """Apply pagination to a SQLAlchemy query. Returns (items, total)."""
    page = max(1, page)
    per_page = max(1, min(per_page, 100))
    total = query.count()
    items = query.offset((page - 1) * per_page).limit(per_page).all()
    return items, total


def is_valid_uuid(value: str) -> bool:
    """Validate whether a string is a valid UUID."""
    try:
        uuid.UUID(str(value))
        return True
    except (ValueError, AttributeError):
        return False
