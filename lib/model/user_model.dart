import 'dart:convert';

class UserModel {
  String id;
  String name;
  String phone;
  String email;
  String token;
  String fcmToken;
  String profileImage;
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.token,
    required this.fcmToken,
    required this.profileImage,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? token,
    String? fcmToken,
    String? profileImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      token: token ?? this.token,
      fcmToken: fcmToken ?? this.fcmToken,
      profileImage: profileImage ?? this.profileImage,
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
      'profileImage': profileImage,
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
      profileImage: map['profileImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, phone: $phone, email: $email, token: $token, fcmToken: $fcmToken, profileImage: $profileImage)';
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
        other.fcmToken == fcmToken &&
        other.profileImage == profileImage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        token.hashCode ^
        fcmToken.hashCode ^
        profileImage.hashCode;
  }
}
