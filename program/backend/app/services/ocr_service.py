import base64
import io
from PIL import Image
from app.config import settings
from app.services.openrouter_client import client

OCR_PROMPT = """أنت أداة استخراج نص من الصور. استخرج كل النص العربي والإنجليزي الموجود في الصورة.
- أعد النص فقط بدون أي شرح أو تعليق
- حافظ على ترتيب النص كما يظهر في الصورة (من أعلى لأسفل)
- إذا لم يكن هناك نص في الصورة، أعد كلمة: فارغ
"""


def _image_to_base64(image_bytes: bytes) -> str:
    """Convert image bytes to base64 data URL for vision model."""
    image = Image.open(io.BytesIO(image_bytes))

    # Resize if too large (max 2000px on longest side)
    max_dim = 2000
    if max(image.size) > max_dim:
        ratio = max_dim / max(image.size)
        new_size = (int(image.width * ratio), int(image.height * ratio))
        image = image.resize(new_size, Image.LANCZOS)

    # Convert to RGB if needed (remove alpha channel)
    if image.mode in ("RGBA", "P"):
        image = image.convert("RGB")

    # Encode to JPEG base64
    buffer = io.BytesIO()
    image.save(buffer, format="JPEG", quality=85)
    b64 = base64.b64encode(buffer.getvalue()).decode("utf-8")
    return f"data:image/jpeg;base64,{b64}"


def extract_text(image_bytes: bytes) -> str:
    """Extract Arabic/English text from image using OpenRouter vision model.
    Returns extracted text or empty string on error.
    """
    if settings.MOCK_AI:
        from app.services.mock_services import MockOCR

        mock_reader = MockOCR()
        results = mock_reader.readtext(None)
        return " ".join([r[1] for r in results])

    try:
        image_url = _image_to_base64(image_bytes)

        response = client.chat.completions.create(
            model=settings.VISION_MODEL,
            messages=[
                {
                    "role": "user",
                    "content": [
                        {"type": "text", "text": OCR_PROMPT},
                        {
                            "type": "image_url",
                            "image_url": {"url": image_url},
                        },
                    ],
                }
            ],
            max_tokens=1000,
            temperature=0.1,
        )

        text = response.choices[0].message.content.strip()

        # If model says empty, return empty string
        if text == "فارغ":
            return ""

        return text

    except Exception:
        return ""


def extract_text_from_image(image_bytes: bytes) -> str:
    """Alias for extract_text — kept for backward compatibility."""
    return extract_text(image_bytes)


def get_confidence_stats(results: list) -> dict:
    """Return confidence stats. With vision model, confidence is always high.
    Kept for backward compatibility with routers.
    """
    if not results:
        return {"avg_confidence": 0.0, "words_count": 0}
    return {"avg_confidence": 0.95, "words_count": len(results.split()) if isinstance(results, str) else 0}
