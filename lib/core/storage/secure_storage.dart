import 'package:fintrack_mobile/core/constants/storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


/// Secure Storage Service
/// Uses FlutterSecureStorage to encrypt sensitive data (JWT tokens)
class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;
  SecureStorage._internal();

  final _storage = const FlutterSecureStorage(
  );

  /// Save JWT token
  Future<void> saveToken(String token) async {
    await _storage.write(key: StorageKeys.accessToken, value: token);
  }

  /// Get JWT token
  Future<String?> getToken() async {
    return await _storage.read(key: StorageKeys.accessToken);
  }

  /// Delete JWT token
  Future<void> deleteToken() async {
    await _storage.delete(key: StorageKeys.accessToken);
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}