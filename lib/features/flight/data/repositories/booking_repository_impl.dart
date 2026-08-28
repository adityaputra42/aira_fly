import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/connection_checker.dart';
import '../../domain/entities/pnr_entity.dart';
import '../../domain/repository/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/pnr_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const BookingRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, PnrEntity>> createPnr({
    required ContactInput contact,
    required List<PassengerInput> passengers,
    required List<BookingSegmentInput> segments,
    required List<SeatSelectionInput> seatSelections,
    int holdTtlSeconds = 0,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final body = {
        'contact': contact.toJson(),
        'passengers': passengers.map((e) => e.toJson()).toList(),
        'segments': segments.map((e) => e.toJson()).toList(),
        'seat_selections': seatSelections.map((e) => e.toJson()).toList(),
        'hold_ttl_seconds': holdTtlSeconds,
      };

      final response = await remoteDataSource.createPnr(body);
      if (response == null) {
        return left(Failure('Failed to create booking'));
      }

      return right(PnrModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PnrDetailEntity>> getPnr(int id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getPnr(id);
      if (response == null) {
        return left(Failure('Failed to load PNR'));
      }

      return right(PnrDetailModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PnrSummaryEntity>>> listPnrs({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.listPnrs(page: page, limit: limit, status: status);
      if (response == null) {
        return left(Failure('Failed to load bookings'));
      }

      final list = PnrListModel.fromJson(response.data as Map<String, dynamic>);
      return right(list.items);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelPnr(int id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.cancelPnr(id);
      if (response == null) {
        return left(Failure('Failed to cancel booking'));
      }

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
