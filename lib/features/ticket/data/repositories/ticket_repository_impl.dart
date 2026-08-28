import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/connection_checker.dart';
import '../../domain/entities/ticket_entity.dart';
import '../../domain/repository/ticket_repository.dart';
import '../datasources/ticket_remote_data_source.dart';
import '../models/ticket_model.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const TicketRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, CheckInResultEntity>> checkIn({
    required String ticketNumber,
    int? baggageCount,
    String? baggageWeightKg,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.checkIn(
        ticketNumber: ticketNumber,
        baggageCount: baggageCount,
        baggageWeightKg: baggageWeightKg,
      );
      if (response == null) {
        return left(Failure('Failed to check in'));
      }

      return right(CheckInResultModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BoardingPassEntity>> getBoardingPass({
    required int passengerId,
    required int segmentId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getBoardingPass(
        passengerId: passengerId,
        segmentId: segmentId,
      );
      if (response == null) {
        return left(Failure('Boarding pass not found'));
      }

      return right(BoardingPassModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
