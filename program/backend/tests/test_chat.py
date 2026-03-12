import pytest
import re
from unittest.mock import patch, MagicMock
from app.services.chat_service import ask_question


LESSON_TEXT = "الشمس هي نجم كبير في مركز المجموعة الشمسية. تدور حولها الكواكب."


@patch('app.services.chat_service.client')
def test_valid_question(mock_client):
    mock_response = MagicMock()
    mock_response.text = "الشمس هي نجم كبير في مركز المجموعة الشمسية"
    mock_client.models.generate_content.return_value = mock_response

    answer = ask_question("ما هي الشمس؟", LESSON_TEXT)
    assert len(answer) > 0
    assert "نجم" in answer or "شمس" in answer


@patch('app.services.chat_service.client')
def test_off_topic_question(mock_client):
    mock_response = MagicMock()
    mock_response.text = "هذا السؤال خارج محتوى الدرس الحالي."
    mock_client.models.generate_content.return_value = mock_response

    answer = ask_question("ما هي عاصمة فرنسا؟", LESSON_TEXT)
    assert "خارج" in answer


def test_empty_question():
    with pytest.raises((ValueError, Exception)):
        ask_question("", LESSON_TEXT)


@patch('app.services.chat_service.client')
def test_response_language(mock_client):
    mock_response = MagicMock()
    mock_response.text = "الشمس هي نجم كبير يضيء الكواكب"
    mock_client.models.generate_content.return_value = mock_response

    answer = ask_question("ما هي الشمس؟", LESSON_TEXT)
    assert re.search(r'[\u0600-\u06FF]', answer) is not None