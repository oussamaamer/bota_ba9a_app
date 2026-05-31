import 'package:equatable/equatable.dart';

/// Domain entity representing a bottle profile option.
class BottleProfile extends Equatable {
  final String id;
  final String name;
  final int emptyWeightGrams;
  final int fullWeightGrams;
  final int alertThresholdPct;
  final bool isPublic;

  const BottleProfile({
    required this.id,
    required this.name,
    required this.emptyWeightGrams,
    required this.fullWeightGrams,
    this.alertThresholdPct = 15,
    this.isPublic = false,
  });

  /// Capacity in grams = full - empty
  int get capacityGrams => fullWeightGrams - emptyWeightGrams;

  /// Formatted capacity in kg
  String get capacityLabel => '${(capacityGrams / 1000).toStringAsFixed(1)} kg';

  @override
  List<Object?> get props => [id, name, emptyWeightGrams, fullWeightGrams];
}
