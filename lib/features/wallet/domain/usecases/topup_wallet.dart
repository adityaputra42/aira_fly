import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/wallet_entity.dart';
import '../repository/wallet_repository.dart';

/// Opens a DOKU VA. Balance is credited only after DOKU's notification
/// arrives -- poll GetTopupStatus or refresh GetBalance afterwards.
class TopupWallet implements UseCase<TopupEntity, TopupWalletParams> {
  final WalletRepository walletRepository;

  const TopupWallet(this.walletRepository);

  @override
  Future<Either<Failure, TopupEntity>> call(TopupWalletParams params) {
    return walletRepository.topup(amount: params.amount, channel: params.channel);
  }
}

class TopupWalletParams {
  final double amount;
  final String? channel;

  const TopupWalletParams({required this.amount, this.channel});
}
