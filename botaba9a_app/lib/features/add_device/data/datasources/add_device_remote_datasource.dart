import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../models/bottle_profile_model.dart';

/// Remote datasource for add-device operations.
class AddDeviceRemoteDatasource {
  final ApiClient _apiClient;

  AddDeviceRemoteDatasource(this._apiClient);

  /// Fetch available bottle profiles.
  Future<List<BottleProfileModel>> getBottleProfiles() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.bottleProfiles);
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((json) => BottleProfileModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Impossible de charger les profils de bouteille: $e');
    }
  }

  /// Create a new device on the backend.
  /// Returns the new device ID.
  Future<String> createDevice({
    required String esp32Id,
    String? name,
    String? location,
    String? bottleProfileId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.devices,
        data: {
          'esp32_id': esp32Id,
          if (name != null) 'name': name,
          if (location != null) 'location': location,
          if (bottleProfileId != null) 'bottle_profile_id': bottleProfileId,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return data['id'] as String;
    } catch (e) {
      throw ServerException(message: 'Impossible de créer l\'appareil: $e');
    }
  }

  /// Create a custom bottle profile and return its ID.
  Future<String> createBottleProfile({
    required String name,
    required int emptyWeightGrams,
    required int fullWeightGrams,
    int alertThresholdPct = 15,
  }) async {
    try {
      // The backend doesn't have a direct POST /bottle-profiles endpoint yet,
      // so we use the Supabase client via a workaround.
      // For Phase 1, we'll use a special endpoint or handle in the backend.
      // For now, create through devices endpoint which accepts bottle_profile_id.
      throw const ServerException(
        message: 'Custom bottle profile creation not yet supported. Please select a standard profile.',
      );
    } catch (e) {
      rethrow;
    }
  }
}
