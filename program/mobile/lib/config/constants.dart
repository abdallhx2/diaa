class AppConstants {
  static const String appName   = 'Edu Smart Assistant';
  static const String appNameAr = 'المساعد التعليمي الذكي';
 
  static const String apiBaseUrl        = 'http://10.0.2.2:8000/api';
  static const int    apiTimeoutSeconds = 30;
 
  static const int imageMaxSizeMB    = 10;
  static const int imageMaxSizeBytes = 10 * 1024 * 1024;
 
  static const int maxChatMessages       = 20;
  static const int quizQuestionsPerSession = 5;
 
  static const double minButtonSize    = 48.0;
  static const double iconSizeLarge    = 64.0;
  static const double borderRadius     = 12.0;
  static const double cardBorderRadius = 16.0;
 
  static const String storageImagesPath = 'images/';
  static const String storageAudioPath  = 'audio/';
}
 