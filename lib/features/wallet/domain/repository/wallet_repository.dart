import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/wallet_entity.dart';

abstract interface class WalletRepository {
  Future<Either<Failure, BalanceEntity>> getBalance();

  Future<Either<Failure, List<WalletTransactionEntity>>> listTransactions({
    int page,
    int limit,
  });

  /// Opens a DOKU VA to top up the wallet. Balance is only credited once
  /// DOKU's notification arrives -- not immediately after this call.
  Future<Either<Failure, TopupEntity>> topup({required double amount, String? channel});

  Future<Either<Failure, TopupStatusEntity>> getTopupStatus(String code);
}
