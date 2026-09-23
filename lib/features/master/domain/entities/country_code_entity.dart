import 'package:equatable/equatable.dart';

class CountryCodeEntity extends Equatable {
  final String? alpha2;
  final String? alpha3;
  final String? name;
  final String? dialCode;

  const CountryCodeEntity({this.alpha2, this.alpha3, this.name, this.dialCode});

  @override
  List<Object?> get props => [alpha2, alpha3, name, dialCode];
}
