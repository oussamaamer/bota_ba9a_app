import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/bottle_profile.dart';
import '../../domain/usecases/get_bottle_profiles_usecase.dart';
import '../../domain/usecases/create_device_usecase.dart';
import 'add_device_event.dart';
import 'add_device_state.dart';

class AddDeviceBloc extends Bloc<AddDeviceEvent, AddDeviceState> {
  final GetBottleProfilesUseCase _getBottleProfilesUseCase;
  final CreateDeviceUseCase _createDeviceUseCase;

  List<BottleProfile> _cachedProfiles = [];

  AddDeviceBloc({
    required GetBottleProfilesUseCase getBottleProfilesUseCase,
    required CreateDeviceUseCase createDeviceUseCase,
  })  : _getBottleProfilesUseCase = getBottleProfilesUseCase,
        _createDeviceUseCase = createDeviceUseCase,
        super(const AddDeviceInitial()) {
    on<AddDeviceLoadProfiles>(_onLoadProfiles);
    on<AddDeviceSubmitted>(_onSubmitted);
  }

  Future<void> _onLoadProfiles(
    AddDeviceLoadProfiles event,
    Emitter<AddDeviceState> emit,
  ) async {
    emit(const AddDeviceProfilesLoading());

    final result = await _getBottleProfilesUseCase();
    result.fold(
      (failure) {
        _cachedProfiles = [];
        emit(AddDeviceReady(profiles: _cachedProfiles));
      },
      (profiles) {
        _cachedProfiles = profiles;
        emit(AddDeviceReady(profiles: profiles));
      },
    );
  }

  Future<void> _onSubmitted(
    AddDeviceSubmitted event,
    Emitter<AddDeviceState> emit,
  ) async {
    emit(AddDeviceSubmitting(profiles: _cachedProfiles));

    final result = await _createDeviceUseCase(
      esp32Id: event.esp32Id,
      name: event.name,
      location: event.location,
      bottleProfileId: event.bottleProfileId,
      emptyWeightGrams: event.emptyWeightGrams,
      fullWeightGrams: event.fullWeightGrams,
      alertThresholdPct: event.alertThresholdPct,
    );

    result.fold(
      (failure) => emit(AddDeviceError(
        message: failure.message,
        profiles: _cachedProfiles,
      )),
      (deviceId) => emit(AddDeviceSuccess(deviceId: deviceId)),
    );
  }
}
