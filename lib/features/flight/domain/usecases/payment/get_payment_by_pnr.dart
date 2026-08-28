import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/payment_entity.dart';
import '../../repository/payment_repository.dart';

/// Self-service lookup of the latest payment for a PNR the caller owns --
/// prefer this over booking.getPnr for a "my ticket" / payment-status
/// screen, since it does not require an admin permission.
class GetPaymentByPnr implements UseCase<PaymentViewEntity, GetPaymentByPnrParams> {
  final PaymentRepository paymentRepository;

  const GetPaymentByPnr(this.paymentRepository);

  @override
  Future<Either<Failure, PaymentViewEntity>> call(GetPaymentByPnrParams params) {
    return paymentRepository.getPaymentByPnr(params.pnrId);
  }
}

class GetPaymentByPnrParams {
  final int pnrId;

  const GetPaymentByPnrParams({required this.pnrId});
}
