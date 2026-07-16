import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Stream of the current user session state
  Stream<UserEntity?> get authStateChanges;

  /// Returns the current user if logged in, null otherwise
  UserEntity? get currentUser;

  /// Logs in a user using email and password
  Future<UserEntity> loginWithEmail(String email, String password);

  /// Registers a new user using email and password
  Future<UserEntity> registerWithEmail(
    String email,
    String password, {
    String? name,
  });

  /// Logs out the current user
  Future<void> logout();

  /// Checks if biometrics are available and enabled
  Future<bool> canUseBiometrics();

  /// Authenticates using local biometrics to unlock the session
  Future<bool> authenticateWithBiometrics();
}
