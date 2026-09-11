import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/connection_checker.dart';
import '../../domain/entities/fare_class_entity.dart';
import '../../domain/repository/fare_class_repository.dart';
import '../datasources/fare_class_remote_data_source.dart';
import '../models/fare_class_model.dart';

class FareClassRepositoryImpl implements FareClassRepository {
  final FareClassRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const FareClassRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, List<FareClassEntity>>> getFareClasses({
    int page = 1,
    int limit = 200,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getFareClasses(page: page, limit: limit);
      if (response == null) {
        return left(Failure('Failed to load fare classes'));
      }

      final list = FareClassListModel.fromJson(response.data as Map<String, dynamic>);
      return right(list.items);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
