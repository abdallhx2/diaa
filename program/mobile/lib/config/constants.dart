class AppConstants {
  AppConstants._();

  // معلومات التطبيق
  static const String appName = 'Diyaa';
  static const String appNameAr = 'ضياء';
  static const String appTagline = 'رفيق التعلم الذكي';

  // رابط الـ API
  // للمحاكي Android: http://10.0.2.2:8000/api
  // لجهاز حقيقي: http://YOUR_IP:8000/api
  // للإنتاج: https://your-app.railway.app/api
  static const String apiBaseUrl = 'http://178.105.109.153:8001/api';
  // Development — Chrome/Web testing
  static const String webBaseUrl = 'http://178.105.109.153:8001/api';

  // توكنات تجريبية للوضع التجريبي (Mock Mode)
  // يجب أن تكون ASCII فقط — المتصفح يرفض الأحرف العربية في HTTP headers
  static const String mockStudentToken = 'mock_student_demo';
  static const String mockParentToken = 'mock_parent_demo';

  // ثوابت الملفات
  static const int maxImageSizeMB = 10;
  static const int maxImageSizeBytes = 10 * 1024 * 1024;

  // ثوابت المحادثة
  static const int maxChatMessages = 20;

  // ثوابت الاختبارات
  static const int quizQuestionsPerSession = 5;

  // ثوابت التصميم
  static const double minButtonSize = 48.0;
  static const double iconSizeLarge = 64.0;
  static const double borderRadius = 18.0;
  static const double cardBorderRadius = 18.0;
  static const double borderRadiusSm = 12.0;

  // ثوابت الـ Timeout
  static const int apiTimeoutSeconds = 30;

  // مسارات Firebase Storage
  static const String storageImagesPath = 'images/';
  static const String storageAudioPath = 'audio/';

  // الصفوف الدراسية المدعومة
  static const List<String> supportedGrades = [
    'الأول',
    'الثاني',
    'الثالث',
    'الرابع',
    'الخامس',
    'السادس',
  ];
}
