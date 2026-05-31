/// API endpoint constants
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // Devices
  static const String devices = '/devices';
  static String device(String id) => '/devices/$id';
  static String deviceReadings(String id) => '/devices/$id/readings';
  static String deviceStats(String id) => '/devices/$id/stats';

  // Bottle Profiles
  static const String bottleProfiles = '/bottle-profiles';

  // Alerts
  static const String alerts = '/alerts';
  static String deviceAlerts(String id) => '/devices/$id/alerts';
}
