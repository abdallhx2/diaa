import hashlib
import os
import io
import wave
import json
import base64
import httpx
from app.config import settings

# In-memory cache: cache_key → local URL
_audio_cache: dict[str, str] = {}


def _get_cache_key(text: str) -> str:
    """Generate an MD5 hash string from the given text, used as cache key."""
    return hashlib.md5(text.encode("utf-8")).hexdigest()


def _generate_audio_via_openrouter(text: str) -> bytes:
    """Generate speech audio via OpenRouter gpt-audio-mini streaming.
    Returns WAV bytes.
    """
    audio_chunks = []

    with httpx.stream(
        "POST",
        "https://openrouter.ai/api/v1/chat/completions",
        headers={
            "Authorization": f"Bearer {settings.OPENROUTER_API_KEY}",
            "HTTP-Referer": "https://edu-smart.app",
            "X-Title": "Edu Smart Assistant",
            "Content-Type": "application/json",
        },
        json={
            "model": settings.TTS_MODEL,
            "modalities": ["text", "audio"],
            "audio": {"voice": settings.TTS_VOICE, "format": "pcm16"},
            "messages": [
                {
                    "role": "user",
                    "content": f"اقرأ النص التالي بصوت واضح بالعربية:\n{text}",
                }
            ],
            "stream": True,
        },
        timeout=30,
    ) as response:
        for line in response.iter_lines():
            if line.startswith("data: ") and "DONE" not in line:
                try:
                    chunk = json.loads(line[6:])
                    choices = chunk.get("choices", [])
                    if choices:
                        delta = choices[0].get("delta", {})
                        audio = delta.get("audio", {})
                        if audio and audio.get("data"):
                            audio_chunks.append(audio["data"])
                except (json.JSONDecodeError, KeyError, IndexError):
                    pass

    if not audio_chunks:
        raise Exception("لم يتم إنشاء صوت — لا توجد بيانات صوتية")

    # Decode base64 PCM16 chunks
    full_b64 = "".join(audio_chunks)
    pcm_data = base64.b64decode(full_b64)

    # Convert PCM16 to WAV (24kHz mono 16-bit)
    wav_buf = io.BytesIO()
    with wave.open(wav_buf, "wb") as wf:
        wf.setnchannels(1)
        wf.setsampwidth(2)
        wf.setframerate(24000)
        wf.writeframes(pcm_data)

    return wav_buf.getvalue()


def convert_to_speech(text: str) -> str:
    """Convert Arabic text to speech via OpenRouter audio model.
    Flow: memory cache → local file check → OpenRouter TTS → write to static/audio/ → return URL.
    """
    if not text or not text.strip():
        raise ValueError("النص مطلوب لتحويله إلى صوت")

    if settings.MOCK_AI:
        from app.services.mock_services import MockTTS
        return MockTTS.convert(text)

    try:
        cache_key = _get_cache_key(text)

        # In-memory cache fast path
        if cache_key in _audio_cache:
            return _audio_cache[cache_key]

        audio_dir = "static/audio"
        os.makedirs(audio_dir, exist_ok=True)
        file_path = os.path.join(audio_dir, f"{cache_key}.wav")
        audio_url = f"/static/audio/{cache_key}.wav"

        # File already on disk — no need to regenerate
        if os.path.exists(file_path):
            _audio_cache[cache_key] = audio_url
            return audio_url

        # Generate speech via OpenRouter
        wav_bytes = _generate_audio_via_openrouter(text)

        with open(file_path, "wb") as f:
            f.write(wav_bytes)

        _audio_cache[cache_key] = audio_url
        return audio_url

    except ValueError:
        raise
    except Exception as e:
        raise Exception(f"خطأ في خدمة تحويل النص إلى صوت: {str(e)}")


def convert_to_speech_fallback(text: str) -> dict:
    """Safe version of convert_to_speech — never raises.
    Returns dict with has_audio flag and optional url.
    """
    try:
        url = convert_to_speech(text)
        return {"has_audio": True, "url": url}
    except Exception:
        return {"has_audio": False, "url": None}


def generate_speech(text: str) -> str:
    """Alias for convert_to_speech — kept for backward compatibility."""
    return convert_to_speech(text)
