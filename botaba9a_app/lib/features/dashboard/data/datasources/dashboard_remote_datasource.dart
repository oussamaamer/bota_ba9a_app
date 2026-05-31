import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';

/// Remote datasource for dashboard data.
class DashboardRemoteDatasource {
  final ApiClient _apiClient;

  DashboardRemoteDatasource(this._apiClient);

  /// Fetch all devices for the current user.
  Future<List<Map<String, dynamic>>> getDevices() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.devices);
      final data = response.data['data'] as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      throw ServerException(message: 'Failed to fetch devices: $e');
    }
  }

  /// Fetch stats for a specific device.
  Future<Map<String, dynamic>> getDeviceStats(String deviceId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.deviceStats(deviceId));
      return response.data['data'] as Map<String, dynamic>;
    } catch (e) {
      throw ServerException(message: 'Failed to fetch device stats: $e');
    }
  }

  /// Submit a weight reading for a device.
  Future<void> submitReading({
    required String deviceId,
    required int weightGrams,
    String source = 'manual',
  }) async {
    try {
      await _apiClient.post(
        ApiEndpoints.deviceReadings(deviceId),
        data: {
          'weight_grams': weightGrams,
          'source': source,
        },
      );
    } catch (e) {
      throw ServerException(message: 'Failed to submit reading: $e');
    }
  }
}
