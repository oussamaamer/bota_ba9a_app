import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/add_device_repository.dart';

class CreateDeviceUseCase {
  final AddDeviceRepository repository;

  const CreateDeviceUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String esp32Id,
    required String name,
    String? location,
    String? bottleProfileId,
    int? emptyWeightGrams,
    int? fullWeightGrams,
    int alertThresholdPct = 15,
  }) {
    return repository.createDevice(
      esp32Id: esp32Id,
      name: name,
      location: location,
      bottleProfileId: bottleProfileId,
      emptyWeightGrams: emptyWeightGrams,
      fullWeightGrams: fullWeightGrams,
      alertThresholdPct: alertThresholdPct,
    );
  }
}
