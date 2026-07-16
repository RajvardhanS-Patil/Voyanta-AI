import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

abstract class AuthLocalDataSource {
  Future<bool> canUseBiometrics();
  Future<bool> authenticateWithBiometrics();
  Future<void> saveSecureToken(String key, String value);
  Future<String?> getSecureToken(String key);
  Future<void> deleteSecureToken(String key);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;

  AuthLocalDataSourceImpl(this._secureStorage, this._localAuth);

  @override
  Future<bool> canUseBiometrics() async {
    final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
    final canAuthenticate =
        canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
    return canAuthenticate;
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to unlock Voyanta AI',
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> saveSecureToken(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> getSecureToken(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> deleteSecureToken(String key) async {
    await _secureStorage.delete(key: key);
  }
}
