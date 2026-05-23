from collections import deque
from time import time
from threading import Lock

_store: dict[str, deque] = {}
_lock = Lock()


def check(uid: str, max_per_min: int = 15) -> bool:
    """Returns True if the request is allowed, False if rate limit exceeded."""
    now = time()
    window_start = now - 60.0
    with _lock:
        if uid not in _store:
            _store[uid] = deque()
        timestamps = _store[uid]
        while timestamps and timestamps[0] < window_start:
            timestamps.popleft()
        if len(timestamps) >= max_per_min:
            return False
        timestamps.append(now)
        return True
