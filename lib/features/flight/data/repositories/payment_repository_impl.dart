import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/connection_checker.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repository/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const PaymentRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, PaymentEntity>> createPayment({
    required int pnrId,
    String? channel,
    String? paymentMethod,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.createPayment(
        pnrId: pnrId,
        channel: channel,
        paymentMethod: paymentMethod,
      );
      if (response == null) {
        return left(Failure('Failed to create payment'));
      }

      return right(PaymentModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentViewEntity>> getPayment(int id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getPayment(id);
      if (response == null) {
        return left(Failure('Failed to load payment'));
      }

      return right(PaymentViewModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentViewEntity>> getPaymentByPnr(int pnrId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getPaymentByPnr(pnrId);
      if (response == null) {
        return left(Failure('Failed to load payment for this booking'));
      }

      return right(PaymentViewModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
