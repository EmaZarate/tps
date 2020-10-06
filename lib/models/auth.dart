class Auth {
  final String id;
  final String authToken;
  final int expiresIn;

  Auth({this.id, this.authToken, this.expiresIn});

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      id: json['id'],
      authToken: json['auth_token'],
      expiresIn: json["expires_in"],
    );
  }

  Auth copyWith({String id, String name, bool isSelected}) {
    return Auth(
        id: id ?? this.id,
        authToken: authToken ?? this.authToken,
        expiresIn: expiresIn ?? this.expiresIn);
  }

  toJson() {
    return {
      'id': id,
      'auth_token': authToken,
      'expires_in': expiresIn,
    };
  }
}
