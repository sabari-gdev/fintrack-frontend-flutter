import 'package:dio/dio.dart';
import 'package:fintrack_mobile/core/constants/api_constants.dart';
import 'package:fintrack_mobile/core/network/api_client.dart';
import 'package:fintrack_mobile/core/storage/secure_storage.dart';


import 'package:fintrack_mobile/features/auth/data/models/login_request.dart';
import 'package:fintrack_mobile/features/auth/data/models/login_response.dart';
import 'package:fintrack_mobile/features/auth/data/models/user_model.dart';
import 'package:fintrack_mobile/shared/models/api_response.dart';


/// Auth Remote Data Source
/// Handles all authentication API calls
class AuthRemoteDataSource {
  final ApiClient _apiClient = ApiClient();
  final SecureStorage _storage = SecureStorage();

  /// Login
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
            (data) => LoginResponse.fromJson(data as Map<String, dynamic>),
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      // Save token
      await _storage.saveToken(apiResponse.data!.token);

      return apiResponse.data!;
    } on DioException catch (e) {
      if (e.response != null) {
        final apiResponse = ApiResponse.fromJson(e.response!.data, null);
        throw Exception(apiResponse.message);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Get current user
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.me);

      final apiResponse = ApiResponse.fromJson(
        response.data,
            (data) => UserModel.fromJson(data as Map<String, dynamic>),
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      if (e.response != null) {
        final apiResponse = ApiResponse.fromJson(e.response!.data, null);
        throw Exception(apiResponse.message);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    await _storage.clearAll();
  }
}