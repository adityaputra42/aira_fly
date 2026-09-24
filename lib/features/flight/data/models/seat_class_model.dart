import 'dart:convert';

import 'package:pss_app/features/flight/domain/entities/seat_class_entity.dart';

List<SeatClassModel> seatClassModelFromJson(String str) =>
    List<SeatClassModel>.from(json.decode(str).map((x) => SeatClassModel.fromJson(x)));

String seatClassModelToJson(List<SeatClassModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SeatClassModel extends SeatClassEntity {
  const SeatClassModel({super.id, super.code, super.name, super.createdAt, super.updatedAt});

  SeatClassModel copyWith({
    int? id,
    String? code,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SeatClassModel(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory SeatClassModel.fromJson(Map<String, dynamic> json) => SeatClassModel(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class SeatClassListModel {
  final List<SeatClassModel> items;
  final int total;

  const SeatClassListModel({required this.items, required this.total});

  factory SeatClassListModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['Items'] ?? json['items']) as List?;
    return SeatClassListModel(
      items: (rawItems ?? [])
          .map((e) => SeatClassModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['Total'] ?? json['total'] ?? 0) as int,
    );
  }
}
