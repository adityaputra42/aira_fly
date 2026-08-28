import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/connection_checker.dart';
import '../../domain/entities/ancillary_entity.dart';
import '../../domain/repository/ancillary_repository.dart';
import '../datasources/ancillary_remote_data_source.dart';
import '../models/ancillary_model.dart';

class AncillaryRepositoryImpl implements AncillaryRepository {
  final AncillaryRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const AncillaryRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, List<AncillaryCategoryEntity>>> listCategories({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.listCategories(page: page, limit: limit);
      if (response == null) {
        return left(Failure('Failed to load ancillary categories'));
      }

      final list = AncillaryListModel<AncillaryCategoryModel>.fromJson(
        response.data as Map<String, dynamic>,
        AncillaryCategoryModel.fromJson,
      );
      return right(list.items);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AncillaryItemEntity>>> listCatalog({
    int? categoryId,
    bool activeOnly = true,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.listCatalog(
        categoryId: categoryId,
        activeOnly: activeOnly,
        page: page,
        limit: limit,
      );
      if (response == null) {
        return left(Failure('Failed to load ancillary catalog'));
      }

      final list = AncillaryListModel<AncillaryItemModel>.fromJson(
        response.data as Map<String, dynamic>,
        AncillaryItemModel.fromJson,
      );
      return right(list.items);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AncillaryItemEntity>> getAncillary(int id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getAncillary(id);
      if (response == null) {
        return left(Failure('Failed to load ancillary'));
      }

      return right(AncillaryItemModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AncillaryItemEntity>>> listByFlight(int flightId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.listByFlight(flightId);
      if (response == null) {
        return left(Failure('Failed to load flight ancillaries'));
      }

      final items = (response.data as List)
          .map((e) => AncillaryItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(items);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingAncillaryEntity>> purchase({
    required int pnrId,
    int? passengerId,
    int? segmentId,
    required int ancillaryId,
    int? flightId,
    required int quantity,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final body = {
        'pnr_id': pnrId,
        if (passengerId != null) 'passenger_id': passengerId,
        if (segmentId != null) 'segment_id': segmentId,
        'ancillary_id': ancillaryId,
        if (flightId != null) 'flight_id': flightId,
        'quantity': quantity,
      };

      final response = await remoteDataSource.purchase(body);
      if (response == null) {
        return left(Failure('Failed to purchase ancillary'));
      }

      return right(BookingAncillaryModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingAncillaryEntity>> cancelPurchase(int id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.cancelPurchase(id);
      if (response == null) {
        return left(Failure('Failed to cancel ancillary purchase'));
      }

      return right(BookingAncillaryModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingAncillaryEntity>>> listPurchasesByPnr(int pnrId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.listPurchasesByPnr(pnrId);
      if (response == null) {
        return left(Failure('Failed to load purchases'));
      }

      final items = (response.data as List)
          .map((e) => BookingAncillaryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(items);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
