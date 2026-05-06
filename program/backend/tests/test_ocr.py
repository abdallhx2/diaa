import pytest
from unittest.mock import patch, MagicMock
from PIL import Image
import io


def _create_test_image(width=400, height=200, color="white"):
    """Helper to create a simple test image as bytes."""
    image = Image.new("RGB", (width, height), color)
    buffer = io.BytesIO()
    image.save(buffer, format="PNG")
    return buffer.getvalue()


class TestExtractText:
    """Tests for OCR text extraction."""

    @patch("app.services.ocr_service.get_reader")
    def test_arabic_text_extraction(self, mock_get_reader):
        from app.services.ocr_service import extract_text_from_image

        mock_reader = MagicMock()
        mock_reader.readtext.return_value = [
            ([[0, 0], [100, 0], [100, 30], [0, 30]], "بسم الله", 0.95),
            ([[0, 40], [100, 40], [100, 70], [0, 70]], "الرحمن الرحيم", 0.90),
        ]
        mock_get_reader.return_value = mock_reader

        image_bytes = _create_test_image()
        result = extract_text_from_image(image_bytes)

        assert len(result) > 0
        assert "بسم الله" in result
        assert "الرحمن الرحيم" in result

    @patch("app.services.ocr_service.get_reader")
    def test_empty_image(self, mock_get_reader):
        from app.services.ocr_service import extract_text_from_image

        mock_reader = MagicMock()
        mock_reader.readtext.return_value = []
        mock_get_reader.return_value = mock_reader

        image_bytes = _create_test_image()
        result = extract_text_from_image(image_bytes)
        assert result == ""

    def test_invalid_image(self):
        from app.services.ocr_service import extract_text_from_image

        with pytest.raises(Exception):
            extract_text_from_image(b"this is not an image")

    @patch("app.services.ocr_service.get_reader")
    def test_large_image_resized(self, mock_get_reader):
        from app.services.ocr_service import extract_text_from_image

        mock_reader = MagicMock()
        mock_reader.readtext.return_value = [
            ([[0, 0], [100, 0], [100, 30], [0, 30]], "نص", 0.9),
        ]
        mock_get_reader.return_value = mock_reader

        image_bytes = _create_test_image(width=5000, height=5000)
        result = extract_text_from_image(image_bytes)
        assert isinstance(result, str)


class TestImageProcessing:
    """Tests for image preprocessing utilities."""

    def test_enhance_contrast(self):
        from app.utils.image_processing import enhance_contrast

        image = Image.new("L", (100, 100), 128)
        result = enhance_contrast(image)
        assert result.size == (100, 100)

    def test_remove_noise(self):
        from app.utils.image_processing import remove_noise

        image = Image.new("L", (100, 100), 128)
        result = remove_noise(image)
        assert result.size == (100, 100)

    def test_convert_to_grayscale(self):
        from app.utils.image_processing import convert_to_grayscale

        image = Image.new("RGB", (100, 100), "red")
        result = convert_to_grayscale(image)
        assert result.mode == "L"

    def test_resize_if_needed_large(self):
        from app.utils.image_processing import resize_if_needed

        image = Image.new("RGB", (4000, 3000))
        result = resize_if_needed(image, max_size=2000)
        assert max(result.size) <= 2000

    def test_resize_if_needed_small(self):
        from app.utils.image_processing import resize_if_needed

        image = Image.new("RGB", (500, 300))
        result = resize_if_needed(image, max_size=2000)
        assert result.size == (500, 300)
