import '../../domain/entities/device_summary.dart';

/// Device summary data model with JSON parsing
class DeviceSummaryModel extends DeviceSummary {
  const DeviceSummaryModel({
    required super.id,
    required super.name,
    super.location,
    required super.esp32Id,
    super.isActive,
    super.bottleProfileName,
    super.emptyWeightGrams,
    super.fullWeightGrams,
    super.currentWeightGrams,
    super.gasWeightGrams,
    super.gasLevelPct,
    super.status,
    super.consumptionRateGPerHour,
    super.consumptionRateGPerDay,
    super.estimatedHoursLeft,
    super.estimatedDaysLeft,
    super.lastReadingAt,
    super.lastSeenAt,
  });

  /// Create from combined device + stats API response
  factory DeviceSummaryModel.fromDeviceAndStats(
    Map<String, dynamic> device,
    Map<String, dynamic>? stats,
  ) {
    final bottleProfile = device['bottle_profile'] as Map<String, dynamic>?;
    final current = stats?['current'] as Map<String, dynamic>?;
    final consumption = stats?['consumption'] as Map<String, dynamic>?;

    return DeviceSummaryModel(
      id: device['id'] as String,
      name: device['name'] as String? ?? 'Appareil',
      location: device['location'] as String?,
      esp32Id: device['esp32_id'] as String,
      isActive: device['is_active'] as bool? ?? true,
      bottleProfileName: bottleProfile?['name'] as String?,
      emptyWeightGrams: bottleProfile?['empty_weight_grams'] as int?,
      fullWeightGrams: bottleProfile?['full_weight_grams'] as int?,
      currentWeightGrams: current?['weight_grams'] as int?,
      gasWeightGrams: current?['gas_weight_grams'] as int? ?? 0,
      gasLevelPct: (current?['gas_level_pct'] as num?)?.toDouble() ?? 0,
      status: current?['status'] as String? ?? 'empty',
      consumptionRateGPerHour:
          (consumption?['rate_g_per_hour'] as num?)?.toDouble() ?? 0,
      consumptionRateGPerDay:
          (consumption?['rate_g_per_day'] as num?)?.toDouble() ?? 0,
      estimatedHoursLeft:
          (consumption?['estimated_hours_left'] as num?)?.toDouble() ?? -1,
      estimatedDaysLeft:
          (consumption?['estimated_days_left'] as num?)?.toDouble() ?? -1,
      lastReadingAt: current?['last_reading_at'] != null
          ? DateTime.tryParse(current!['last_reading_at'] as String)
          : null,
      lastSeenAt: device['last_seen_at'] != null
          ? DateTime.tryParse(device['last_seen_at'] as String)
          : null,
    );
  }
}
