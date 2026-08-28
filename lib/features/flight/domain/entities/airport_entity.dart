import 'package:equatable/equatable.dart';

class AirportEntity extends Equatable {
  final int? id;
  final String? code;
  final String? name;
  final String? city;
  final String? country;
  final String? timezone;

  const AirportEntity({
    this.id,
    this.code,
    this.name,
    this.city,
    this.country,
    this.timezone,
  });

  @override
  List<Object?> get props => [id, code, name, city, country, timezone];
}
