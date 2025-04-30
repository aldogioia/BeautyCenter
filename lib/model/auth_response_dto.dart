class AuthResponseDto{
  final String userId;
  final String accessToken;
  final String refreshToken;

  AuthResponseDto({
    required this.userId,
    required this.accessToken,
    required this.refreshToken
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json){
    return AuthResponseDto(
      userId: json['userId'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  AuthResponseDto copyWith({
    String? userId,
    String? accessToken,
    String? refreshToken
  }){
    return AuthResponseDto(
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken
    );
  }
}