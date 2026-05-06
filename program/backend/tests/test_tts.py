import pytest
from unittest.mock import patch, MagicMock


class TestGenerateSpeech:
    """Tests for TTS service."""

    @patch("app.services.tts_service.upload_to_firebase")
    @patch("app.services.tts_service.get_download_url")
    @patch("app.services.tts_service.speechsdk")
    def test_arabic_tts(self, mock_sdk, mock_get_url, mock_upload):
        """Test converting Arabic text to speech."""
        mock_get_url.return_value = None  # Not cached

        mock_result = MagicMock()
        mock_result.reason = mock_sdk.ResultReason.SynthesizingAudioCompleted
        mock_result.audio_data = b"fake_audio_data"

        mock_synthesizer = MagicMock()
        mock_synthesizer.speak_text_async.return_value.get.return_value = mock_result
        mock_sdk.SpeechSynthesizer.return_value = mock_synthesizer

        mock_upload.return_value = "https://storage.example.com/audio/abc123.mp3"

        from app.services.tts_service import generate_speech

        # Re-patch the module-level speech_config
        with patch("app.services.tts_service.speech_config", MagicMock()):
            result = generate_speech("بسم الله الرحمن الرحيم")

        assert result is not None
        assert "mp3" in result or "audio" in result

    @patch("app.services.tts_service.get_download_url")
    def test_empty_text_raises(self, mock_get_url):
        """Test that empty text raises ValueError."""
        from app.services.tts_service import generate_speech

        with pytest.raises(ValueError, match="النص مطلوب"):
            generate_speech("")

        with pytest.raises(ValueError, match="النص مطلوب"):
            generate_speech("   ")

    @patch("app.services.tts_service.upload_to_firebase")
    @patch("app.services.tts_service.get_download_url")
    def test_caching(self, mock_get_url, mock_upload):
        """Test that cached audio is returned without re-generating."""
        cached_url = "https://storage.example.com/audio/cached.mp3"
        mock_get_url.return_value = cached_url

        from app.services.tts_service import generate_speech

        result = generate_speech("نص تجريبي")
        assert result == cached_url
        mock_upload.assert_not_called()
