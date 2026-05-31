import 'package:equatable/equatable.dart';

abstract class AddDeviceEvent extends Equatable {
  const AddDeviceEvent();

  @override
  List<Object?> get props => [];
}

/// Load available bottle profiles when the page opens.
class AddDeviceLoadProfiles extends AddDeviceEvent {
  const AddDeviceLoadProfiles();
}

/// Submit the device creation form.
class AddDeviceSubmitted extends AddDeviceEvent {
  final String name;
  final String esp32Id;
  final String? location;
  final String? bottleProfileId;
  final int? emptyWeightGrams;
  final int? fullWeightGrams;
  final int alertThresholdPct;

  const AddDeviceSubmitted({
    required this.name,
    required this.esp32Id,
    this.location,
    this.bottleProfileId,
    this.emptyWeightGrams,
    this.fullWeightGrams,
    this.alertThresholdPct = 15,
  });

  @override
  List<Object?> get props => [
        name,
        esp32Id,
        location,
        bottleProfileId,
        emptyWeightGrams,
        fullWeightGrams,
        alertThresholdPct,
      ];
}
