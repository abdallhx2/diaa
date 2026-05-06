import pytest
from unittest.mock import patch, MagicMock
from uuid import uuid4


class TestAskQuestion:
    """Tests for AI chat service."""

    @patch("app.services.chat_service.client")
    def test_valid_question(self, mock_client):
        """Test asking a valid question about lesson content."""
        from app.services.chat_service import ask_question

        mock_response = MagicMock()
        mock_response.choices = [MagicMock()]
        mock_response.choices[0].message.content = "الشمس هي نجم كبير في مركز المجموعة الشمسية"
        mock_client.chat.completions.create.return_value = mock_response

        mock_db = MagicMock()
        mock_lesson = MagicMock()
        mock_lesson.original_text = "الشمس هي نجم كبير في مركز المجموعة الشمسية. تدور حولها الكواكب."
        mock_db.query.return_value.filter.return_value.first.return_value = mock_lesson

        student_id = uuid4()
        lesson_id = uuid4()

        answer = ask_question(
            db=mock_db,
            question="ما هي الشمس؟",
            student_id=student_id,
            lesson_id=lesson_id,
        )

        assert len(answer) > 0
        assert "نجم" in answer or "شمس" in answer

    @patch("app.services.chat_service.client")
    def test_off_topic_question(self, mock_client):
        """Test that off-topic questions are handled."""
        from app.services.chat_service import ask_question

        mock_response = MagicMock()
        mock_response.choices = [MagicMock()]
        mock_response.choices[0].message.content = "هذا السؤال خارج محتوى الدرس الحالي."
        mock_client.chat.completions.create.return_value = mock_response

        mock_db = MagicMock()
        mock_lesson = MagicMock()
        mock_lesson.original_text = "الشمس هي نجم كبير."
        mock_db.query.return_value.filter.return_value.first.return_value = mock_lesson

        student_id = uuid4()
        lesson_id = uuid4()

        answer = ask_question(
            db=mock_db,
            question="ما هي عاصمة فرنسا؟",
            student_id=student_id,
            lesson_id=lesson_id,
        )

        assert "خارج" in answer

    def test_empty_question(self):
        """Test that empty question raises ValueError."""
        from app.services.chat_service import ask_question

        mock_db = MagicMock()

        with pytest.raises(ValueError, match="السؤال مطلوب"):
            ask_question(db=mock_db, question="", student_id=uuid4(), lesson_id=uuid4())

    @patch("app.services.chat_service.client")
    def test_response_is_arabic(self, mock_client):
        """Test that the response contains Arabic characters."""
        import re
        from app.services.chat_service import ask_question

        mock_response = MagicMock()
        mock_response.choices = [MagicMock()]
        mock_response.choices[0].message.content = "الشمس نجم كبير ومهم جداً"
        mock_client.chat.completions.create.return_value = mock_response

        mock_db = MagicMock()
        mock_lesson = MagicMock()
        mock_lesson.original_text = "الشمس نجم كبير."
        mock_db.query.return_value.filter.return_value.first.return_value = mock_lesson

        answer = ask_question(
            db=mock_db,
            question="أخبرني عن الشمس",
            student_id=uuid4(),
            lesson_id=uuid4(),
        )

        assert re.search(r"[\u0600-\u06FF]", answer) is not None
