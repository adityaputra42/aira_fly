import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/wallet_entity.dart';
import '../repository/wallet_repository.dart';

class GetTopupStatus implements UseCase<TopupStatusEntity, GetTopupStatusParams> {
  final WalletRepository walletRepository;

  const GetTopupStatus(this.walletRepository);

  @override
  Future<Either<Failure, TopupStatusEntity>> call(GetTopupStatusParams params) {
    return walletRepository.getTopupStatus(params.code);
  }
}

class GetTopupStatusParams {
  final String code;

  const GetTopupStatusParams({required this.code});
}
