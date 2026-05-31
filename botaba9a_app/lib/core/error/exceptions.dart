/// Custom exception types for data layer error handling.

class ServerException implements Exception {
  final String message;
  final String code;
  final int statusCode;

  const ServerException({
    required this.message,
    this.code = 'SERVER_ERROR',
    this.statusCode = 500,
  });

  @override
  String toString() => 'ServerException($code): $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'No internet connection'});

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Cache operation failed'});

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  final String message;

  const AuthException({this.message = 'Authentication failed'});

  @override
  String toString() => 'AuthException: $message';
}
