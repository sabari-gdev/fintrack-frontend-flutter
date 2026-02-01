import 'package:dio/dio.dart';
import 'package:fintrack_mobile/core/constants/api_constants.dart';
import 'package:fintrack_mobile/core/storage/secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// API Client using Dio
/// Handles all HTTP requests with automatic JWT token injection
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;
  final _storage = SecureStorage();

  Dio get dio => _dio;

  /// Initialize Dio with base configuration
  Future<void> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': ApiConstants.contentType,
        },
      ),
    );

    // Add JWT interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add token to every request (except login/register)
          if (!options.path.contains(ApiConstants.login) &&
              !options.path.contains(ApiConstants.register)) {
            final token = await _storage.getToken();



            if (token != null) {
              options.headers[ApiConstants.authorization] =
              '${ApiConstants.bearer} $token';
            }
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized - token expired
          if (error.response?.statusCode == 401) {
            await _storage.clearAll();
          }
          return handler.next(error);
        },
      ),
    );

    // Add pretty logger (for debugging)
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }
}