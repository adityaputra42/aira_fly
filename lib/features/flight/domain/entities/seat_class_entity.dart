import 'package:equatable/equatable.dart';

class SeatClassEntity extends Equatable {
  final int? id;
  final String? code;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SeatClassEntity({this.id, this.code, this.name, this.createdAt, this.updatedAt});
  @override
  List<Object?> get props => [id, code, name, createdAt, updatedAt];
}
