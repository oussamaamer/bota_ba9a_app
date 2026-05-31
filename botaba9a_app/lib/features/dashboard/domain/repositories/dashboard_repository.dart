import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/device_summary.dart';

/// Abstract dashboard repository
abstract class DashboardRepository {
  Future<Either<Failure, List<DeviceSummary>>> getDeviceSummaries();

  Future<Either<Failure, DeviceSummary>> getDeviceStats(String deviceId);

  Future<Either<Failure, void>> submitReading({
    required String deviceId,
    required int weightGrams,
    String source = 'manual',
  });
}
