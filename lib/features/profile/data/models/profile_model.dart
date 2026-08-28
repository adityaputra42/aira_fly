import '../../domain/entities/profile_entity.dart';

class PermissionModel extends PermissionEntity {
  const PermissionModel({super.module, super.resource, super.action});

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      module: json['module'] as String?,
      resource: json['resource'] as String?,
      action: json['action'] as String?,
    );
  }
}

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    super.id,
    super.username,
    super.email,
    super.fullName,
    super.status,
    super.roleId,
    super.roleName,
    super.roleLevel,
    super.permissions,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      fullName: json['full_name'] as String?,
      status: json['status'] as String?,
      roleId: json['role_id'] as int?,
      roleName: json['role_name'] as String?,
      roleLevel: json['role_level'] as int?,
      permissions: (json['permissions'] as List?)
          ?.map((e) => PermissionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class UpdatedProfileModel extends UpdatedProfileEntity {
  const UpdatedProfileModel({
    super.id,
    super.username,
    super.email,
    super.fullName,
    super.status,
    super.roleId,
  });

  factory UpdatedProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdatedProfileModel(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      fullName: json['full_name'] as String?,
      status: json['status'] as String?,
      roleId: json['role_id'] as int?,
    );
  }
}
