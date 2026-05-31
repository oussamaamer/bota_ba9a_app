import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final ApiClient _apiClient;

  AuthRepositoryImpl(this._remoteDatasource, this._apiClient);

  @override
  Future<Either<Failure, AuthResult>> login({
    required String email,
    required String password,
  }) async {
    try {
      final data = await _remoteDatasource.login(
        email: email,
        password: password,
      );

      final session = data['session'] as Map<String, dynamic>;
      final userJson = data['user'] as Map<String, dynamic>;

      final accessToken = session['access_token'] as String;
      final refreshToken = session['refresh_token'] as String?;

      // Save tokens
      await _apiClient.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      final user = User(
        id: userJson['id'] as String,
        email: userJson['email'] as String? ?? email,
        fullName: '', // Will be fetched from profile
      );

      return Right(AuthResult(
        user: user,
        accessToken: accessToken,
        refreshToken: refreshToken,
      ));
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erreur de connexion: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? role,
    String? businessName,
  }) async {
    try {
      final data = await _remoteDatasource.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        role: role,
        businessName: businessName,
      );

      final session = data['session'] as Map<String, dynamic>?;
      final userJson = data['user'] as Map<String, dynamic>;

      final accessToken = session?['access_token'] as String? ?? '';
      final refreshToken = session?['refresh_token'] as String?;

      if (accessToken.isNotEmpty) {
        await _apiClient.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }

      final user = User(
        id: userJson['id'] as String,
        email: userJson['email'] as String? ?? email,
        fullName: fullName,
        phone: phone,
        role: role ?? 'client',
        businessName: businessName,
      );

      return Right(AuthResult(
        user: user,
        accessToken: accessToken,
        refreshToken: refreshToken,
      ));
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erreur d\'inscription: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDatasource.logout();
      await _apiClient.clearTokens();
      return const Right(null);
    } catch (e) {
      await _apiClient.clearTokens();
      return const Right(null); // Always succeed locally
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await _remoteDatasource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Impossible de charger le profil'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _apiClient.hasToken();
  }
}
