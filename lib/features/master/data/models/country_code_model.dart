import '../../domain/entities/country_code_entity.dart';

class CountryCodeModel extends CountryCodeEntity {
  const CountryCodeModel({super.alpha2, super.alpha3, super.name, super.dialCode});

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) {
    return CountryCodeModel(
      alpha2: json['alpha2'] as String?,
      alpha3: json['alpha3'] as String?,
      name: json['name'] as String?,
      dialCode: json['dial_code'] as String?,
    );
  }
}
