import 'package:get_it/get_it.dart';
import '../network/api_client.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Dashboard
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import '../../features/dashboard/domain/usecases/submit_reading_usecase.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

// Add Device
import '../../features/add_device/data/datasources/add_device_remote_datasource.dart';
import '../../features/add_device/data/repositories/add_device_repository_impl.dart';
import '../../features/add_device/domain/repositories/add_device_repository.dart';
import '../../features/add_device/domain/usecases/get_bottle_profiles_usecase.dart';
import '../../features/add_device/domain/usecases/create_device_usecase.dart';
import '../../features/add_device/presentation/bloc/add_device_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Core ──────────────────────────────────────────────────
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ── Auth Feature ──────────────────────────────────────────
  // Datasources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // BLoC
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
        authRepository: sl(),
      ));

  // ── Dashboard Feature ─────────────────────────────────────
  // Datasources
  sl.registerLazySingleton<DashboardRemoteDatasource>(
    () => DashboardRemoteDatasource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDashboardUseCase(sl()));
  sl.registerLazySingleton(() => SubmitReadingUseCase(sl()));

  // BLoC
  sl.registerFactory(() => DashboardBloc(
        getDashboardUseCase: sl(),
        submitReadingUseCase: sl(),
      ));

  // ── Add Device Feature ────────────────────────────────────
  // Datasources
  sl.registerLazySingleton<AddDeviceRemoteDatasource>(
    () => AddDeviceRemoteDatasource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AddDeviceRepository>(
    () => AddDeviceRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetBottleProfilesUseCase(sl()));
  sl.registerLazySingleton(() => CreateDeviceUseCase(sl()));

  // BLoC
  sl.registerFactory(() => AddDeviceBloc(
        getBottleProfilesUseCase: sl(),
        createDeviceUseCase: sl(),
      ));
}

