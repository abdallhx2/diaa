import pytest
from unittest.mock import patch, MagicMock
from uuid import uuid4


class TestVerifyFirebaseToken:
    """Tests for Firebase token verification."""

    @patch("app.services.auth_service.auth")
    def test_verify_valid_token(self, mock_auth):
        from app.services.auth_service import verify_firebase_token

        mock_auth.verify_id_token.return_value = {
            "uid": "test_uid_123",
            "email": "test@test.com",
            "name": "Test User",
        }

        result = verify_firebase_token("valid_token")
        assert result["uid"] == "test_uid_123"
        assert result["email"] == "test@test.com"
        mock_auth.verify_id_token.assert_called_once_with("valid_token")

    @patch("app.services.auth_service.auth")
    def test_verify_invalid_token(self, mock_auth):
        from app.services.auth_service import verify_firebase_token

        mock_auth.verify_id_token.side_effect = Exception("Token expired")

        with pytest.raises(Exception, match="فشل التحقق من التوكن"):
            verify_firebase_token("invalid_token")


class TestGetOrCreateUser:
    """Tests for get_or_create_user."""

    @patch("app.services.auth_service.Admin")
    @patch("app.services.auth_service.Student")
    @patch("app.services.auth_service.Parent")
    @patch("app.services.auth_service.User")
    def test_returns_existing_user(self, MockUser, MockParent, MockStudent, MockAdmin):
        from app.services.auth_service import get_or_create_user

        mock_db = MagicMock()
        existing_user = MagicMock()
        existing_user.id = uuid4()
        existing_user.firebase_uid = "existing_uid"
        mock_db.query.return_value.filter.return_value.first.return_value = existing_user

        result = get_or_create_user(mock_db, "existing_uid", "student", "طالب", "test@test.com")
        assert result == existing_user
        mock_db.add.assert_not_called()

    @patch("app.services.auth_service.Admin")
    @patch("app.services.auth_service.Student")
    @patch("app.services.auth_service.Parent")
    @patch("app.services.auth_service.User")
    def test_creates_new_student(self, MockUser, MockParent, MockStudent, MockAdmin):
        from app.services.auth_service import get_or_create_user

        mock_db = MagicMock()
        mock_db.query.return_value.filter.return_value.first.return_value = None
        mock_user_instance = MagicMock()
        mock_user_instance.id = uuid4()
        MockUser.return_value = mock_user_instance

        result = get_or_create_user(mock_db, "new_uid", "student", "طالب جديد", "new@test.com")
        assert mock_db.add.called
        assert mock_db.commit.called


class TestRegisterParent:
    """Tests for register_parent."""

    @patch("app.services.auth_service.Parent")
    @patch("app.services.auth_service.User")
    def test_register_parent_success(self, MockUser, MockParent):
        from app.services.auth_service import register_parent

        mock_db = MagicMock()
        mock_user_instance = MagicMock()
        mock_user_instance.id = uuid4()
        MockUser.return_value = mock_user_instance

        result = register_parent(
            mock_db,
            name="ولي أمر",
            email="parent@test.com",
            phone="0512345678",
            firebase_uid="parent_uid",
        )
        assert mock_db.add.called
        assert mock_db.commit.called
