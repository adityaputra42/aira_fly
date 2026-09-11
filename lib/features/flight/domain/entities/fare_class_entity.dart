import 'package:equatable/equatable.dart';

class FareClassEntity extends Equatable {
  final int? id;
  final String? code;
  final String? name;
  final int? seatClassId;
  final bool? refundable;
  final bool? rescheduleable;
  final int? baggageKg;

  const FareClassEntity({
    this.id,
    this.code,
    this.name,
    this.seatClassId,
    this.refundable,
    this.rescheduleable,
    this.baggageKg,
  });

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    seatClassId,
    refundable,
    rescheduleable,
    baggageKg,
  ];
}
