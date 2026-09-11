import '../../domain/entities/fare_class_entity.dart';

class FareClassModel extends FareClassEntity {
  const FareClassModel({
    super.id,
    super.code,
    super.name,
    super.seatClassId,
    super.refundable,
    super.rescheduleable,
    super.baggageKg,
  });

  factory FareClassModel.fromJson(Map<String, dynamic> json) {
    return FareClassModel(
      id: json['id'] as int?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      seatClassId: json['seat_class_id'] as int?,
      refundable: json['refundable'] as bool?,
      rescheduleable: json['rescheduleable'] as bool?,
      baggageKg: (json['baggage_kg'] as num?)?.toInt(),
    );
  }
}

class FareClassListModel {
  final List<FareClassModel> items;
  final int total;

  const FareClassListModel({required this.items, required this.total});

  factory FareClassListModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['Items'] ?? json['items']) as List?;
    return FareClassListModel(
      items: (rawItems ?? [])
          .map((e) => FareClassModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['Total'] ?? json['total'] ?? 0) as int,
    );
  }
}
