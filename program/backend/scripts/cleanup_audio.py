#!/usr/bin/env python3
"""Delete audio files older than 7 days from static/audio/."""
import os
import time
from pathlib import Path

AUDIO_DIR = Path(__file__).parent.parent / "static" / "audio"
MAX_AGE_SECONDS = 7 * 24 * 3600


def main():
    if not AUDIO_DIR.exists():
        print(f"Audio dir not found: {AUDIO_DIR}")
        return

    now = time.time()
    deleted = 0
    skipped = 0

    for f in AUDIO_DIR.iterdir():
        if not f.is_file():
            continue
        age = now - f.stat().st_mtime
        if age > MAX_AGE_SECONDS:
            f.unlink()
            deleted += 1
        else:
            skipped += 1

    print(f"Audio cleanup: deleted={deleted}, kept={skipped}")


if __name__ == "__main__":
    main()
