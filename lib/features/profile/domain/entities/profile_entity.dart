import 'package:equatable/equatable.dart';

class PermissionEntity extends Equatable {
  final String? module;
  final String? resource;
  final String? action;

  const PermissionEntity({this.module, this.resource, this.action});

  @override
  List<Object?> get props => [module, resource, action];
}

class ProfileEntity extends Equatable {
  final int? id;
  final String? username;
  final String? email;
  final String? fullName;
  final String? status;
  final int? roleId;
  final String? roleName;
  final int? roleLevel;
  final List<PermissionEntity>? permissions;

  const ProfileEntity({
    this.id,
    this.username,
    this.email,
    this.fullName,
    this.status,
    this.roleId,
    this.roleName,
    this.roleLevel,
    this.permissions,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    fullName,
    status,
    roleId,
    roleName,
    roleLevel,
    permissions,
  ];
}

/// PUT /auth/me response -- a plain user row (no role/permissions
/// attached). Only full_name and/or email can actually be changed;
/// username, status, and role are never editable through this endpoint.
class UpdatedProfileEntity extends Equatable {
  final int? id;
  final String? username;
  final String? email;
  final String? fullName;
  final String? status;
  final int? roleId;

  const UpdatedProfileEntity({
    this.id,
    this.username,
    this.email,
    this.fullName,
    this.status,
    this.roleId,
  });

  @override
  List<Object?> get props => [id, username, email, fullName, status, roleId];
}
