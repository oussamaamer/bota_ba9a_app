import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/bottle_profile.dart';
import '../repositories/add_device_repository.dart';

class GetBottleProfilesUseCase {
  final AddDeviceRepository repository;

  const GetBottleProfilesUseCase(this.repository);

  Future<Either<Failure, List<BottleProfile>>> call() {
    return repository.getBottleProfiles();
  }
}
