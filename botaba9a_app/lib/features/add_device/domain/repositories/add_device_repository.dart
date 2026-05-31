import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/bottle_profile.dart';

/// Contract for the add-device feature repository.
abstract class AddDeviceRepository {
  /// Fetch available bottle profiles (public + user's custom).
  Future<Either<Failure, List<BottleProfile>>> getBottleProfiles();

  /// Create a new device with optional custom bottle profile.
  /// If [bottleProfileId] is null but [emptyWeightGrams] and [fullWeightGrams]
  /// are provided, a custom bottle profile is created first.
  Future<Either<Failure, String>> createDevice({
    required String esp32Id,
    required String name,
    String? location,
    String? bottleProfileId,
    int? emptyWeightGrams,
    int? fullWeightGrams,
    int alertThresholdPct = 15,
  });
}
