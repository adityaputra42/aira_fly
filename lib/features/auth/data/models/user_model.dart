import 'dart:convert';

import '../../domain/entities/user_entities.dart';

LoginResponseModel loginResponseModelFromJson(dynamic str) => LoginResponseModel.fromJson((str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  String? accessToken;
  String? refreshToken;
  UserModel? user;
  DateTime? expiresAt;

  LoginResponseModel({this.accessToken, this.refreshToken, this.user, this.expiresAt});

  LoginResponseModel copyWith({
    String? accessToken,
    String? refreshToken,
    UserModel? user,
    DateTime? expiresAt,
  }) => LoginResponseModel(
    accessToken: accessToken ?? this.accessToken,
    refreshToken: refreshToken ?? this.refreshToken,
    user: user ?? this.user,
    expiresAt: expiresAt ?? this.expiresAt,
  );

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
    expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "user": user?.toJson(),
    "expires_at": expiresAt?.toIso8601String(),
  };
}

UserModel userModelFromJson(dynamic json) {
  return UserModel.fromJson(json);
}

String userModelToJson(UserModel data) {
  return json.encode(data.toJson());
}

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.email,
    super.fullName,
    super.username,
    super.status,
    super.roleId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      email: json['email'] as String?,
      fullName: json['full_name'] as String?,
      username: json['username'] as String?,
      status: json['status'] as String?,
      roleId: json['role_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'username': username,
      'status': status,
      'role_id': roleId,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? fullName,
    String? username,
    String? status,
    int? roleId,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      status: status ?? this.status,
      roleId: roleId ?? this.roleId,
    );
  }
}
