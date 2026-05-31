import 'package:equatable/equatable.dart';
import '../../domain/entities/bottle_profile.dart';

abstract class AddDeviceState extends Equatable {
  const AddDeviceState();

  @override
  List<Object?> get props => [];
}

class AddDeviceInitial extends AddDeviceState {
  const AddDeviceInitial();
}

class AddDeviceProfilesLoading extends AddDeviceState {
  const AddDeviceProfilesLoading();
}

/// Profiles loaded successfully — form is ready.
class AddDeviceReady extends AddDeviceState {
  final List<BottleProfile> profiles;

  const AddDeviceReady({required this.profiles});

  @override
  List<Object?> get props => [profiles];
}

class AddDeviceSubmitting extends AddDeviceState {
  final List<BottleProfile> profiles;

  const AddDeviceSubmitting({required this.profiles});

  @override
  List<Object?> get props => [profiles];
}

class AddDeviceSuccess extends AddDeviceState {
  final String deviceId;

  const AddDeviceSuccess({required this.deviceId});

  @override
  List<Object?> get props => [deviceId];
}

class AddDeviceError extends AddDeviceState {
  final String message;
  final List<BottleProfile> profiles;

  const AddDeviceError({required this.message, required this.profiles});

  @override
  List<Object?> get props => [message, profiles];
}
