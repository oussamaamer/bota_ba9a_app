import 'package:equatable/equatable.dart';

/// Dashboard device summary entity
class DeviceSummary extends Equatable {
  final String id;
  final String name;
  final String? location;
  final String esp32Id;
  final bool isActive;

  // Bottle profile
  final String? bottleProfileName;
  final int? emptyWeightGrams;
  final int? fullWeightGrams;

  // Computed values
  final int? currentWeightGrams;
  final int gasWeightGrams;
  final double gasLevelPct;
  final String status; // full, good, attention, low, critical, empty
  final double consumptionRateGPerHour;
  final double consumptionRateGPerDay;
  final double estimatedHoursLeft;
  final double estimatedDaysLeft;
  final DateTime? lastReadingAt;
  final DateTime? lastSeenAt;

  const DeviceSummary({
    required this.id,
    required this.name,
    this.location,
    required this.esp32Id,
    this.isActive = true,
    this.bottleProfileName,
    this.emptyWeightGrams,
    this.fullWeightGrams,
    this.currentWeightGrams,
    this.gasWeightGrams = 0,
    this.gasLevelPct = 0,
    this.status = 'empty',
    this.consumptionRateGPerHour = 0,
    this.consumptionRateGPerDay = 0,
    this.estimatedHoursLeft = -1,
    this.estimatedDaysLeft = -1,
    this.lastReadingAt,
    this.lastSeenAt,
  });

  @override
  List<Object?> get props => [id, gasLevelPct, status, lastReadingAt];
}
