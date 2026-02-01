class ApiConstants {
  // Base URL - YOUR LIVE BACKEND!
  static const String baseUrl = 'https://fintrack-backend-jtpb.onrender.com/api';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/users/me';

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}