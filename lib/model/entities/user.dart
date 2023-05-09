import 'dart:convert';

class User {
  String username, email, accessToken, refreshToken;
  User(this.username, this.email, this.accessToken, this.refreshToken);

  factory User.fromJson(Map<String, dynamic> json) {
    final username = json["user"]["username"];
    final email = json["user"]["email"];
    final accessToken = json["access_token"];
    final refreshToken = json["refresh_token"];
    return User(username, email, accessToken, refreshToken);
  }

  String toJson() {
    return jsonEncode({
      "user": {
        "username": username,
        "email": email,
      },
      "access_token": accessToken,
      "refresh_token": refreshToken,
    });
  }

  @override
  String toString() {
    return 'User{username: $username}';
  }
}
