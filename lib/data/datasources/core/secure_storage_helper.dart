import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static final SecureStorageHelper instance = SecureStorageHelper._init();
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    mOptions: MacOsOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      synchronizable: false,
    ),
  );

  SecureStorageHelper._init();

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteAuthToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}

