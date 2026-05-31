import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/device_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/device_summary_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource _remoteDatasource;

  DashboardRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<DeviceSummary>>> getDeviceSummaries() async {
    try {
      final devices = await _remoteDatasource.getDevices();
      final summaries = <DeviceSummary>[];

      for (final device in devices) {
        Map<String, dynamic>? stats;
        try {
          stats = await _remoteDatasource.getDeviceStats(device['id'] as String);
        } catch (_) {
          // Stats may fail if no bottle profile configured — that's OK
        }
        summaries.add(DeviceSummaryModel.fromDeviceAndStats(device, stats));
      }

      // Sort by urgency: critical/low first, then by gas level
      summaries.sort((a, b) {
        final priority = _statusPriority(a.status).compareTo(_statusPriority(b.status));
        if (priority != 0) return priority;
        return a.gasLevelPct.compareTo(b.gasLevelPct);
      });

      return Right(summaries);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Impossible de charger le tableau de bord'));
    }
  }

  @override
  Future<Either<Failure, DeviceSummary>> getDeviceStats(String deviceId) async {
    try {
      final devices = await _remoteDatasource.getDevices();
      final device = devices.firstWhere(
        (d) => d['id'] == deviceId,
        orElse: () => throw const ServerException(message: 'Device not found'),
      );
      final stats = await _remoteDatasource.getDeviceStats(deviceId);
      return Right(DeviceSummaryModel.fromDeviceAndStats(device, stats));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erreur de chargement'));
    }
  }

  @override
  Future<Either<Failure, void>> submitReading({
    required String deviceId,
    required int weightGrams,
    String source = 'manual',
  }) async {
    try {
      await _remoteDatasource.submitReading(
        deviceId: deviceId,
        weightGrams: weightGrams,
        source: source,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erreur lors de l\'envoi'));
    }
  }

  int _statusPriority(String status) {
    switch (status) {
      case 'critical': return 0;
      case 'empty': return 1;
      case 'low': return 2;
      case 'attention': return 3;
      case 'good': return 4;
      case 'full': return 5;
      default: return 6;
    }
  }
}
