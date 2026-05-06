from PIL import Image, ImageEnhance, ImageFilter
import numpy as np


def enhance_contrast(image: Image.Image) -> Image.Image:
    """Enhance image contrast for better OCR accuracy."""
    enhancer = ImageEnhance.Contrast(image)
    enhanced = enhancer.enhance(1.5)
    return enhanced


def remove_noise(image: Image.Image) -> Image.Image:
    """Remove noise from image using median filter."""
    cleaned = image.filter(ImageFilter.MedianFilter(size=3))
    return cleaned


def convert_to_grayscale(image: Image.Image) -> Image.Image:
    """Convert image to grayscale for improved OCR."""
    gray = image.convert("L")
    return gray


def resize_if_needed(image: Image.Image, max_size: int = 2000) -> Image.Image:
    """Resize image if any dimension exceeds max_size, preserving aspect ratio."""
    width, height = image.size
    if max(width, height) > max_size:
        ratio = max_size / max(width, height)
        new_size = (int(width * ratio), int(height * ratio))
        resized = image.resize(new_size, Image.LANCZOS)
        return resized
    return image


def preprocess_image(image: Image.Image) -> Image.Image:
    """Full preprocessing pipeline: grayscale -> contrast -> noise removal -> resize."""
    image = convert_to_grayscale(image)
    image = enhance_contrast(image)
    image = remove_noise(image)
    image = resize_if_needed(image, 2000)
    return image
