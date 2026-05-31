import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/device_summary.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardUseCase {
  final DashboardRepository repository;

  const GetDashboardUseCase(this.repository);

  Future<Either<Failure, List<DeviceSummary>>> call() {
    return repository.getDeviceSummaries();
  }
}
