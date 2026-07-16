import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Stream<UserEntity?> get authStateChanges =>
      _remoteDataSource.authStateChanges;

  @override
  UserEntity? get currentUser => _remoteDataSource.currentUser;

  @override
  Future<UserEntity> loginWithEmail(String email, String password) async {
    final user = await _remoteDataSource.loginWithEmail(email, password);
    // Optionally trigger secure vault operations here after successful login
    return user;
  }

  @override
  Future<UserEntity> registerWithEmail(
    String email,
    String password, {
    String? name,
  }) async {
    return await _remoteDataSource.registerWithEmail(
      email,
      password,
      name: name,
    );
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    // Clear secure vault data on logout
  }

  @override
  Future<bool> canUseBiometrics() async {
    return await _localDataSource.canUseBiometrics();
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    return await _localDataSource.authenticateWithBiometrics();
  }
}
