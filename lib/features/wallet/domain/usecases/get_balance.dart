import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/wallet_entity.dart';
import '../repository/wallet_repository.dart';

class GetBalance implements UseCase<BalanceEntity, NoParams> {
  final WalletRepository walletRepository;

  const GetBalance(this.walletRepository);

  @override
  Future<Either<Failure, BalanceEntity>> call(NoParams params) {
    return walletRepository.getBalance();
  }
}
