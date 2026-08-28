import '../../domain/entities/airport_entity.dart';

class AirportModel extends AirportEntity {
  const AirportModel({super.id, super.code, super.name, super.city, super.country, super.timezone});

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      id: json['id'] as int?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      timezone: json['timezone'] as String?,
    );
  }
}

class AirportListModel {
  final List<AirportModel> items;
  final int total;

  const AirportListModel({required this.items, required this.total});

  factory AirportListModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['Items'] ?? json['items']) as List?;
    return AirportListModel(
      items: (rawItems ?? []).map((e) => AirportModel.fromJson(e as Map<String, dynamic>)).toList(),
      total: (json['Total'] ?? json['total'] ?? 0) as int,
    );
  }
}
