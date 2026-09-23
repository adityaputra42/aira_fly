import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/country_code_entity.dart';
import '../repository/country_code_repository.dart';

class ListCountryCodes implements UseCase<List<CountryCodeEntity>, ListCountryCodesParams> {
  final CountryCodeRepository repository;

  const ListCountryCodes(this.repository);

  @override
  Future<Either<Failure, List<CountryCodeEntity>>> call(ListCountryCodesParams params) {
    return repository.listCountryCodes(search: params.search);
  }
}

class ListCountryCodesParams {
  final String? search;

  const ListCountryCodesParams({this.search});
}
