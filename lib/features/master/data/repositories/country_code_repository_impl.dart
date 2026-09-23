import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/connection_checker.dart';
import '../../domain/entities/country_code_entity.dart';
import '../../domain/repository/country_code_repository.dart';
import '../datasources/country_code_remote_data_source.dart';
import '../models/country_code_model.dart';

class CountryCodeRepositoryImpl implements CountryCodeRepository {
  final CountryCodeRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const CountryCodeRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, List<CountryCodeEntity>>> listCountryCodes({String? search}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.listCountryCodes(search: search);
      if (response == null) {
        return left(Failure('Failed to load country list'));
      }

      final items = (response.data as List? ?? [])
          .map((e) => CountryCodeModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(items);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
