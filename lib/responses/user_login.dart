class UserLoginResponse {
  final String tokenType;
  final int id;
  final String username;
  final List<String> roles;
  final String message;
  final String token;
  final String refreshToken;

  UserLoginResponse({
    required this.tokenType,
    required this.id,
    required this.username,
    required this.roles,
    required this.message,
    required this.token,
    required this.refreshToken,
  });

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(
      tokenType: json['tokenType'],
      id: json['id'],
      username: json['username'],
      roles: List<String>.from(json['roles']),
      message: json['message'],
      token: json['token'],
      refreshToken: json['refresh_token'],
    );
  }
}
