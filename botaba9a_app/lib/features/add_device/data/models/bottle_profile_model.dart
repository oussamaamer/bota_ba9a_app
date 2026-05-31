import '../../domain/entities/bottle_profile.dart';

/// BottleProfile data model with JSON serialization.
class BottleProfileModel extends BottleProfile {
  const BottleProfileModel({
    required super.id,
    required super.name,
    required super.emptyWeightGrams,
    required super.fullWeightGrams,
    super.alertThresholdPct,
    super.isPublic,
  });

  factory BottleProfileModel.fromJson(Map<String, dynamic> json) {
    return BottleProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      emptyWeightGrams: json['empty_weight_grams'] as int,
      fullWeightGrams: json['full_weight_grams'] as int,
      alertThresholdPct: json['alert_threshold_pct'] as int? ?? 15,
      isPublic: json['is_public'] as bool? ?? false,
    );
  }
}
