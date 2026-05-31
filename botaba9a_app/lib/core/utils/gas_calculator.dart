/// Client-side gas calculation utilities.
/// Mirrors the backend StatsService logic for offline use.
class GasCalculator {
  GasCalculator._();

  /// Gas status classification
  static String classifyStatus(double pct) {
    if (pct >= 90) return 'full';
    if (pct >= 50) return 'good';
    if (pct >= 20) return 'attention';
    if (pct >= 10) return 'low';
    if (pct > 0) return 'critical';
    return 'empty';
  }

  /// Calculate gas level from raw weight and bottle profile.
  static GasLevelResult calculateGasLevel({
    required int weightGrams,
    required int emptyWeightGrams,
    required int fullWeightGrams,
  }) {
    final int tare = emptyWeightGrams;
    final int capacity = fullWeightGrams - emptyWeightGrams;

    if (capacity <= 0) {
      return GasLevelResult(gasWeightGrams: 0, gasLevelPct: 0, status: 'empty');
    }

    final int gasWeight = (weightGrams - tare).clamp(0, capacity);
    final double gasLevelPct = (gasWeight / capacity * 100).clamp(0, 100);

    return GasLevelResult(
      gasWeightGrams: gasWeight,
      gasLevelPct: double.parse(gasLevelPct.toStringAsFixed(1)),
      status: classifyStatus(gasLevelPct),
    );
  }

  /// Calculate consumption rate from readings.
  /// Readings should be sorted newest-first.
  static ConsumptionResult calculateConsumptionRate(
    List<WeightReading> readings,
  ) {
    if (readings.length < 2) {
      return ConsumptionResult(rateGPerHour: 0, rateGPerDay: 0);
    }

    final newest = readings.first;
    final oldest = readings.last;

    final timeDiffMs = newest.recordedAt.difference(oldest.recordedAt).inMilliseconds;
    final timeDiffHours = timeDiffMs / (1000 * 60 * 60);

    if (timeDiffHours <= 0) {
      return ConsumptionResult(rateGPerHour: 0, rateGPerDay: 0);
    }

    // Weight decreases over time (gas consumed)
    final weightDelta = oldest.weightGrams - newest.weightGrams;
    final rateGPerHour = (weightDelta / timeDiffHours).clamp(0, double.infinity);

    return ConsumptionResult(
      rateGPerHour: double.parse(rateGPerHour.toStringAsFixed(1)),
      rateGPerDay: double.parse((rateGPerHour * 24).toStringAsFixed(1)),
    );
  }

  /// Estimate remaining duration.
  static DurationEstimate estimateRemainingDuration({
    required int gasWeightGrams,
    required double rateGPerHour,
  }) {
    if (rateGPerHour <= 0 || gasWeightGrams <= 0) {
      return DurationEstimate(estimatedHoursLeft: -1, estimatedDaysLeft: -1);
    }

    final hoursLeft = gasWeightGrams / rateGPerHour;
    return DurationEstimate(
      estimatedHoursLeft: double.parse(hoursLeft.toStringAsFixed(1)),
      estimatedDaysLeft: double.parse((hoursLeft / 24).toStringAsFixed(1)),
    );
  }

  /// Format weight in grams to kg string (e.g., 8450 → "8.5 kg")
  static String formatWeightKg(int grams) {
    final kg = grams / 1000;
    return '${kg.toStringAsFixed(1)} kg';
  }

  /// Format hours to human-readable duration
  static String formatDuration(double hours) {
    if (hours < 0) return '--';
    if (hours < 1) return '${(hours * 60).round()} min';
    if (hours < 24) return '${hours.round()} h';
    final days = (hours / 24).round();
    return '$days j';
  }
}

/// Result of gas level calculation
class GasLevelResult {
  final int gasWeightGrams;
  final double gasLevelPct;
  final String status;

  const GasLevelResult({
    required this.gasWeightGrams,
    required this.gasLevelPct,
    required this.status,
  });
}

/// Result of consumption rate calculation
class ConsumptionResult {
  final double rateGPerHour;
  final double rateGPerDay;

  const ConsumptionResult({
    required this.rateGPerHour,
    required this.rateGPerDay,
  });
}

/// Result of duration estimation
class DurationEstimate {
  final double estimatedHoursLeft;
  final double estimatedDaysLeft;

  const DurationEstimate({
    required this.estimatedHoursLeft,
    required this.estimatedDaysLeft,
  });
}

/// Simple reading model for calculation purposes
class WeightReading {
  final int weightGrams;
  final DateTime recordedAt;

  const WeightReading({
    required this.weightGrams,
    required this.recordedAt,
  });
}
