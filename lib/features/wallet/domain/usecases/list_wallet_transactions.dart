import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/wallet_entity.dart';
import '../repository/wallet_repository.dart';

class ListWalletTransactions
    implements UseCase<List<WalletTransactionEntity>, ListWalletTransactionsParams> {
  final WalletRepository walletRepository;

  const ListWalletTransactions(this.walletRepository);

  @override
  Future<Either<Failure, List<WalletTransactionEntity>>> call(
    ListWalletTransactionsParams params,
  ) {
    return walletRepository.listTransactions(page: params.page, limit: params.limit);
  }
}

class ListWalletTransactionsParams {
  final int page;
  final int limit;

  const ListWalletTransactionsParams({this.page = 1, this.limit = 10});
}
