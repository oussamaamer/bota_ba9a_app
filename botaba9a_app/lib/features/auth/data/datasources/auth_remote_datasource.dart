import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Remote datasource for authentication operations.
class AuthRemoteDatasource {
  final ApiClient _apiClient;

  AuthRemoteDatasource(this._apiClient);

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return data;
    } on Exception catch (e) {
      throw ServerException(message: 'Login failed: $e');
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? role,
    String? businessName,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'full_name': fullName,
          if (phone != null) 'phone': phone,
          if (role != null) 'role': role,
          if (businessName != null) 'business_name': businessName,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return data;
    } on Exception catch (e) {
      throw ServerException(message: 'Registration failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } on Exception catch (_) {
      // Silently handle logout errors — clear local state anyway
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.me);
      final data = response.data['data'] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } on Exception catch (e) {
      throw ServerException(message: 'Failed to get user profile: $e');
    }
  }
}
