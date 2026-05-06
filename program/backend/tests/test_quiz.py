import pytest
from unittest.mock import patch, MagicMock
from uuid import uuid4
from datetime import datetime, timezone


class TestGetQuizzesByLesson:
    """Tests for getting quizzes by lesson."""

    def test_returns_list(self):
        from app.services.quiz_service import get_quizzes_by_lesson

        mock_db = MagicMock()
        mock_quiz = MagicMock()
        mock_quiz.id = uuid4()
        mock_quiz.lesson_id = uuid4()
        mock_quiz.quiz_type = MagicMock()
        mock_quiz.quiz_type.value = "reading"
        mock_quiz.question_text = "ما معنى الكلمة؟"
        mock_quiz.options = ["خيار 1", "خيار 2", "خيار 3"]
        mock_quiz.created_at = datetime.now(timezone.utc)

        mock_db.query.return_value.filter.return_value.all.return_value = [mock_quiz]

        result = get_quizzes_by_lesson(mock_db, uuid4())
        assert isinstance(result, list)
        assert len(result) == 1
        assert "question_text" in result[0]
        assert "options" in result[0]
        # Ensure correct_answer is NOT exposed
        assert "correct_answer" not in result[0]


class TestSubmitAnswer:
    """Tests for submitting quiz answers."""

    def test_correct_answer(self):
        from app.services.quiz_service import submit_answer

        mock_db = MagicMock()
        mock_quiz = MagicMock()
        mock_quiz.id = uuid4()
        mock_quiz.correct_answer = "الخيار الأول"
        mock_db.query.return_value.filter.return_value.first.return_value = mock_quiz

        mock_result = MagicMock()
        mock_result.id = uuid4()
        mock_result.quiz_id = mock_quiz.id
        mock_result.selected_answer = "الخيار الأول"
        mock_result.is_correct = True
        mock_result.answered_at = datetime.now(timezone.utc)

        result = submit_answer(mock_db, student_id=uuid4(), quiz_id=mock_quiz.id, selected_answer="الخيار الأول")
        assert result["is_correct"] == True
        assert mock_db.add.called
        assert mock_db.commit.called

    def test_wrong_answer(self):
        from app.services.quiz_service import submit_answer

        mock_db = MagicMock()
        mock_quiz = MagicMock()
        mock_quiz.id = uuid4()
        mock_quiz.correct_answer = "الخيار الأول"
        mock_db.query.return_value.filter.return_value.first.return_value = mock_quiz

        result = submit_answer(mock_db, student_id=uuid4(), quiz_id=mock_quiz.id, selected_answer="الخيار الثاني")
        assert result["is_correct"] == False

    def test_quiz_not_found(self):
        from app.services.quiz_service import submit_answer

        mock_db = MagicMock()
        mock_db.query.return_value.filter.return_value.first.return_value = None

        with pytest.raises(Exception, match="الاختبار غير موجود"):
            submit_answer(mock_db, student_id=uuid4(), quiz_id=uuid4(), selected_answer="أي شيء")


class TestGetStudentResults:
    """Tests for getting student quiz results."""

    def test_returns_list(self):
        from app.services.quiz_service import get_student_results

        mock_db = MagicMock()
        mock_result = MagicMock()
        mock_result.id = uuid4()
        mock_result.quiz_id = uuid4()
        mock_result.selected_answer = "خيار"
        mock_result.is_correct = True
        mock_result.answered_at = datetime.now(timezone.utc)

        mock_db.query.return_value.filter.return_value.order_by.return_value.all.return_value = [mock_result]

        results = get_student_results(mock_db, uuid4())
        assert isinstance(results, list)
        assert len(results) == 1
        assert "is_correct" in results[0]
