import 'dart:convert';

class UserModel {
  String id;
  String name;
  String phone;
  String email;
  String token;
  String fcmToken;
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.token,
    required this.fcmToken,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? token,
    String? fcmToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      token: token ?? this.token,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'token': token,
      'fcmToken': fcmToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      token: map['token'],
      fcmToken: map['fcmToken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, phone: $phone, email: $email, token: $token, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.token == token &&
        other.fcmToken == fcmToken;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        token.hashCode ^
        fcmToken.hashCode;
  }
}
