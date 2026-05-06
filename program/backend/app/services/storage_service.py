from app.config import settings

# Only import Firebase SDK when not in mock mode
if not settings.USE_MOCKS:
    import firebase_admin
    from firebase_admin import storage

# In-memory audio cache: cache_key -> URL
_audio_cache: dict = {}


def _get_bucket():
    """Get the Firebase Storage bucket. Ensures the default app has storageBucket configured."""
    try:
        return storage.bucket()
    except Exception:
        # If bucket name not set on default app, try with explicit name
        return storage.bucket(settings.FIREBASE_STORAGE_BUCKET)


def upload_to_firebase(file_bytes: bytes, path: str) -> str:
    """Upload file bytes to Firebase Storage and return the public URL."""
    from app.config import settings as _settings
    if _settings.USE_MOCKS:
        from app.services.mock_services import MockFirebaseStorage
        return MockFirebaseStorage.upload(file_bytes, path)

    try:
        bucket = _get_bucket()
        blob = bucket.blob(path)
        blob.upload_from_string(file_bytes, content_type="audio/mpeg")
        blob.make_public()
        return blob.public_url
    except Exception as e:
        raise Exception(f"فشل رفع الملف إلى Firebase Storage: {str(e)}")


def get_download_url(path: str) -> str | None:
    """Check if a file exists in Firebase Storage and return its public URL, or None."""
    from app.config import settings as _settings
    if _settings.USE_MOCKS:
        from app.services.mock_services import MockFirebaseStorage
        return MockFirebaseStorage.get_url(path)

    try:
        bucket = _get_bucket()
        blob = bucket.blob(path)
        if blob.exists():
            blob.make_public()
            return blob.public_url
        return None
    except Exception:
        return None


def delete_file(path: str) -> bool:
    """Delete a file from Firebase Storage. Returns True on success."""
    from app.config import settings as _settings
    if _settings.USE_MOCKS:
        from app.services.mock_services import MockFirebaseStorage
        return MockFirebaseStorage.delete(path)

    try:
        bucket = _get_bucket()
        blob = bucket.blob(path)
        blob.delete()
        return True
    except Exception:
        return False


def get_cached_audio(cache_key: str) -> str | None:
    """Return cached audio URL for the given cache key, or None if not cached."""
    return _audio_cache.get(cache_key)


def upload_audio(file_path: str, cache_key: str) -> str:
    """Upload an audio file to Firebase Storage, store URL in cache, return URL.
    file_path: local path to the audio file.
    cache_key: key used for storage path and in-memory cache.
    """
    try:
        storage_path = f"audio/{cache_key}.mp3"

        with open(file_path, "rb") as f:
            file_bytes = f.read()

        url = upload_to_firebase(file_bytes, storage_path)
        _audio_cache[cache_key] = url
        return url
    except Exception as e:
        raise Exception(f"فشل رفع الملف الصوتي: {str(e)}")
