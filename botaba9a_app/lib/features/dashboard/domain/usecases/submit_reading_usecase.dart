import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/dashboard_repository.dart';

class SubmitReadingUseCase {
  final DashboardRepository repository;

  const SubmitReadingUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String deviceId,
    required int weightGrams,
    String source = 'manual',
  }) {
    return repository.submitReading(
      deviceId: deviceId,
      weightGrams: weightGrams,
      source: source,
    );
  }
}
