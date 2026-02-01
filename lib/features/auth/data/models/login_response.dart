import 'package:equatable/equatable.dart';
import 'user_model.dart';

/// Login Response DTO - matches backend LoginResponse
class LoginResponse extends Equatable {
  final String token;
  final String type;
  final int expiresIn;
  final UserModel user;

  const LoginResponse({
    required this.token,
    required this.type,
    required this.expiresIn,
    required this.user,
  });

  /// Create from JSON (from API response)
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      type: json['type'] as String,
      expiresIn: json['expiresIn'] as int,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [token, type, expiresIn, user];
}