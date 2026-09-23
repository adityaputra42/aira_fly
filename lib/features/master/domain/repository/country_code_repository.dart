import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/country_code_entity.dart';

abstract interface class CountryCodeRepository {
  Future<Either<Failure, List<CountryCodeEntity>>> listCountryCodes({String? search});
}
