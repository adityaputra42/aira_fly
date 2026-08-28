import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/connection_checker.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repository/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';
import '../models/wallet_model.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const WalletRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, BalanceEntity>> getBalance() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getBalance();
      if (response == null) {
        return left(Failure('Failed to load wallet balance'));
      }

      return right(BalanceModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WalletTransactionEntity>>> listTransactions({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.listTransactions(page: page, limit: limit);
      if (response == null) {
        return left(Failure('Failed to load wallet transactions'));
      }

      final list = WalletTransactionListModel.fromJson(response.data as Map<String, dynamic>);
      return right(list.items);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TopupEntity>> topup({required double amount, String? channel}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.topup(amount: amount, channel: channel);
      if (response == null) {
        return left(Failure('Failed to create topup'));
      }

      return right(TopupModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TopupStatusEntity>> getTopupStatus(String code) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getTopup(code);
      if (response == null) {
        return left(Failure('Failed to load topup status'));
      }

      return right(TopupStatusModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
