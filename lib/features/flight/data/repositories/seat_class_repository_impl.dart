import 'package:fpdart/fpdart.dart';
import 'package:pss_app/core/error/failures.dart';

import 'package:pss_app/features/flight/domain/entities/seat_class_entity.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/connection_checker.dart';
import '../../domain/repository/seat_class_repository.dart';
import '../datasources/seat_class_remote_data_source.dart';
import '../models/seat_class_model.dart';

class SeatClassRepositoryImpl implements SeatClassRepository {
  final SeatClassRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const SeatClassRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, List<SeatClassEntity>>> getSeatClasses({
    int page = 1,
    int limit = 100,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getSeatClasses(page: page, limit: limit);
      if (response == null) {
        return left(Failure('Failed to load fare classes'));
      }

      final list = SeatClassListModel.fromJson(response.data as Map<String, dynamic>);
      return right(list.items);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
