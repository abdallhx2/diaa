"""
Central OpenRouter client — single entry point for all AI services.
Uses OpenAI-compatible SDK with OpenRouter base URL.
"""

from app.config import settings

client = None
if not settings.MOCK_AI:
    from openai import OpenAI

    client = OpenAI(
        base_url="https://openrouter.ai/api/v1",
        api_key=settings.OPENROUTER_API_KEY,
        default_headers={
            "HTTP-Referer": "https://edu-smart.app",
            "X-Title": "Edu Smart Assistant",
        },
    )
