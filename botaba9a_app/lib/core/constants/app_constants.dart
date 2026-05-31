/// BOTABA9A App Constants
class AppConstants {
  AppConstants._();

  static const String appName = 'BOTABA9A';
  static const String appVersion = '1.0.0';

  // API Configuration — update with your backend URL
  static const String baseUrl = 'http://127.0.0.1:3001';
  static const String baseUrlIos = 'http://127.0.0.1:3001';

  // Supabase — update with your project credentials
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key';

  // Storage keys
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'current_user';

  // Gas calculation defaults
  static const int defaultAlertThresholdPct = 15;
  static const int signalLostMinutes = 10;

  // Sync settings
  static const int syncBatchSize = 50;
  static const int maxRetryAttempts = 5;
}
