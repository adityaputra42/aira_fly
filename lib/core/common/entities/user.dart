import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String? email;
  final String? fullName;
  final String? username;
  final String? status;
  final int? roleId;

  const User({this.id, this.email, this.fullName, this.username, this.status, this.roleId});

  @override
  List<Object?> get props => [id, email, fullName, username, status, roleId];
}
