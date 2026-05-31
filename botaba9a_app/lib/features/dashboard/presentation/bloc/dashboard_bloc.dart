import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';
import '../../domain/usecases/submit_reading_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase _getDashboardUseCase;
  final SubmitReadingUseCase _submitReadingUseCase;

  DashboardBloc({
    required GetDashboardUseCase getDashboardUseCase,
    required SubmitReadingUseCase submitReadingUseCase,
  })  : _getDashboardUseCase = getDashboardUseCase,
        _submitReadingUseCase = submitReadingUseCase,
        super(const DashboardInitial()) {
    on<DashboardLoadRequested>(_onLoad);
    on<DashboardRefreshRequested>(_onRefresh);
    on<DashboardReadingSubmitted>(_onReadingSubmitted);
  }

  Future<void> _onLoad(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    final result = await _getDashboardUseCase();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (devices) => emit(DashboardLoaded(devices: devices)),
    );
  }

  Future<void> _onRefresh(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await _getDashboardUseCase();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (devices) => emit(DashboardLoaded(devices: devices)),
    );
  }

  Future<void> _onReadingSubmitted(
    DashboardReadingSubmitted event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await _submitReadingUseCase(
      deviceId: event.deviceId,
      weightGrams: event.weightGrams,
    );

    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (_) {
        emit(const DashboardReadingSuccess());
        add(const DashboardRefreshRequested());
      },
    );
  }
}
