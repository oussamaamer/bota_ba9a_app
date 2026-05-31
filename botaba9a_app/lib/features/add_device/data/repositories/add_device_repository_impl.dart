import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/bottle_profile.dart';
import '../../domain/repositories/add_device_repository.dart';
import '../datasources/add_device_remote_datasource.dart';

class AddDeviceRepositoryImpl implements AddDeviceRepository {
  final AddDeviceRemoteDatasource _remoteDatasource;

  AddDeviceRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<BottleProfile>>> getBottleProfiles() async {
    try {
      final profiles = await _remoteDatasource.getBottleProfiles();
      return Right(profiles);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erreur de chargement des profils'));
    }
  }

  @override
  Future<Either<Failure, String>> createDevice({
    required String esp32Id,
    required String name,
    String? location,
    String? bottleProfileId,
    int? emptyWeightGrams,
    int? fullWeightGrams,
    int alertThresholdPct = 15,
  }) async {
    try {
      // If using a standard profile, just pass the ID.
      // Custom profile creation will be handled in a later phase.
      final deviceId = await _remoteDatasource.createDevice(
        esp32Id: esp32Id,
        name: name,
        location: location,
        bottleProfileId: bottleProfileId,
      );
      return Right(deviceId);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Impossible de créer l\'appareil'));
    }
  }
}
